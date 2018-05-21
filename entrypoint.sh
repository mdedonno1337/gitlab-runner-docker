#!/bin/bash

trap '/tmp/exiting.sh' 0

exec /tmp/register.sh &

DATA_DIR="/etc/gitlab-runner"
CONFIG_FILE=${CONFIG_FILE:-$DATA_DIR/config.toml}

CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$DATA_DIR/certs/ca.crt}
LOCAL_CA_PATH="/usr/local/share/ca-certificates/ca.crt"

update_ca() {
  echo "Updating CA certificates..."
  cp "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}"
  update-ca-certificates --fresh >/dev/null
}

if [ -f "${CA_CERTIFICATES_PATH}" ]; then
  # update the ca if the custom ca is different than the current
  cmp --silent "${CA_CERTIFICATES_PATH}" "${LOCAL_CA_PATH}" || update_ca
fi

# launch gitlab-ci-multi-runner passing all arguments
gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner &
BACK_PID=$!
wait $BACK_PID

/tmp/exiting.sh > /dev/null 2>&1
