package BotZao::Config;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use TOML qw(from_toml to_toml);
use Path::Tiny qw(path);
use BotZao::Log qw(log_warn);

my $cfg_file_default = '~/.botzao.toml';
my %cfg_loaded;

sub _unmarshal($filename) {
    my ($cfg_data, $cfg_topics);
    my ($ret_msg, $ret_err);
    my $cfg_file = $cfg_file_default;

    # Config file passed by the user has precedence.
	$cfg_file = $filename if $filename;
	return ("config: failed to read $cfg_file", 1) unless (-r glob($cfg_file));

	$cfg_data = path($cfg_file)->slurp;
	($cfg_topics, $ret_err) = from_toml($cfg_data);
	return ("config: error parsing toml: $ret_err", 1) unless $cfg_topics;

	%cfg_loaded = %$cfg_topics;
    return (undef, 0);
}

sub load($filename) {
    my ($ret_msg, $ret_err);

    ($ret_msg, $ret_err) = _unmarshal($filename);
	log_warn("$ret_msg. Using default values.") if $ret_err;

    return %cfg_loaded;
}

1;
