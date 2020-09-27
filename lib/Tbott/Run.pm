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
        port    => '6697',
        ssl     => 1,
        nick    => 'botiozao',
        join    => ['##tbott'],
    }
);

# Anything after the -- on tbott.pl is processed in here
sub run() {
    ( scalar @ARGV == 1 ) or die 'too many bot argumets';

    say 'load config';
    Tbott::Config::config_load();
    say 'populate bot settings';
    $tbott->run;
}

1;
