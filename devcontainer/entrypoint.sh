#!/bin/bash

USER_ID=${LOCAL_UID:-9001}
GROUP_ID=${LOCAL_GID:-9001}

if [ ! -z "$USER_ID" ] && [ "$(id -u me)" != "$USER_ID" ]; then
    groupadd --non-unique -g "$GROUP_ID" group
    usermod --non-unique --uid "$USER_ID" --gid "$GROUP_ID" me
fi

find ~ -print0 | xargs -0 --max-args=1 --max-procs=10 chown -v me: 1> /dev/null
chown me: /var/run/docker.sock

exec /usr/sbin/gosu me "$@"
