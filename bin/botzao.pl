#!/usr/bin/env perl
#
# BotZao entry file for running it as an executable
#
# Author: Bruno Meneguele <bmeneg@redhat.com>

# Perl boilerplate
use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

# General lib setup
use FindBin;
use lib "$FindBin::Bin/../lib";
use Getopt::Std;

# Local libs
use BotZao::Core;

$Getopt::Std::STANDARD_HELP_VERSION = 1;
our $VERSION = "0.1";

my %args;
getopts("c:", \%args);

my $cfg_file = undef;
if (defined $args{'c'}) {
	my $file = $args{'c'};

	if (-e $file) {
		$cfg_file = $file;
	}
}

BotZao::Core::init($cfg_file);
BotZao::Core::run(\@ARGV);

sub HELP_MESSAGE {
	print <<~ "_END_HELP";
	Usage: ./BotZao.pl [OPTIONS]
		-c <file>       configuration file
		--help          this help message
		--version       script version
	_END_HELP
}

sub VERSION_MESSAGE {
	print <<~ "_END_VERSION";
	BotZao v$VERSION
	_END_VERSION
}
