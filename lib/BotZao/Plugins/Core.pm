# This package control the Plugins protocol: how to init, register and call
# them. For that, a callback API is used and every new plugin must adhere to
# that. One function and a hash are required:
#
# - register() => called for registering the plugin. It includes the call to
#       the plugin_add() function with specific plugin information;
# - %{
#     &init_function_reference,
#     &run_function_reference,
#     $trigger_regex
#   }
#
# A hash containing at least the above information is used for lookup later,
# when the bot starts running and handle the messages comming from the server.

package BotZao::Plugins::Core;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use BotZao::Log qw(log_debug log_info log_error log_fatal);

my $cfg_topic = 'core';
my $cfg_opt_plugins = 'plugins';
# array of plugin refs:
# [
#	{ name, &init, &run, trigger, enabled },
#	{ name, &init, &run, trigger, enabled },
#	{ name, &init, &run, trigger, enabled },
# ]
my @enabled_plugins_ref;

# Get all plugins listed in the configuration file and load them dinamically
# by calling their register() function.
sub _init_plugins(%config) {
	my @plugins = @{$config{$cfg_topic}{$cfg_opt_plugins}};

	log_debug("plugins loaded: @plugins");
	foreach (@plugins) {
		my $module = "BotZao::Plugins::$_";

		eval "require $module";
		log_fatal("failed to require plugin module $module: $@") if $@;
		eval "${module}::register()";
		log_fatal("failed to register plugin module $module: $@") if $@;
	}

	foreach my $pinfo (@enabled_plugins_ref) {
		$pinfo->{init}->(%config) or
			log_fatal("failed to load plugin " . $pinfo->{name});
		$pinfo->{enabled} = 1;
	}
	return;
}

# Get plugins information based on their enabled state.
sub export_plugins_info() {
	my @infos;

	foreach my $pinfo (@enabled_plugins_ref) {
		next unless $pinfo->{enabled};
		push @infos, { run => $pinfo->{run}, trigger => $pinfo->{trigger} };
	}
	return \@infos;
}

# Adds the plugin the the array of enabled plugins, that must be checked and
# used later when the bot starts to handle the messages. Beyond the usual data
# this function also adds the $name of the plugin and its state $enabled.
sub plugin_add($name, %info) {
	my %plugin = (
		name => $name,
		init => $info{init},
		run => $info{run},
		trigger => $info{trigger},
		enabled => 0,
	);

	log_debug("plugin added:\n".Dumper(%plugin));
	push @enabled_plugins_ref, \%plugin;
	return;
}

# Default return value expected by the callback API.
sub plugin_ret(@ret_val) {
	return {
		ret_val_count => scalar @ret_val,
		ret_val => \@ret_val,
	};
}

sub init(%config) {
	my @plugins;

	if (not $config{$cfg_topic}{$cfg_opt_plugins}) {
		log_debug("no generic IM plugins were specified");
		return;
	}

	_init_plugins(%config);
	return;
}

1;
