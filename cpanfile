requires 'Bot::IRC'; # IRC Bot module
requires 'TOML'; # config file

on 'develop' => sub {
	requires 'Devel::NYTProf'
};

on 'test' => sub {
	requires 'Test2';
	requires 'Test::Perl::Critic';
	requires 'Test::Perl::Critic::Policy';
	requires 'Perl::Critic';
	requires 'Perl::Critic::Policy::Freenode::Prototypes';
	requires 'Perl::Critic::Policy::Freenode::MultidimensionalArrayEmulation';
};
