package Tbott::Bot;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use Bot::IRC;
use Tbott::Config;

our $tbott;
our %core;

sub _init_bot(%config) {
    %core = (
        logfile => $config{'core'}->{'logfile'} // 'bot.log',
    );

    $tbott = Bot::IRC->new(
        connect => {
            server  => $config{'irc'}->{'server'} // 'chat.freenode.net',
            port    => $config{'irc'}->{'port'} // '6667',
            ssl     => 0,
            nick    => $config{'irc'}->{'nick'} // 'botiozao',
            join    => $config{'irc'}->{'channels'} // ['##tbott'],
        },
    );
}

# Anything after the -- on tbott.pl is processed in here
sub run() {
    my %config;

    die 'too many bot arguments' unless (scalar @ARGV <= 1);

    %config = Tbott::Config::config_load();
    die 'failed to load bot settings' unless %config;
    # DEBUG ONLY
    say Dumper(%config);
    _init_bot(%config);

    $tbott->run;
}

1;
