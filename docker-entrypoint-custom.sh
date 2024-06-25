#!/bin/sh

VOLUME_VERSION="$(php -r 'require('"'"'wp-includes/version.php'"'"'); echo $wp_version;')"
echo "Volume version: $VOLUME_VERSION"
echo "Image version: $WORDPRESS_VERSION"

if [ "$VOLUME_VERSION" != "$WORDPRESS_VERSION" ];
then
    echo "Version mismatch, copying files..."
    rm -fv index.php
fi

mkdir -p "wp-content"
if ! [ -e "wp-content/db.php" ];
then
    cp "/usr/src/wordpress/pg4wp/db.php" "wp-content/db.php"
fi

exec docker-entrypoint.sh "$@"
