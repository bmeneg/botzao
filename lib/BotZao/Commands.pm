# This package is intended to be the base for an ACL for each available
# command: check if the user calling a certain command has access to it.
#
# Author: Bruno Meneguele <bmeneg@redhat.com>

package BotZao::Commands;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use BotZao::Log qw(log_debug log_fatal);

# Each perm level relates to the nature/type of the command.
use constant {
	PERM_NONE	=> 0,
	PERM_USER	=> 1,
	PERM_MOD	=> 2,
	PERM_ADMIN	=> 3,
};

# Default commands' prefix
my $prefix = '!';

# Commands are stored with their name as keys and permission as values
# { "<cmd name>" => <permission> }
my %cmd_valid;

# A channel command is simply a command that anyone can call, regerdless
# their role or even if they're registered/following.
sub add_channel_cmd($name) {
	$cmd_valid{$name} = PERM_NONE;
	return;
}

# Only registered users can call user commands.
sub add_user_cmd($name) {
	$cmd_valid{$name} = PERM_USER;
	return;
}

# Only channel moderators/voice can call mod commands.
sub add_mod_cmd($name) {
	$cmd_valid{$name} = PERM_MOD;
	return;
}

# Intended for adminstrative commands
sub add_admin_cmd($name) {
	$cmd_valid{$name} = PERM_ADMIN;
	return;
}

# DEBUG-ONLY: should be in a separated module, when we properly thinl how
# to organize the list of users.
sub _find_db_user_info($user) {
	return;
}

# Check if a certain user has enough access rights to issue the requested
# command. If the command is a "channel" command, it's not even necessary
# to check if the user exists.
sub has_permission($cmd, $user) {
	my %i_user = _find_db_user_info($user);

	return unless exists $cmd_valid{$cmd};
	log_debug("command $cmd exist");
	return 1 if $cmd_valid{$cmd} == PERM_NONE;
	log_debug("command $cmd has permission greater than PERM_NONE");
	return 1 if %i_user and $i_user{perm} >= $cmd_valid{$cmd};
	return;
}

# Return the command prefix recognized by BotZao.
# It might be one different for each command type (channel, user, mod and
# admin).
sub prefix() {
	return $prefix;
}

1;
