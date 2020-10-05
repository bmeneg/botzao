requires 'Bot::IRC', '1.25'; # IRC Bot module
requires 'TOML', '0.97'; # config file

feature 'sqlite', 'SQLite support' => sub {
    # Possible solution for storage
    requires 'DBD::SQLite';
};

on 'develop' => sub {
    requires 'Perl::Critic';
    requires 'Perl::Critic::Policy::Freenode::MultidimensionalArrayEmulation';
    requires 'Perl::Critic::Policy::Freenode::Prototypes';
};
