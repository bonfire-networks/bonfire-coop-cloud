# bonfire

A [coop-cloud](https://coopcloud.tech) recipe for deploying [Bonfire](https://bonfirenetworks.org)

<!-- metadata -->
* **Category**: Apps
* **Status**: 1, alpha
* **Image**: [`bonfirenetworks/bonfire`](https://hub.docker.com/r/bonfirenetworks/bonfire/tags), 4, upstream
* **Healthcheck**:
* **Backups**:
* **Email**:
* **Tests**:
* **SSO**:
<!-- endmetadata -->

## Basic usage

1. Set up Docker Swarm and [`abra`]
2. Deploy [`coop-cloud/traefik`]
3. `abra app new bonfire --secrets` (optionally with `--pass` if you'd like to save secrets in `pass`) and select your server from the list and enter the domain name you want Bonfire to be served from
4. `abra app config YOUR_APP_DOMAIN_NAME` and check/edit the config keys
5. `abra app deploy YOUR_APP_DOMAIN_NAME`
6. Open the configured domain in your browser and sign up! 

## Upgrades 
`abra app deploy --force your-server.domain.name`

[`abra`]: https://docs.coopcloud.tech/abra/
[`coop-cloud/traefik`]: https://git.coopcloud.tech/coop-cloud/traefik

## FAQ

### The app isn't starting
On the server, try this command to see what services are starting or not: `docker service ls` and this one to debug why one isn't starting: `docker service ps $container_name`

### How can I sign up via CLI?
Go into your app's Elixir console and enter something like `Bonfire.Me.make_account_only("my@email.net", "my pw")`

### How can I get to the app's Elixir console?
`abra app run your-server.domain.name app bin/bonfire remote`
