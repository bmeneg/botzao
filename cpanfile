requires 'Bot::IRC', '1.25'; # IRC Bot module
requires 'TOML', '0.97'; # config file

feature 'sqlite', 'SQLite support' => sub {
    # Possible solution for storage
    recommends 'DBD::SQLite';
}
