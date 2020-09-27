package Tbott::Run;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Bot::IRC;
use Tbott::Config;

our $VERSION = '0.01';

our $tbott = Bot::IRC->new(
    connect => {
        server  => 'chat.freenode.net',
        port    => '6697',
        ssl     => 1,
        nick    => 'botiozao',
        join    => ['##tbott'],
    }
);

sub run() {
    say 'load config';
    Tbott::Config::config_load();
    say 'populate bot settings';
    $tbott->run;
}

1;
