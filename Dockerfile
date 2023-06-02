FROM serversideup/php:8.2-fpm-nginx as base

ENV AUTORUN_LARAVEL_MIGRATION=true
ENV SSL_MODE=off

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Tweak PHP extension and settings
RUN echo "opcache.revalidate_freq=0\nopcache.validate_timestamps=0" >> /etc/php/8.2/cli/conf.d/10-opcache.ini
RUN apt-get update \
    && apt-get install -y --no-install-recommends php-pgsql

FROM base as production

COPY --chown=$PUID:$PGID . .

RUN composer install --no-cache --no-dev --no-scripts --no-autoloader --ansi --no-interaction \
    && composer dump-autoload -o

# RUN chown -R www-data:www-data storage storage/logs storage/framework bootstrap/cache
