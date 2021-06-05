package BotZao::IRC::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Bot::IRC;

use BotZao::IRC::GenericHook;
use BotZao::Log qw(log_info log_error);

my $bot;
my %cfg_loaded = (
	irc	=> [ qw(nick password name server port channels plugins) ],
);

# Initialize the Bot-IRC module with the config file information.
# TODO: redirect Bot-IRC output to the same as BotZao.
sub _init_config(%config) {
	$bot = Bot::IRC->new(
		connect => {
			server	=> $config{irc}{server} // 'irc.libera.chat',
			port	=> $config{irc}{port} // '6697',
			ssl	=> 0,
			ipv6	=> 0,
			nick	=> $config{irc}{nick} // 'botiozao',
			join	=> $config{irc}{channels} // ['##BotZao'],
		},
	);
}

sub init(%config) {
	my @plugins;

	_init_config(%config);

	# Bot-IRC keep the order of added plugins, and generic plugins
	# should take precedence, so overwriting default plugins are possible
	@plugins = @{ BotZao::Plugins::Core::export_plugins_info() };
	BotZao::IRC::GenericHook::load(\@plugins);
	$bot->load("BotZao::IRC::GenericHook");

	# Load the IRC specific plugins from config file
	@plugins = @{ $config{irc}{plugins} };
	foreach (@plugins) {
		$bot->load($_);
	}

	return;
}

# run must be called only once plugins are properly setup.
sub run($args) {
	if (scalar @$args != 1) {
		log_error("IRC:Core: bot must have one argument only");
		return -1;
	}
	$bot->run();
	return;
}

1;
