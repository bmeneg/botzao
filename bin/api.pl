use v5.20;
use warnings;
use strict;

# Web framework libs
use Mojo::Server::Daemon;

use FindBin;
use lib qq($FindBin::Bin/../lib);

use API::Routes;
use API::MsgQueue;

my $app = Mojo::Server::Daemon->new->build_app("API::Routes");
my $daemon = Mojo::Server::Daemon->new(app => $app);
for (@ARGV) {
	if ($_ eq 'start') {
		$daemon->listen(['http://[::]:3000']);
		$daemon->run;
	} else {
		$daemon->stop;
	}
}

