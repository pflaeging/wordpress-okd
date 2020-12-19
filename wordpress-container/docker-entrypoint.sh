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

# if there's no /opt/wordpress/wp-content/themes/, there's no content on PV
if [ -d /opt/wordpress/wp-content/themes/ ]; then
    echo "Assuming PV has data"
else
    cp -r /opt/wordpress/wp-content.install/* /opt/wordpress/wp-content/
fi

exec "$@"