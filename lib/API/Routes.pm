package API::Routes;

use Mojolicious::Lite -signatures;

use enum qw(
	:HTTP_SUCCESS_=200	OK CREATED ACCEPTED
	:HTTP_REDIRECT_=300	MULTI MOVED FOUND OTHER
	:HTTP_ERROR_CLIENT_=400	BADREQ
);

my @plugins;
my @messages;

# TODO: these are dummy plugins for testing purposes, remove it later.
my %dummy_plugin0 = (
	name => 'DummyPlugin0',
	trigger => '.*'
);
my %dummy_plugin1 = (
	name => 'DummyPlugin1',
	trigger => '!.*'
);
my %dummy_plugin2 = (
	name => 'DummyPlugin2',
	trigger => '!'
);
push @plugins, \%dummy_plugin0;
push @plugins, \%dummy_plugin1;
push @plugins, \%dummy_plugin2;

my $msg1 = 'bla1';
my $msg2 = 'bla2';
my $msg3 = 'bla3';
push @messages, $msg1;
push @messages, $msg2;
push @messages, $msg3;

# TODO: get the number from a real list of plugins.
my $last_plugin_id = 100;

get '/api/plugins' => sub ($c) {
	my $name = $c->param('name') || '';
	
	return $c->render(json => \@plugins) unless $name;

	my @matches;
	push @matches, $_ foreach (grep { $_->{name} eq $name } @plugins);

	return $c->render(json => \@matches);
};

post '/api/plugins' => sub ($c) {
	my $req_json = $c->req->json;

	unless ($req_json && $req_json->{name} && $req_json->{trigger}) {
		return $c->render(
			json => {'error' => 'missing request body field'},
			status => HTTP_ERROR_CLIENT_BADREQ
		);
	}

	my $name = $req_json->{name};
	my $trigger = $req_json->{trigger};
	my $id = ++$last_plugin_id;

	$c->res->headers->location("/api/queue/$id");
	$c->res->headers->header('Retry-After', '2');
	return $c->render(
		json => {'id' => "$id"},
		status => HTTP_SUCCESS_ACCEPTED
	);
};

del '/api/plugins' => sub ($c) {
	my $req_json = $c->req->json;

	unless ($req_json && $req_json->{id}) {
		return $c->render(
			json => {'error' => 'missing request body field'},
			status => HTTP_ERROR_CLIENT_BADREQ
		);
	}

	# TODO: check if plugin ID is indeed registered and delete it
	my $id = $req_json->{id};
	return $c->rendered;
};

get '/api/plugins/:id' => sub($c) {
	my $all = $c->param('all') || '';

	# TODO: get the actual plugin messages
	return $c->render(json => {message => 'bla'}) unless $all;
	my @msgs_json = map { +{ message => $_ } } @messages;
	return $c->render(json => \@msgs_json);	
};

get '/api/queue/:id' => sub ($c) {
	# TODO: fix it to fetch real data from the bot
	my $has_content = 1;
	my $all = $c->param('all') || '';

	if (not $has_content) {
		return $c->render(
			json => { status => 'no new messages'},
			status => HTTP_SUCCESS_OK
		);
	}
	
	my $id = $c->stash('id');

	if ($all) {
		$c->res->headers->location("/api/plugins/$id?all=$all");
	} else {
		$c->res->headers->location("/api/plugins/$id");
	}
	
	return $c->rendered(HTTP_REDIRECT_OTHER);
};

get '/api/queue/:id/status' => sub ($c) {
	my $has_content = 1;

	return $c->render(json => { status => 'no new message' }) unless $has_content;

	my $id = $c->param('id');
	return $c->render(
		json => {
			status => 'queued',
			amount => scalar @messages,
			links => {
				rel => 'messages',
				href => "/api/plugins/$id"
			}
		}
	);
};

