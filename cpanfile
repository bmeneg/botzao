requires 'Bot::IRC'; # IRC Bot module
requires 'TOML'; # config file
requires 'Mojo::SQLite'; # generic storage
requires 'Mojo::Redis'; # plugins storage

on 'develop' => sub {
    requires 'Test::Perl::Critic::Policy';
    requires 'Perl::Critic';
    requires 'Perl::Critic::Policy::Freenode::Prototypes';
    requires 'Perl::Critic::Policy::Freenode::MultidimensionalArrayEmulation';
};
