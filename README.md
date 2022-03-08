# bonfire

TODO

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
3. `abra app new ${REPO_NAME} --secrets` (optionally with `--pass` if you'd like
   to save secrets in `pass`)
4. `abra app config YOUR_APP_NAME` 
5. Be sure to change `$HOSTNAME` to something that resolves to your Docker swarm box, check/edit the other config keys
5. `abra app deploy YOUR_APP_NAME `
6. Open the configured domain in your browser and sign up! 


[`abra`]: https://git.coopcloud.tech/coop-cloud/abra
[`coop-cloud/traefik`]: https://git.coopcloud.tech/coop-cloud/traefik
