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

1. Install [`abra`] on your computer
2. Prepare your server with `abra server add your-server.domain.name`
3. Deploy the [`coop-cloud/traefik`] proxy if you haven't already
3. `abra app new --secrets bonfire` 
4. `abra app config your-server.domain.name` to check and edit the config (there are comments to explain the different options)
5. `abra app deploy your-server.domain.name`
6. Open the configured domain in your browser and sign up! 

## Upgrades 
`abra app deploy --force your-server.domain.name`

[`abra`]: https://docs.coopcloud.tech/abra/
[`coop-cloud/traefik`]: https://git.coopcloud.tech/coop-cloud/traefik

## FAQ

### The app isn't starting
On the server, try this command to see what services are starting or not: `docker service ls` and this one to debug why one isn't starting: `docker service ps $container_name`

### How can I get to the app's Elixir console?
`abra app run your-server.domain.name app bin/bonfire remote`
