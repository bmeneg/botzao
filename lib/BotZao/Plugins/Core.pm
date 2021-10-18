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
#
# Plugins must not break the core during their init or run time, thus plugins
# aren't allowed to call log_fatal() and, thus, any plugin returning errors
# are skipped.

package BotZao::Plugins::Core;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Log qw(log_debug log_info log_warn log_error log_fatal);

my $cfg_topic = 'core';
my $cfg_opt_plugins = 'plugins';

# Plugin information hash, used throughout the plugin infra code
my %plugin_ref = (
	name => undef,    # string
	init => undef,    # function ref
	run => undef,     # function ref
	trigger => undef, # regex string
	enabled => undef  # boolean
);
my @enabled_plugins_ref;

# Get all plugins listed in the configuration file and load them dinamically
# and call their register() function.
sub _init_plugins($config) {
	my @plugins = @{$config->{$cfg_topic}{$cfg_opt_plugins}};

	foreach (@plugins) {
		log_debug('loaded: ' . $_);
		my $module = "BotZao::Plugins::$_";

		{
			local $@;
			eval "require $module";
			if ($@) {
				log_warn("failed to require module $module: $@. skipping.");
				return;
			}
			# register() must return a defined value on success.
			eval "${module}::register() or die";
			if ($@) {
				log_warn("failed to register plugin $module: $@. skipping.");
				return;
			}
		}
	}

	foreach my $pinfo (@enabled_plugins_ref) {
		unless ($pinfo->{init}->($config)) {
			log_warn("failed to init $pinfo->{name}. skipping plugin.");
			continue;
		};
		$pinfo->{enabled} = 1;
	}
}

# Get plugins information based on their enabled state.
sub export_plugins_info() {
	my @infos;

	foreach my $pinfo (@enabled_plugins_ref) {
		next unless $pinfo->{enabled};
		push @infos, {
				name => $pinfo->{name},
				run => $pinfo->{run},
				trigger => $pinfo->{trigger}
			};
	}
	return \@infos;
}

# Create a copy of the plugin info specification hash and returns to the
# plugin requiring it.
sub plugin_create_ref($name) {
	my %pinfo = %plugin_ref;

	$pinfo{name} = $name;
	$pinfo{enabled} = 0;
	return \%pinfo;
}

# Adds the plugin the the array of enabled plugins, that must be checked and
# used later when the bot starts to handle the messages. Beyond the usual data
# this function also adds the $name of the plugin and its state $enabled.
sub plugin_add($info) {
	foreach my $k (keys %$info) {
		if (not defined $info->{$k}) {
			my $pname = $info->{name} // 'unknown';
			log_warn("\"$pname\" field \"$k\" undefined");
			return;
		}
	}

	log_debug("added: \"$info->{name}\", \"$info->{trigger}\"");
	push @enabled_plugins_ref, $info;
	return 1;
}

sub init($config) {
	my @plugins;

	unless ($config->{$cfg_topic}{$cfg_opt_plugins}) {
		log_debug('no generic IM plugins were specified');
		return;
	}

	_init_plugins($config);
}

1;
