# gitlab-runner-docker
This repo is designed to run a set of gitlab-runner in a docker swarm. The configuration is made to auto-register and auto-unregister the runner against the gitlab server.

This runner is configured to use the shell executor. All docker tooling (docker CLI and docker-compose) is already installed. This repo will give the docker socket to the runnere to be able to build with `docker build` commands: the CICD pipeline, if not verified by the cluster admin, could terminate all docker container on the swarm or install anything on the swarm! BE CAREFULL!

The ssh folder allow to pass a configuration file to the gitlab runner, allowing to use this set of runner to push to production (for example) via ssh automatically.

See the .gitlab-ci.yml file to have an example of self-compiling and self-deploying CICD configuration.

### List of tools

    - gitlab-runner
    - Docker CLI
    - docker-compose
    - make
    - curl
    - git
    - python sphinx
    - clair
    - reg
