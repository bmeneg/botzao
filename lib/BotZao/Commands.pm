package BotZao::Commands;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use BotZao::Log qw(log_debug log_fatal);

use constant {
	PERM_NONE	=> 0,
	PERM_USER	=> 1,
	PERM_MOD	=> 2,
	PERM_ADMIN	=> 3,
};

# Commands are separated by nature:
my $prefix = '!';

# Commands are stored with their name as keys and permission as values
# { "<cmd name>" => <permission> }
my %cmd_valid;

sub add_channel_cmd($name) {
	$cmd_valid{$name} = PERM_NONE;
	return;
}

sub add_user_cmd($name) {
	$cmd_valid{$name} = PERM_USER;
	return;
}

sub add_mod_cmd($name) {
	$cmd_valid{$name} = PERM_MOD;
	return;
}

sub add_admin_cmd($name) {
	$cmd_valid{$name} = PERM_ADMIN;
	return;
}

sub _find_db_user_info($user) {
	# DEBUG-ONLY: should be in a separated module
	return;
}

sub has_permission($cmd, $user) {
	my %i_user = _find_db_user_info($user);

	return unless exists $cmd_valid{$cmd};
	log_debug("command $cmd exist: " . Dumper($cmd_valid{$cmd}));
	return 1 if $cmd_valid{$cmd} == PERM_NONE;
	log_debug("command $cmd has permission greater than PERM_NONE");
	return 1 if %i_user and $i_user{perm} >= $cmd_valid{$cmd};
	return;
}

sub prefix() {
	return $prefix;
}

1;
