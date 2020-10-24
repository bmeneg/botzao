# cbot project

Generic IRC (plus TwitchTV features) chatbot

# TODO list
## Core
- [x] set basic configuration to actually connect to an IRC server
- [x] enable TOML configuration file
- [x] check valid configuration file topics + options
- [x] set config from config file
- [x] enable config from cli arg
- [x] enable external logging (file)
- [x] enable logging level
- [ ] allow bot run as a daemon (systemd)
- [ ] enable important log level to land to system log (systemd)
- [ ] enable plugin mechanism

## TwitchTV
- [ ] handle basic login (OAuth) to server
- [ ] handle basic messages from server
- [ ] enable chat user commands (possibly using `!` char)
- [ ] enable `greetings` command
- [ ] enable `joke` command (depends on local storage plugin)

## Plugins
- [x] use IRC::Bot plugin mechanism
- [ ] add local storage
  - [ ] redis
  - [ ] sqlite
