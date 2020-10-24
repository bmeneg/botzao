package BotZao::IM::Plugins::DaddyJokes;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Bot::IRC;
use BotZao::IM::Plugins::Commands;

my $prefix = BotZao::IM::Plugins::Commands::prefix();
my $name = "DaddyJokes";
my $command = 'joke';
my @cfg_valid = ( qw(jokes_file jokes_redis_url) );

sub init($bot) {
	BotZao::IM::Plugins::Commands::add_channel_cmd($command);
	BotZao::IM::IRC::Core::plugin_add($name, &init);

	$bot->hook(
		{
			to_me	=> 1,
			text	=> qr/(?<cmd>${prefix}joke)(?<ignore>.*)/,
		},
		sub {
			my ( $bot, $in, $m ) = @_;

			return unless BotZao::Commands::has_permission($in->{nick});
			$bot->reply("$in->{nick}, don't use the word: $m->{word}.");
		},
	);
}

1;
