package BotZao::IM::Commands;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use constant {
	CMD_CHANNEL	=> 0,
	CMD_USER	=> 1,
	CMD_ADMIN	=> 2,
};

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

sub add_channel_cmd($name) {
	if (defined $name || length $name != 0) {
		push @{$cmd_valid{channel}{cmds}}, ($name);
	}
	return;
}

sub add_user_cmd($name) {
	if (defined $name || length $name != 0) {
		push @{$cmd_valid{user}{cmds}}, ($name);
	}
	return;
}

sub add_mod_cmd($name) {
	if (defined $name || length $name != 0) {
		push @{$cmd_valid{mod}{cmds}}, ($name);
	}
	return;
}

sub add_admin_cmd($name) {
	if (defined $name || length $name != 0) {
		push @{$cmd_valid{admin}->{cmds}}, ($name);
	}
	return;
}

sub has_permission($user, $request) {
	return;
}

sub prefix() {
	return $prefix;
}
