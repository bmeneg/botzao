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

use BotZao::Commands;
use BotZao::Log qw(log_debug log_info log_error log_fatal);

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
	open(my $fh, '<', $jokes_file) or
		log_fatal("Plugins:$plugin_name: failed to read file $jokes_file");
	1 while (<$fh>);
	return $. / 2;
}

# Get a random joke (both question and answer) based on the number of jokes
# found in the file.
sub _get_random_qa($max) {
	my $joke_num = int(rand($max));
	my @qa;

	if (not -r $jokes_file) {
		log_error("Plugins:$plugin_name: failed to read file $jokes_file");
		return;
	}

	open(my $fh, '<', $jokes_file);
	while (<$fh>) {
		chomp;

		# we fist get the question based on the random number chosen,
		# then we multiple that by 2 to find the line right before our
		# question and sum 1 to get the question. Reminder: questions
		# are placed in the odd lines, while the answer for that question
		# goes one line after.
		if (not defined $qa[0]) {
			next unless ($. == ($joke_num * 2 + 1));
			$qa[0] = $_;
		} else {
			$qa[1] = $_;
			last;
		}
	}

	close($fh);
	return \@qa;
}

# Whenever the regex for this plugin (defined in register()) matches a message,
# this is the function being called.
sub call($user) {
	log_debug("Plugins:$plugin_name: $user asked for a DaddyJokes");
	return unless BotZao::Commands::has_permission($plugin_cmd, $user);

	my @qa = @{ _get_random_qa($jokes_count) };
	if (not @qa) {
		log_error("Plugins:$plugin_name: joke index greater than joke count");
		return;
	}
	log_debug("Plugins:$plugin_name: question: " . $qa[0]);
	log_debug("Plugins:$plugin_name: answer: " . $qa[1]);
	return \@qa;
}

# Get specific config options for this plugin.
sub _init_config(%config) {
	if (exists $config{"plugin_$plugin_name"}) {
		my %cfg = %{$config{"plugin_$plugin_name"}};
		$jokes_file = $cfg{$cfg_opt_file} if $cfg{$cfg_opt_file};
		log_info("Plugins:$plugin_name: file set to $jokes_file");
	}
	return;
}

# called when initializing the plugin in the plugins system.
sub init(%config) {
	log_debug("Plugins:${plugin_name}: init");
	_init_config(%config);
	$jokes_count = _number_of_jokes();
}

# Plugin callback API function: called when registering the plugin in the
# generic plugin system within each specific IM core.
sub register() {
	my $pinfo = BotZao::Plugins::Core::plugin_create_ref($plugin_name);

	$pinfo->{init} = \&init;
	$pinfo->{run} = \&call;
	$pinfo->{trigger} = qr/${cmd_prefix}[jJ][oO][kK][eE]/;

	log_debug("Plugins:$plugin_name: register");

	BotZao::Plugins::Core::plugin_add($pinfo);
	BotZao::Commands::add_channel_cmd($plugin_cmd);
	return;
}

1;
