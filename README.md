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

1. Set up Docker Swarm and [`abra`]
2. Deploy the [`coop-cloud/traefik`] proxy if you haven't already
3. `abra app new https://github.com/bonfire-networks/bonfire-deploy --secrets` 
4. `abra app config YOUR_APP_NAME` to edit your config. Be sure to change `$DOMAIN` to something that resolves to your Docker swarm box, check/edit the other config keys
5. `abra app deploy YOUR_APP_NAME`
6. Open the configured domain in your browser and sign up! 


[`abra`]: https://git.coopcloud.tech/coop-cloud/abra
[`coop-cloud/traefik`]: https://git.coopcloud.tech/coop-cloud/traefik
