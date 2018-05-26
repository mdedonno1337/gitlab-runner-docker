FROM debian:9
LABEL maintainer="Marco De Donno <Marco.DeDonno@unil.ch>"

RUN apt update && \
	apt full-upgrade -y

RUN apt install -y curl make git

WORKDIR /tmp

################################################################################
#	Gitlab-runner

RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh -o get-gitlab-runner.sh
RUN bash ./get-gitlab-runner.sh

COPY ./pin-gitlab-runner.pref /etc/apt/preferences.d/pin-gitlab-runner.pref

RUN apt install -y gitlab-runner

################################################################################
#	Docker

ARG DOCKERCLI="docker-18.05.0-ce"
ARG DOCKERCOMPOSE="1.21.2"

RUN curl https://download.docker.com/linux/static/edge/x86_64/${DOCKERCLI}.tgz -o /tmp/docker-cli.tgz && \
    tar xzvf /tmp/docker-cli.tgz -C /tmp && \
    rm /tmp/docker-cli.tgz && \
    mv /tmp/docker/docker /usr/bin && \
    rm /tmp/docker/*

RUN curl -L https://github.com/docker/compose/releases/download/${DOCKERCOMPOSE}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && \
	chmod +x /usr/local/bin/docker-compose

################################################################################
#	Scripts

COPY ./exiting.sh /tmp/exiting.sh
COPY ./register.sh /tmp/register.sh
COPY ./entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/*.sh

VOLUME [ '/tmp/config', '/tmp/keys', '/root/.ssh' ]

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
