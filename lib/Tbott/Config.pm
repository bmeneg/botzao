package Tbott::Config;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

my @configs = ('.tbott.toml', '~/.tbott.toml');

sub _compose_config() {
    say 'config: composing configs';
    for my $c (@configs) {
        say '> config: reading '.$c;  
    }
}

sub config_load() {
    say 'config: loading configs';
    _compose_config();
}

1;
