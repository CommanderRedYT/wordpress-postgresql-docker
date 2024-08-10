FROM wordpress:6.6.1-fpm-alpine

# Install extra PHP extensions
RUN apk add --no-cache --virtual .build-deps postgresql-dev

RUN docker-php-ext-configure pgsql --with-pgsql=/usr
RUN docker-php-ext-install pgsql

RUN runDeps="$( \
		scanelf --needed --nobanner --recursive \
			/usr/local/lib/php/extensions \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" && apk add --virtual .wordpress-phpexts-rundeps $runDeps;
RUN apk del .build-deps

ADD ./postgresql-for-wordpress/pg4wp    /usr/src/wordpress/pg4wp
ADD ./docker-entrypoint-custom.sh       /usr/local/bin/docker-entrypoint-custom.sh

ENV WORDPRESS_CONFIG_EXTRA "define('AUTOMATIC_UPDATER_DISABLED', true);"

ENTRYPOINT ["docker-entrypoint-custom.sh"]
CMD ["php-fpm"]
