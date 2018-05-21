#!/bin/bash

DATA_DIR="/etc/gitlab-runner"
CONFIG_FILE=${CONFIG_FILE:-$DATA_DIR/config.toml}

# Trap exit-codes send by Docker
trap '/tmp/exiting.sh' 0

# Update the keys permissions
chmod 600 /tmp/keys/*
chown gitlab-runner:gitlab-runner /tmp/keys/*

# Startup script to register the worker to the gitlab server
exec /tmp/register.sh &

# Run the gitlab-runner in background, and watch the PID
gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner &
BACK_PID=$!
wait $BACK_PID

# Clean the worker (unregister and stuff)
/tmp/exiting.sh > /dev/null 2>&1
