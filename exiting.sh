#!/bin/bash

gitlab-runner unregister --all-runners
gitlab-runner stop
gitlab-runner uninstall

exit 0
