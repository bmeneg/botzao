package BotZao::Plugins::DaddyJokes;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::Commands;
use BotZao::Log qw(log_debug log_fatal);
use Bot::IRC;

my $cmd_prefix = BotZao::Commands::prefix();
my $plugin_name = "DaddyJokes";
my $plugin_cmd = 'joke';
my $cfg_opt_file = 'jokes_file';
my $jokes_file = "./DaddyJokes.txt";
my $jokes_count;

sub _number_of_jokes() {
	open(my $fh, '<', $jokes_file) or log_fatal("failed to read file $jokes_file");
	1 while (<$fh>);
	return $. / 2;
}

sub _get_random_qa($max) {
	my $joke_num = int(rand($max));
	my $q;

	if (not -r $jokes_file) {
		log_error("failed to read file $jokes_file");
		return (-1, -1);
	}

	open(my $fh, '<', $jokes_file);
	while (<$fh>) {
		if (not defined $q) {
			next unless ($. == ($joke_num * 2 + 1));
			$q = $_;
			next;
		}
		return ($q, $_);
	}
	return (undef, undef);
}

sub call($user) {
	log_debug("$user asked for a DaddyJokes");
	return unless BotZao::IM::Commands::has_permission($user);

	my ($q, $a) = _get_random_qa($jokes_count);
	log_error("joke index greater than joke count") unless $q;
	return BotZao::IM::Plugins::Core::plugin_ret($q, $a);
}

sub _init_config(%config) {
	my %cfg;

	if (exists $config{plugin_$plugin_name}) {
		%cfg = %{$config{plugin_$plugin_name}};
		$jokes_file = $cfg{$cfg_opt_file} if $cfg{$cfg_opt_file};
		log_info("DaddyJokes file set to $jokes_file");
	}
	return;
}

sub init(%config) {
	_init_config(%config);
	$jokes_count = _number_of_jokes();
}

my %plugin_info = (
	init => \&init,
	run => \&call,
	trigger => qr/\b${cmd_prefix}[jJ][oO][kK][eE]\b/,
);

BotZao::IM::Plugins::Core::plugin_add($plugin_name, %plugin_info);
BotZao::IM::Commands::add_channel_cmd($plugin_cmd);

1;
