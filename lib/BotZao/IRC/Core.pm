package BotZao::IRC::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Data::Dumper;
use Bot::IRC;
use BotZao::Log qw(log_error);

my $bot;
my %cfg_loaded = (
	irc	=> [ qw(nick password name server port channels plugins) ],
);

sub _init_config(%config) {
	$bot = Bot::IRC->new(
		connect => {
			server	=> $config{'irc'}->{'server'} // 'chat.freenode.net',
			port	=> $config{'irc'}->{'port'} // '6667',
			ssl		=> 0,
			nick	=> $config{'irc'}->{'nick'} // 'botiozao',
			join	=> $config{'irc'}->{'channels'} // ['#BotZao'],
		},
	);
}

sub _init_plugins(@plugins) {
	foreach (@plugins) {
		$bot->load($_);
	}
	return;
}

sub init(%config) {
	my @plugins;

	_init_config(%config);
	@plugins = @{$config{irc}->{plugins}};
	_init_plugins(@plugins);
	return;
}

sub run(@args) {
	if (scalar @args != 1) {
		log_error("irc bot must have one argument only");
		return;
	}

	$bot->run;
	return 1;
}

1;
