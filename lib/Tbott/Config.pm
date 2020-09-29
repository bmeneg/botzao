package Tbott::Config;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use TOML qw(from_toml to_toml);
use Path::Tiny qw(path);

# We have two basic structures here: 1 hash containing the valid config
# options, and another hash to store tha actual values.
our %cfg_valid = (
    'core'    => [ qw(logfile) ],
    'irc'     => [ qw(nick password name server port channels) ],
);

our %cfg_loaded;

# List of config file to be considered in priority order
my @cfg_files = ('~/.tbott.toml');

sub _is_cfg_valid($topic, $option = undef) {
    if (not defined $topic) {
        return ("config: topic can be null", 1);
    }

    if (not defined $option) {
        return ("", 0) if exists $cfg_valid{$topic};
        return ("config: invalid topic: $topic", 1);
    }

    return ("", 0) if grep { $_ eq $option } @{$cfg_valid{$topic}};
    return ("config: invalid option: $topic.$option", 1);
}

sub _toml_unmarshal_to_config(%data) {
    my ($ret_msg, $ret_err);

    # Check config topic and option if they're valid ones
    while (my ($topic, $opts) = each %data) {
        ($ret_msg, $ret_err) = _is_cfg_valid($topic);
        return ($ret_msg, $ret_err) unless $ret_err == 0;

        foreach my $opt (keys %$opts) {
            ($ret_msg, $ret_err) = _is_cfg_valid($topic, $opt);
            return ($ret_msg, $ret_err) unless $ret_err == 0;
        }
    }

    return ("", 0);
}

sub _compose_config() {
    my ($cfg_data, $cfg_topics);
    my ($ret_msg, $ret_err);

    foreach my $file (@cfg_files) {
        next unless (-r glob($file));
        $cfg_data = path($file)->slurp;
        ($cfg_topics, $ret_err) = from_toml($cfg_data);
        return ("config: error parsing toml: $ret_err", 1) unless $cfg_topics;
        ($ret_msg, $ret_err) = _toml_unmarshal_to_config(%$cfg_topics);
        return ($ret_msg, $ret_err) unless $ret_err == 0;
    }

    return ("", 0)
}

sub config_load() {
    my ($ret_msg, $ret_err);

    ($ret_msg, $ret_err) = _compose_config();
    if ($ret_err != 0) {
        say "$ret_msg";
        return 1;
    }

    return 0;
}

1;
