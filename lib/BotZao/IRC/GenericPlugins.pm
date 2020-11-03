package BotZao::IRC::GenericPlugins;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Bot::IRC;
use BotZao::Log qw(log_info log_error);
use BotZao::Plugins::Core;

my @generic_plugins;

sub init(@args) {
	my $bot = shift @args;
	my $plugin_count = 0;

	foreach my $plugin (@generic_plugins) {
		$plugin_count++;
		$bot->hook(
			{
				to_me => 0,
				text => $plugin->{trigger},
			},
			sub {
				my ( $bot, $in, $m ) = @_;
				my %ret = &{$plugin->{run}}($in->{nick});

				foreach (0 .. $ret{ret_val_count}) {
					$bot->reply("$ret{ret_val}->[$_]");
				}
			},
		);
	}
	log_info("general plugins setup: $plugin_count");
	return;
}

sub load(@plugins) {
	@generic_plugins = @plugins;
}

1;
