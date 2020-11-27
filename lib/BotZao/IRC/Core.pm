package BotZao::IRC::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use Bot::IRC;

use BotZao::IRC::GenericPlugins;
use BotZao::Log qw(log_info log_error);

my $bot;
my %cfg_loaded = (
	irc	=> [ qw(nick password name server port channels plugins) ],
);

sub _init_config(%config) {
	$bot = Bot::IRC->new(
		connect => {
			server	=> $config{irc}{server} // 'chat.freenode.net',
			port	=> $config{irc}{port} // '6697',
			ssl	=> 0,
			ipv6	=> 0,
			nick	=> $config{irc}{nick} // 'botiozao',
			join	=> $config{irc}{channels} // ['#BotZao'],
		},
	);
}

sub init(%config) {
	my @plugins;

	_init_config(%config);

	# Bot-IRC keep the order of added plugins, and generic plugins
	# should take precedence, so overwriting default plugins are possible
	@plugins = @{ BotZao::Plugins::Core::export_plugins_info() };
	BotZao::IRC::GenericPlugins::load(@plugins);
	$bot->load("BotZao::IRC::GenericPlugins");

	@plugins = @{ $config{irc}{plugins} };
	foreach (@plugins) {
		$bot->load($_);
	}

	return;
}

sub run(@args) {
	if (scalar @args != 1) {
		log_error("irc bot must have one argument only");
		return -1;
	}
	$bot->run;
	return;
}

1;
