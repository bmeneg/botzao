package BotZao::Plugins::Core;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Log qw(log_debug log_info log_error);

my $cfg_topic = 'core';
my $cfg_opt_plugins = 'plugins';
# array of plugin refs:
# [
#	{ name, &init, &run, trigger, enabled },
#	{ name, &init, &run, trigger, enabled },
#	{ name, &init, &run, trigger, enabled },
# ]
my @enabled_plugins_ref;

sub _init_plugins(%config) {
	my @plugins = @{$config{$cfg_topic}{$cfg_opt_plugins}};

	log_debug("plugins loaded: @plugins");

	foreach (@enabled_plugins_ref) {
		if (exists $plugins[$_{name}]) {
			&{$_{init}}(%config) or log_error("failed to load generic plugin $_{name}");
			$_{enabled} = 1;
		}
	}
	return;
}

sub export_plugins_info() {
	my @infos;

	foreach (@enabled_plugins_ref) {
		my %plugin_info = (
			{
				run => $_{run},
				trigger => $_{trigger},
			},
		);
		push @infos, ( %plugin_info ) if $_{enabled};
	}
	return undef unless scalar @infos != 0;
	return @infos;
}

sub plugin_add($name, %info) {
	my %plugin = (
		name => "$name",
		init => $info{init},
		run => $info{run},
		trigger => $info{trigger},
		enabled => 0,
	);

	push @enabled_plugins_ref, %plugin;
	return;
}

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
