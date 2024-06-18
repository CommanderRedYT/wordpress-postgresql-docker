#!/bin/sh

mkdir -p "wp-content"
if ! [ -e "wp-content/db.php" ];
then
    cp "/usr/src/wordpress/pg4wp/db.php" "wp-content/db.php"
fi

exec docker-entrypoint.sh "$@"
