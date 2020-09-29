package Tbott::Run;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Bot::IRC;
use Tbott::Config;

our $tbott = Bot::IRC->new(
    connect => {
        server  => 'chat.freenode.net',
        port    => '6667',
        ssl     => 0,
        nick    => 'botiozao',
        join    => ['##tbott'],
    }
);

# Anything after the -- on tbott.pl is processed in here
sub run() {
    my $err;

    die 'too many bot argumets' unless ( scalar @ARGV <= 1 );

    $err = Tbott::Config::config_load();
    die 'failed to load bot settings' unless $err == 0;

    $tbott->run;
}

1;
