# Tunnel to a remote server

Forward a local port to any server.

## Set Up

This project requires:
- autossh (through apt or brew)
- a remote server (you need to configure this yourself)

```bash
$ make # Start tunnel. If no .env configuration, then it will prompt about configuration.
```

## Other commands

```bash
$ make configure # Reconfigure if not already done.
$ make tunnel # Using .env-config to create a tunnel.
$ make switchto config=.env.{usethisname} # Switch .env config.
$ make list # List all tunnels.
$ make tunnel-log # Get autossh log.
$ make kill filter={pid|port|server} # Kill a spesific tunnel.
```

It may be a good idea to look at the Makefile if you want more info.
