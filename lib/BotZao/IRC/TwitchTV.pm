# This is the TwitchTV core module.
# It handles mostly the access portion of the protocol, since the actual bot
# code is done somewhere else.
#
# The official TwitchTV chatbot documentation can be found at:
# https://dev.twitch.tv/docs/irc
#
# To start with, we need three infos:
# 1) BOT_USERNAME => bot username, it can be your own or a specific bot account
# 2) CHANNEL_NAME => the channel where you want to run the bot
# 3) OAUTH_TOKEN  => the authentication token of your bot with TwitchTV
#
# All of them are passed through the configuration file in the form:
# 
# [irc_TwitchTV]
# username = ""
# channels = ""
# token = ""
#
# You can use directly the [irc] topic, however using the _TwitchTV sub-topic
# guarantees that the server will be always up-to-date.

package BotZao::IRC::TwitchTV;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

my %ttv_config = (
	server => 'irc.chat.twitch.tv',
	username => undef,
	channel => undef,
	token => undef
);

sub _init_config($config) {
	return unless exists $config->{irc_TwitchTV};

	$ttv_config{username} = $config->{irc_TwitchTV}{username};
	$ttv_config{channel} = [ '#' . $config->{irc_TwitchTV}{channel} ];
	$ttv_config{token} = $config->{irc_TwitchTV}{token};
	return \%ttv_config;
}

sub config_override($global_config) {
	return $global_config unless exists $global_config->{irc_TwitchTV};

	my $tmp_config = { %$global_config{irc} };
	$tmp_config->{nick} = lc($ttv_config{username});
	$tmp_config->{channel} = [ $ttv_config{channel} ];
	$tmp_config->{password} = $ttv_config{token};
	$tmp_config->{ssl} = 0;
	$tmp_config->{server} = 'irc.chat.twitch.tv';
	$tmp_config->{port} = '6667';

	$global_config->{irc} = { %$tmp_config };
	return $global_config;
}

sub init($config) {
	return unless $config;
	return _init_config($config);
}
