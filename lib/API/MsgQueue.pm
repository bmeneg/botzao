package API::MsgQueue;

use v5.20;
use strict;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use Net::AMQP::RabbitMQ;

my $mq = Net::AMQP::RabbitMQ->new();
$mq->connect("localhost", {
	user => 'guest',
	password => 'guest'
});
$mq->channel_open(1);
$mq->queue_declare(1, 'plugins');
$mq->publish(1, 'plugins', 'new plugin!');

my $gotten = $mq->get(1, 'plugins');
say $gotten->{body};
$mq->disconnect;

1;
