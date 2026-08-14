ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/nginx:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Nginx UI" \
    org.opencontainers.image.description="Yet another WebUI for Nginx" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/nginx-ui" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/nginx-ui" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install nginx-ui FreeBSD-bsdconfig; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

RUN set -xe; \
    \
    cp /usr/local/share/nginx-ui/nginx.conf \
        /usr/local/etc/nginx/nginx.conf; \
    \
    cp /usr/local/share/nginx-ui/nginx-ui.conf \
        /usr/local/etc/nginx/conf.d/nginx-ui.conf

VOLUME /var/db/nginx-ui
VOLUME /usr/local/etc/nginx/sites-available
VOLUME /usr/local/etc/nginx/sites-enabled
VOLUME /usr/local/etc/nginx/streams-available
VOLUME /usr/local/etc/nginx/streams-enabled

RUN set -xe; \
    \
    mkdir -p \
        /usr/local/etc/nginx/sites-available \
        /usr/local/etc/nginx/sites-enabled \
        /usr/local/etc/nginx/streams-available \
        /usr/local/etc/nginx/streams-enabled

WORKDIR /var/db/nginx-ui

STOPSIGNAL SIGQUIT

USER root

ENTRYPOINT ["/entrypoint.sh"]
CMD []
