package Tbott::Bot;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use Bot::IRC;
use Tbott::Config;

our $bot;
our %core;

sub _config_init(%config) {
    %core = (
        logfile => $config{'core'}->{'logfile'} // 'bot.log',
    );

    $bot = Bot::IRC->new(
        connect => {
            server  => $config{'irc'}->{'server'} // 'chat.freenode.net',
            port    => $config{'irc'}->{'port'} // '6667',
            ssl     => 0,
            nick    => $config{'irc'}->{'nick'} // 'botiozao',
            join    => $config{'irc'}->{'channels'} // ['##tbott'],
        },
    );
}

sub init($cfg_file) {
    my %config = Tbott::Config::load($cfg_file);
    die 'failed to load bot settings' unless %config;
    say Dumper(%config); # DEBUG ONLY
    _config_init(%config);
}

# Anything after the -- on tbott.pl is processed in here
sub run() {
    die 'too many bot arguments' unless (scalar @ARGV <= 1);
    $bot->run;
}

1;
