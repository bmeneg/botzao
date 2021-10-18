package BotZao::IRC::Core;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Bot::IRC;

use BotZao::IRC::GenericHook;
use BotZao::Log qw(log_debug log_info log_error);
use BotZao::IRC::TwitchTV;

my $bot;

# Initialize the Bot-IRC module with the config file information.
# TODO: redirect Bot-IRC output to the same as BotZao.
sub _init_config($config) {
	return unless exists $config->{irc};

	my $bot_conn = {
			server	=> $config->{irc}{server} // 'irc.libera.chat',
			port	=> $config->{irc}{port} // '6697',
			ssl	=> 0,
			ipv6	=> 0,
			nick	=> $config->{irc}{nick} // 'botiozao',
			join	=> $config->{irc}{channels} // ['##BotZao'],
			password => $config->{irc}{password} // undef,
	};
	my $send_user_nick_ev = 'on_connect';

	# Check if there's any TwitchTV-specific configuration and
	# overwrite what's needed in Bot-IRC connection.
	my $ttv_config = BotZao::IRC::TwitchTV::init($config);
	if ($ttv_config) {
		$bot_conn->{server} = $ttv_config->{server};
		$bot_conn->{username} = $ttv_config->{username};
		$bot_conn->{join} = $ttv_config->{channel};
		$bot_conn->{password} = $ttv_config->{token};
		# $send_user_nick_ev = 'on_reply';
	}

	$bot = Bot::IRC->new(
		send_user_nick => $send_user_nick_ev,
		connect => $bot_conn
	);
}

sub init($config) {
	# Initialize bot configuration
	_init_config($config);

	# Bot-IRC keep the order of added plugins, and generic plugins
	# should take precedence, so overwriting default plugins are possible
	my @plugins = @{ BotZao::Plugins::Core::export_plugins_info() };
	BotZao::IRC::GenericHook::load(\@plugins);
	$bot->load("BotZao::IRC::GenericHook");

	# Load the Bot-IRC specific plugins from config file
	@plugins = @{$config->{irc}{plugins}};
	foreach (@plugins) {
		$bot->load($_);
	}
}

# run must be called only once plugins are properly setup.
sub run($args) {
	if (scalar @$args != 1) {
		log_error("bot must have one argument only");
		return;
	}
	log_debug("running with args \"@$args\"");
	my $bot_pass = $bot->settings("connect")->{password};
	$bot->run("/PASS $bot_pass");
	log_info("irc core is running");

	log_debug("PASS $bot_pass");
	$bot->say("PASS $bot_pass") if $bot_pass;

	return 1;
}

1;
