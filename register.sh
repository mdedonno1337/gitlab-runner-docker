#!/bin/bash

sleep 1

source /tmp/config/env

gitlab-runner register --non-interactive --url ${HOST} --registration-token ${TOKEN} --executor shell
