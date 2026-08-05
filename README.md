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

1. `abra app new bonfire --secrets`
2. `abra app config <app-name>`
3. `abra app deploy <app-name>`
4. Open the Elixir console: `abra app run <app-name> app bin/bonfire remote`
5. Create admin account in Elixir console (the first account created this way will get admin rights): `Bonfire.Me.make_account_only("my@email.net", "my pw")`

## Use a custom Bonfire flavour

By default, this recipe deploys the Bonfire `social` flavour. If you want a different one uncomment and define `APP_FLAVOUR` in you env file.

## Use a custom Bonfire version

Attention: This is not recommended for production deployment!

You can deploy another version of Bonfire by using `APP_VERSION` and `APP_PLATFORM`. Be aware that not all versions might be compatible with this recipe, especially the quite old ones.
If you want to use bleeding edge releases try setting `APP_VERSION=latest-alpha`. When using this, every time you deploy with `abra app deploy --force <app-name>` the latest alpha replease will be used.

## Using a search backend

1. uncomment the `COMPOSE_FILE` line that contains `compose.sonic.yml` in the `.env` file for your bonfire instance.
2. add `SONIC_PASSWORD=a-super-secret-password` to the same file (make sure to change the password after pasting!)
3. redeploy with `abra app deploy --force <app-name>`

## Protect the instance with basic auth

For e.g. a testing phase you can protect your Bonfire instance with basic auth:

1. uncomment the section `## BASIC_AUTH`
2. create a username/password combination with `echo $(htpasswd -nB <username>)`
3. add the combination as secret with `abra app secret insert <app-name> usersfile v1 '<the-user-password-combination>'`

## 

## FAQ

### The app isn't starting
On the server, try this command to see what services are starting or not: `docker service ls` and this one to debug why one isn't starting: `docker service ps $container_name`

### How can I sign up via CLI?
Go into your app's Elixir console and enter something like `Bonfire.Me.make_account_only("my@email.net", "my pw")`

### How can I get to the app's Elixir console?
`abra app run your-server.domain.name app bin/bonfire remote`

For more, see [docs.coopcloud.tech](https://docs.coopcloud.tech).