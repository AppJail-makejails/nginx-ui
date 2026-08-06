#!/bin/sh

set -e

mkdir -p \
    /usr/local/etc/nginx/conf.d \
    /usr/local/etc/nginx/streams-enabled \
    /usr/local/etc/nginx/sites-enabled \
    /usr/local/etc/nginx/sites-available \
    /usr/local/etc/nginx/streams-available

if ! service nginx status > /dev/null; then
    sysrc nginx_enable="YES"
    service nginx start
fi

rm -f /var/db/nginx-ui/nginx-ui.sock

exec "nginx-ui" "$@"
