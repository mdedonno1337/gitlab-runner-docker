FROM debian

RUN apt update && \
	apt full-upgrade -y

RUN apt install -y curl

WORKDIR /tmp

################################################################################
#	Gitlab-runner

RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh -o get-gitlab-runner.sh
RUN bash ./get-gitlab-runner.sh

ADD ./pin-gitlab-runner.pref /etc/apt/preferences.d/pin-gitlab-runner.pref

RUN apt install -y gitlab-runner

################################################################################
#	Docker

ARG DOCKERCLI="docker-18.03.0-ce"
ARG DOCKERCOMPOSE="1.21.0"

RUN curl https://download.docker.com/linux/static/stable/x86_64/${DOCKERCLI}.tgz -o /tmp/docker-cli.tgz && \
    tar xzvf /tmp/docker-cli.tgz -C /tmp && \
    rm /tmp/docker-cli.tgz && \
    mv /tmp/docker/docker /usr/bin && \
    rm /tmp/docker/*

RUN curl -L https://github.com/docker/compose/releases/download/${DOCKERCOMPOSE}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
	chmod +x /usr/local/bin/docker-compose

################################################################################
#	Scripts

ADD ./register.sh /tmp/register.sh
ADD ./entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/*.sh

VOLUME [ '/tmp/config' ]

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
