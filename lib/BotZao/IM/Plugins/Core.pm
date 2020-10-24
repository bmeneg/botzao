package BotZao::IM::Plugins::Core;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings experimental qw(signatures);

use BotZao::Log qw(log_error);

# plugin hash = { name => sub_run_ref }
my %plugins_hash;

sub _init_plugins(@plugins) {
	foreach (keys %plugins_hash) {
		$plugins_hash{$_}() or log_error("failed to load irc plugin $_");
	}
	return;
}

sub plugin_add($name, $sub_ref) {
	plugins_table{$name} = $sub_ref;
}

sub init(%config) {
	my @plugins;

	_init_config(%config);
	@plugins = @{$config{im}->{plugins}};
	_init_plugins(@plugins);
	return;
}

1;
