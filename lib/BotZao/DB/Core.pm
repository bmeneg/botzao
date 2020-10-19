package BotZao::DB;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use BotZao::DB::Redis;
use BotZao::DB::SQLite;

sub init(%config) {
	return;
}

1;
