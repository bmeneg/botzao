package BotZao::IM;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Plugins::Core;
use BotZao::IRC::Core;

sub init(%config) {
	BotZao::Plugins::Core::init(%config);
	BotZao::IRC::Core::init(%config);
	return 1;
}

sub run(@args) {
	BotZao::IRC::Core::run(@args) or return;
	return 1;
}

1;
