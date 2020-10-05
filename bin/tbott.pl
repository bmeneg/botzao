#!/usr/bin/env perl

# Perl boilerplate
use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

# General lib setup
use FindBin;
use lib "$FindBin::Bin/../lib";

# General libs
use Getopt::Std;

# Local libs
use Tbott::Bot;

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

Tbott::Bot::init($cfg_file);
Tbott::Bot::run();

sub HELP_MESSAGE {
    print <<~ "_END_HELP";
    Usage: ./tbott.pl [OPTIONS]
        -c <file>       configuration file
        --help          this help message
        --version       script version
    _END_HELP
}

sub VERSION_MESSAGE {
    print <<~ "_END_VERSION";
    tbott v$VERSION - alpha
    _END_VERSION
}
