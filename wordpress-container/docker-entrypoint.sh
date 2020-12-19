#! /bin/sh
set -e

# make passwd entry for arbitrary running user (openshift / kubernetes)
if ! whoami &> /dev/null; then
    if [ -w /etc/passwd ]; then
        echo "runner:x:$(id -u):0:runner user:$HOME:/sbin/nologin" >> /etc/passwd
    fi
else
    sed -i s/^$(id -u)/runner/ /etc/passwd
fi

exec "$@"