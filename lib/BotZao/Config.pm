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

sub _unmarshal($filename) {
	my $data;
	my $topics;
	my $err;

	# Config file passed by the user has precedence.
	my $cfg_file = $filename // $cfg_file_default;
	if (not -r $cfg_file) {
		log_warn("config: failed to read $cfg_file");
		return;
	}

	$data = path($cfg_file)->slurp;
	($topics, $err) = from_toml($data);
	if (not $topics) {
		log_warn("config: error parsing toml: $err", 1);
		return;
	}
	return $topics;
}

sub load($filename) {
	my %cfg_loaded = %{_unmarshal($filename)};
	log_warn("Using default values.") unless %cfg_loaded;
	return %cfg_loaded;
}

1;
