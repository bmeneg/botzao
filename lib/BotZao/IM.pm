# This file basically concentrates the code for initializing and triggering
# the IM protocol engines we have support for.
#
# Author: Bruno Meneguele <bmeneg@redhat.com>

package BotZao::IM;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Plugins::Core;
use BotZao::IRC::Core;

# Init every single IM protocol we support
sub init(%config) {
	BotZao::Plugins::Core::init(%config);
	BotZao::IRC::Core::init(%config);
	return 1;
}

# Trigger the core engine for all protocols we support.
sub run(@args) {
	return BotZao::IRC::Core::run(@args);
}

1;
