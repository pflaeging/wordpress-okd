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

sed -e s/_DB_NAME_/$MYSQL_DATABASE/ \
    -e s/_DB_USER_/$MYSQL_USER/ \
    -e s/_DB_PASSWORD_/$MYSQL_PASSWORD/ \
    -e s/_DB_HOST_/$DB_HOST/ \
    -e s/_DB_CHARSET_/$DB_CHARSET/ \
    -e s/_DB_COLLATE_/$DB_COLLATE/ \
    -e s/_DB_CHARSET_/$DB_CHARSET/ \
    -e s/_AUTH_KEY_/$AUTH_KEY/ \
    -e s/_SECURE_AUTH_KEY_/$SECURE_AUTH_KEY/ \
    -e s/_LOGGED_IN_KEY_/$LOGGED_IN_KEY/ \
    -e s/_NONCE_KEY_/$NONCE_KEY/ \
    -e s/_AUTH_SALT_/$AUTH_SALT/ \
    -e s/_SECURE_AUTH_SALT_/$SECURE_AUTH_SALT/ \
    -e s/_LOGGED_IN_SALT_/$LOGGED_IN_SALT/ \
    -e s/_NONCE_SALT_/$NONCE_SALT/ \
    -e s/_WP_DEBUG_/$WP_DEBUG/ \
    < /opt/wordpress/wp-config.php.template \
    > /opt/wordpress/wp-config.php
    
exec "$@"