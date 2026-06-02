#!/bin/sh

export SONIC_CHANNEL__AUTH_PASSWORD="$(cat /run/secrets/sonic_password)"

exec sonic -c /etc/sonic.cfg
