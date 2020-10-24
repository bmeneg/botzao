package BotZao::IM::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::IM::IRC::Core;

sub init(%config) {
	BotZao::IM::Plugins::Core::init(%config);
	BotZao::IM::IRC::Core::init(%config);
	return 1;
}

sub run(@args) {
	BotZao::IM::IRC::Core::run(@args) or return;
	return 1;
}

1;
