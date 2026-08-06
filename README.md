# Nginx UI

Nginx UI is a comprehensive web-based interface designed to simplify the management and configuration of Nginx single-node and cluster nodes. It offers real-time server statistics, Nginx performance monitoring, AI-powered ChatGPT assistance, the code editor that supports LLM Code Completion, one-click deployment, automatic renewal of Let's Encrypt certificates, and user-friendly editing tools for website configurations. Additionally, Nginx UI provides features such as online access to Nginx logs, automatic testing and reloading of configuration files, a web terminal, dark mode, and responsive web design. Built with Go and Vue, Nginx UI ensures a seamless and efficient experience for managing your Nginx server.

nginxui.com

<img src="https://github.com/0xJacky/nginx-ui/raw/dev/resources/logo.png" width="30%" height="auto" alt="Nginx UI logo">

## How to use this Makejail

### Standalone

```console
$ mkdir -p /var/appjail-volumes/nginx-ui/data
$ mkdir -p /var/appjail-volumes/nginx-ui/sites-available
$ mkdir -p /var/appjail-volumes/nginx-ui/sites-enabled
$ mkdir -p /var/appjail-volumes/nginx-ui/streams-available
$ mkdir -p /var/appjail-volumes/nginx-ui/streams-enabled
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose="8080:80" \
    -o fstab="/var/appjail-volumes/nginx-ui/data /var/db/nginx-ui <pseudofs>" \
    -o fstab="/var/appjail-volumes/nginx-ui/sites-available /usr/local/etc/nginx/sites-available" \
    -o fstab="/var/appjail-volumes/nginx-ui/sites-enabled /usr/local/etc/nginx/sites-enabled" \
    -o fstab="/var/appjail-volumes/nginx-ui/streams-available /usr/local/etc/nginx/streams-available" \
    -o fstab="/var/appjail-volumes/nginx-ui/streams-enabled /usr/local/etc/nginx/streams-enabled" \
    ghcr.io/appjail-makejails/nginx-ui nginx-ui
```

### Deploy using `appjail-director`

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  nginx-ui:
    name: nginx-ui
    makejail: gh+AppJail-makejails/nginx-ui
    options:
      - expose: '8080:80'
      - container: 'args:--pull'
    oci:
      environment:
        - TZ: !ENV '${TZ}'
    volumes:
      - data: /var/db/nginx-ui
      - sites-available: /usr/local/etc/nginx/sites-available
      - sites-enabled: /usr/local/etc/nginx/sites-enabled
      - streams-available: /usr/local/etc/nginx/streams-available
      - streams-enabled: /usr/local/etc/nginx/streams-enabled

volumes:
  data:
    device: /var/appjail-volumes/nginx-ui/data
  sites-available:
    device: /var/appjail-volumes/nginx-ui/sites-available
  sites-enabled:
    device: /var/appjail-volumes/nginx-ui/sites-enabled
  streams-available:
    device: /var/appjail-volumes/nginx-ui/streams-available
  streams-enabled:
    device: /var/appjail-volumes/nginx-ui/streams-enabled
```

### Arguments (stage: build)

* `nginx_ui_from` (default: `ghcr.io/appjail-makejails/nginx-ui`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `nginx_ui_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
