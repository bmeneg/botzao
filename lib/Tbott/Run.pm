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
    spawn   => 2,
    deamon  => {
        name    => 'tbott_d',
        lsb_sdesc   => 'Chatbot Tiozao',
        pid_file    => 'botiozao.pid',
        stderr_file => 'botiozao.err',
        stdout_file => 'botiozao.log',
    },
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
