package BotZao::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Carp qw(croak);

use BotZao::Log qw(log_debug log_fatal);
use BotZao::Config;
use BotZao::IM;

sub init($cfg_file) {
	my $cfg_loaded = BotZao::Config::load($cfg_file);

	# We don't have log enabled yet, so use Carp directly here
	BotZao::Log::init($cfg_loaded) or croak('failed to initialize logging system');
	BotZao::IM::init($cfg_loaded);
}

# Anything after the '--' is processed in here
sub run($args) {
	unless (BotZao::IM::run($args)) {
		log_fatal('failed to run im');
	}
	return 1;
}

1;
