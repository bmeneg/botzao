package BotZao::IM::Plugins::Core;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Log qw(log_debug log_info log_error);

# plugin hash = { name => sub_run_ref }
my %plugins_hash;

sub _init_plugins($config, @plugins) {
	foreach (keys %plugins_hash) {
		$plugins_hash{$_}($config) or log_error("failed to load irc plugin $_");
	}
	return;
}

sub plugin_add($name, $sub_ref) {
	plugins_table{$name} = $sub_ref;
}

sub init(%config) {
	my @plugins;

	if (not $config{im}) {
		log_debug("no generic IM plugins were specified");
		return;
	}

	@plugins = @{$config{im}->{plugins}};
	log_debug("plugins loaded: @plugins");
	_init_plugins(%config, @plugins);
	return;
}

1;
