package BotZao::IM::Commands;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Log qw(log_fatal);

use constant {
	PERM_NONE	=> 0,
	PERM_USER	=> 1,
	PERM_MOD	=> 2,
	PERM_ADMIN	=> 3,
};

# Commands are separated by nature:
my $prefix = '!';

# Commands are stored based on their required permission:
my %cmd_valid = (
	channel	=> {
		perm	=> PERM_NONE,
		cmds	=> [],
	},
	user	=> {
		perm	=> PERM_USER,
		cmds	=> [],
	},
	mod	=> {
		perm	=> PERM_MOD,
		cmds	=> [],
    },
	admin	=> {
		perm	=> PERM_ADMIN,
		cmds	=> [],
	},
);

sub _add_cmd($perm, $name) {
	my $type;

	log_fatal('command name must not be empty') if length $name == 0;

	for ($perm) {
		when (PERM_NONE) { $type = 'channel' };
		when (PERM_USER) { $type = 'user' };
		when (PERM_MOD) { $type = 'mod' };
		when (PERM_ADMIN) { $type = 'admin' };
	}
	push @{$cmd_valid{$type}{cmds}}, ($name);
	return;
}

sub add_channel_cmd($name) {
	_add_cmd(PERM_NONE, $name);
	return;
}

sub add_user_cmd($name) {
	_add_cmd(PERM_USER, $name);
	return;
}

sub add_mod_cmd($name) {
	_add_cmd(PERM_MOD, $name);
	return;
}

sub add_admin_cmd($name) {
	_add_cmd(PERM_ADMIN, $name);
	return;
}

sub has_permission($user, $cmd) {
	return if not exists $cmd_valid{cmd};
	return 1 if $cmd_valid{cmd}{perm} == PERM_NONE;
	return 1 if $user && $user{perm} >= $cmd_valid{cmd}{perm};
	return;
}

sub prefix() {
	return $prefix;
}
