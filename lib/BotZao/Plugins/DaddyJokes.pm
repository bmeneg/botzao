# The DaddyJokes plugin is a generic plugin where jokes of the nature Q&A are
# stored in a TXT file somewhere in the system. The answers for each question
# is placed right after the question, meaning that every odd line holds the
# question for which the answer is in the even line right after.
#
# Also, further configuration for this plugin is possible via the
# plugin_DaddyJokes configuration topic in the config file.
#
# This plugin implements all three required functions for the callback API:
# init(), call() and register().
#
# Author: Bruno Meneguele <bmeneg@redhat.com>

package BotZao::Plugins::DaddyJokes;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Encode;

use BotZao::Commands;
use BotZao::Log qw(log_debug log_info log_error);

my $cmd_prefix = BotZao::Commands::prefix();
my $plugin_name = 'DaddyJokes';
my $plugin_cmd = 'joke';

# We allow a custom joke file from configuration file.
my $cfg_opt_file = 'jokes_file';
my $jokes_file = './DaddyJokes.txt';
my $jokes_count;

# _number_of_jokes is useful for setting the upper limit of rand() later,
# for choosing the Q&A themselvs.
sub _number_of_jokes() {
	my $fh;

	unless (open($fh, '<', $jokes_file)) {
		log_error("failed to read file $jokes_file");
		return;
	}
	
	1 while (<$fh>);
	return $. / 2;
}

# Get a random joke (both question and answer) based on the number of jokes
# found in the file.
sub _get_random_qa($max) {
	my $joke_num = int(rand($max));
	my @qa;
	my $fh;

	unless (open($fh, '<', $jokes_file)) {
		log_error("failed to read $jokes_file");
		return;
	}

	while (<$fh>) {
		chomp;

		# we fist get the question based on the random number chosen,
		# then we multiple that by 2 to find the line right before our
		# question and sum 1 to get the question. Reminder: questions
		# are placed in the odd lines, while the answer for that question
		# goes one line after.
		if (not defined $qa[0]) {
			next unless ($. == ($joke_num * 2 + 1));
			$qa[0] = Encode::decode('UTF-8', $_);
		} else {
			$qa[1] = Encode::decode('UTF-8', $_);
			last;
		}
	}

	log_debug('joke list seems empty') if not @qa;
	close($fh);
	return \@qa;
}

# Whenever the regex for this plugin (defined in register()) matches a message,
# this is the function being called.
sub call($user) {
	log_debug("$user asked for a DaddyJokes");
	return unless BotZao::Commands::has_permission($plugin_cmd, $user);

	my @qa = @{ _get_random_qa($jokes_count) };
	if (not @qa) {
		log_error('impossible to get a joke');
		return;
	}
	log_debug('question: ' . $qa[0]);
	log_debug('answer: ' . $qa[1]);
	return \@qa;
}

# Get specific config options for this plugin.
sub _init_config($config) {
	if (exists $config->{"plugin_$plugin_name"}) {
		my %cfg = %{$config->{"plugin_$plugin_name"}};
		$jokes_file = $cfg{$cfg_opt_file} if $cfg{$cfg_opt_file};
	}
	log_info("jokes file set to $jokes_file");
}

# called when initializing the plugin in the plugins system.
sub init($config) {
	log_debug("init");
	_init_config($config);
	$jokes_count = _number_of_jokes() or return;
	return 1;
}

# Plugin callback API function: called when registering the plugin in the
# generic plugin system within each specific IM core.
sub register() {
	my $pinfo = BotZao::Plugins::Core::plugin_create_ref($plugin_name);

	$pinfo->{init} = \&init;
	$pinfo->{run} = \&call;
	$pinfo->{trigger} = qr/${cmd_prefix}[jJ][oO][kK][eE]/;

	log_debug("register");

	unless (BotZao::Plugins::Core::plugin_add($pinfo)) {
		log_error('plugin could not be registered');
		return;
	}
	BotZao::Commands::add_channel_cmd($plugin_cmd);
	return 1;
}

1;
