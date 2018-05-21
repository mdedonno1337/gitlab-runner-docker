#!/bin/bash

gitlab-runner unregister --all-runners
kill -2 $(pidof gitlab-runner)

exit 0
