package BotZao::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use Carp qw(croak);

use BotZao::Log qw(log_debug log_fatal);
use BotZao::Config;
use BotZao::IM;

sub init($cfg_file) {
	my %cfg_loaded = %{BotZao::Config::load($cfg_file)};

	# We don't have log enabled yet, so use Carp directly here
	BotZao::Log::init(%cfg_loaded) or croak('failed to initialize logging system');
	# Finally, some logging
	BotZao::IM::init(%cfg_loaded) or log_fatal('failed to initialize im');
	log_debug(''.Dumper(%cfg_loaded));
}

# Anything after the '--' is processed in here
sub run(@args) {
	my $err = BotZao::IM::run(@args);
	log_fatal('failed to run im') if $err;
	return;
}

1;
