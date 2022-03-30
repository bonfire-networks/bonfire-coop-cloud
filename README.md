# bonfire

A [coop-cloud](https://coopcloud.tech) recipe for deploying [Bonfire](https://bonfirenetwork.org)

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
2. Set up your server with `abra server add --provision your-server.domain.name server_username 22`
3. Deploy the [`coop-cloud/traefik`] proxy if you haven't already
3. `abra app new --secrets https://github.com/bonfire-networks/bonfire-deploy` 
4. Generate extra secrets with `~/.abra/apps/bonfire/secrets.sh YOUR_APP_NAME` and edit the config (in next step) for `SECRET_SECRET_KEY_BASE_VERSION`, `SECRET_SIGNING_SALT_VERSION`, and `SECRET_ENCRYPTION_SALT_VERSION` from `v1` to `v2`
5. `abra app config YOUR_APP_NAME` to check and edit the config (there are comments to explain the different options)
6. `abra app deploy YOUR_APP_NAME`
7. Open the configured domain in your browser and sign up! 

## Upgrades 
`abra app deploy --force YOUR_APP_NAME`

[`abra`]: https://docs.coopcloud.tech/abra/
[`coop-cloud/traefik`]: https://git.coopcloud.tech/coop-cloud/traefik

## FAQ
### The app isn't starting
On the server, try this command to see what services are starting or not: `docker service ls` and this one to debug why one isn't starting: `docker service ps $container_name`