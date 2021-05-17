# BotZao project

That's the biggest chat bot you'll ever see. That's the BotZão!

# TODO list
## Core
- [x] set basic configuration to actually connect to an IRC server
- [x] enable TOML configuration file
- [x] check valid configuration file topics + options
- [x] set config from config file
- [x] enable config from cli arg
- [x] enable external logging (file)
- [x] enable logging level
- ~~[ ] allow bot run as a daemon (systemd)~~ (container)
- ~~[ ] enable important log level to land to system log (systemd)~~ (container)
- [x] enable plugin mechanism

## Plugin Engine
- [x] enable IRC support (IRC::Bot)
- [ ] enable TwitchTV Chat support (existent module?)
- [ ] add local storage
  - [ ] redis (temporary)
  - [ ] sqlite (persistent)

## Plugins
- [ ] enable chat user commands (possibly using `!` char)
  - [x] IRC support
  - [ ] TwitchTV support
- [ ] enable `joke` command
  - [x] IRC support
  - [ ] TwitchTV support
- [ ] enable `greetings` command
  - [x] IRC support
  - [ ] TwitchTV support

## IRC
- [x] handle basic login to server
  - [x] server, nickname, channel
  - [x] SSL/TLS

## TwitchTV
- [ ] handle basic login (OAuth) to server
- [ ] handle basic messages from server

# Contributing to the project

Please, follow the instructions in [CONTRIBUTING](./CONTRIBUTING.md)
