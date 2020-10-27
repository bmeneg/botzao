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
use BotZao::IM::Core;

my %cfg_loaded;

sub init($cfg_file) {
	%cfg_loaded = BotZao::Config::load($cfg_file);

	BotZao::Log::init(%cfg_loaded) or croak('failed to initialize logging system');
	BotZao::IM::Core::init(%cfg_loaded) or log_fatal('failed to initialize im');

	log_debug("".Dumper(%cfg_loaded));
}

# Anything after the '--' is processed in here
sub run(@args) {
	BotZao::IM::Core::run(@args) or log_fatal('failed to run im');
	return;
}

1;
