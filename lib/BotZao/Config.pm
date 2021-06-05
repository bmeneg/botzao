package BotZao::Config;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use TOML qw(from_toml to_toml);
use Path::Tiny qw(path);
use Hash::Util qw(lock_hash);

use BotZao::Log qw(log_warn);

my $cfg_file_default = '~/.botzao.toml';

# _parse_toml converts the TOML data into a common hash
sub _parse_toml($filename) {
	my $data;
	my $topics;
	my $err;

	# Config file passed by the user has precedence.
	my $cfg_file = $filename // $cfg_file_default;
	if (not -r $cfg_file) {
		log_warn("failed to read $cfg_file");
		return;
	}

	$data = path($cfg_file)->slurp();
	($topics, $err) = from_toml($data);
	if (not $topics) {
		log_warn("error parsing toml: $err", 1);
		return;
	}
	return $topics;
}

# Load the config file (TOML format) to memory in a common hash format and
# lock the hash to avoid further modification.
sub load($filename) {
	my %cfg_loaded = %{_parse_toml($filename)};
	log_warn("using default values.") unless %cfg_loaded;
	# Make sure we don't mess the hash in runtime
	lock_hash(%cfg_loaded);
	return \%cfg_loaded;
}

1;
