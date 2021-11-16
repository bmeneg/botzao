use Test::More;
use Test::Mojo;

use FindBin;
use lib qq($FindBin::Bin/../../lib);

# Load application
my $t = Test::Mojo->new("API::Routes");

# Allow 3xx redirect responses
$t->ua->max_redirects(1);

# Direct calls to /api should not succeed
$t->get_ok('/api')
	->status_is(404);

# /api/plugins endpoint tests
$t->get_ok('/api/plugins')
	->status_is(200);
is scalar @{$t->tx->res->json}, 3;

while (my ($i, $v) = each @{$t->tx->res->json}) {
	$t->json_is("/$i/name" => "DummyPlugin$i")
		->json_has("/$i/trigger");
}

$t->get_ok('/api/plugins' => form => {name => 'DummyPlugin2'})
	->status_is(200)
	->json_is('/0/name' => 'DummyPlugin2')
	->json_has('/0/trigger');

$t->post_ok('/api/plugins')
	->status_is(400)
	->json_is('/error' => 'missing request body field');

$t->post_ok('/api/plugins' => json => {})
	->status_is(400)
	->json_has('/error');

$t->post_ok('/api/plugins' => json => {name => 'TestPlugin'})
	->status_is(400)
	->json_has('/error');

$t->post_ok('/api/plugins' => json => {name => ''})
	->status_is(400)
	->json_has('/error');

$t->post_ok('/api/plugins' => json => {trigger => 'regex'})
	->status_is(400)
	->json_has('/error');

$t->post_ok('/api/plugins' => json => {trigger => ''})
	->status_is(400)
	->json_has('/error');

$t->post_ok('/api/plugins' => json => {name => 'TestPlugin', trigger => 'regex'})
	->status_is(202)
	->json_is('/id' => '101')
	->header_is('Location' => '/api/queue/101')
	->header_exists('Retry-After');

$t->delete_ok('/api/plugins')
	->status_is(400)
	->json_is('/error' => 'missing request body field');

$t->delete_ok('/api/plugins' => json => {id => 100})
	->status_is(200);

$t->get_ok('/api/plugins/101')
	->status_is(200);
is ref $t->tx->res->json, 'HASH', 'single message';
$t->json_is('/message' => 'bla');

$t->get_ok('/api/plugins/101' => form => {all => 'true'})
	->status_is(200);
is ref $t->tx->res->json, 'ARRAY', 'multiple messages';

# /api/queue endpoint tests
$t->get_ok('/api/queue')
	->status_is(404);

$t->get_ok('/api/queue/101')
	->status_is(200);
is ref $t->tx->res->json, 'HASH', 'single message';
$t->json_is('/message' => 'bla');
# Check the transaction before the redirection
my $res = $t->tx->previous->res;
is $res->code, 303, '303 SEE OTHER';
is $res->headers->location, '/api/plugins/101', 'Correct redirect URL';

$t->get_ok('/api/queue/101' => form => {all => 'true'})
	->status_is(200);
is ref $t->tx->res->json, 'ARRAY', 'multiple messages';
# Check the transaction before the redirection
my $res = $t->tx->previous->res;
is $res->code, 303, '303 SEE OTHER';
is $res->headers->location, '/api/plugins/101?all=true', 'Correct redirect URL';

$t->get_ok('/api/queue/101/status')
	->status_is(200)
	->json_is('/status' => 'queued')
	->json_is('/amount' => 3)
	->json_is('/links/rel' => 'messages')
	->json_is('/links/href' => '/api/plugins/101');

done_testing();
