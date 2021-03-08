---
title: "Letsencrypt - old"
linkTitle: "Letsencrypt - old"
weight: 30
---

# Letsencrypt FreeBSD NGINX

## Installation
```
# portmaster security/certbot
...
Always:
===========================================================================

The Let's Encrypt Client is BETA SOFTWARE. It contains plenty of bugs and
rough edges, and should be tested thoroughly in staging environments before
use on production systems.

This port installs the "standalone" Python client only, which does not use and
is not the letsencrypt-auto bootstrap/wrapper script.

To obtain certificates, use the 'certonly' command as follows:

 # sudo certbot --server <server-URL> certonly

Note: The client currently requires the ability to bind on TCP port 80. If
you have a server running on this port, it will need to be temporarily stopped
so that the standalone server can listen on that port to complete
authentication.

The letsencrypt plugins to support apache and nginx certificate installation
will be made available soon in the following ports:

 * Apache plugin: security/py-letsencrypt-apache
 * Nginx plugin: security/py-letsencrypt-nginx

===========================================================================
```

## Zertifikate holen
```
certbot certonly --webroot -w /usr/local/www/<webserver_domain> -d <webserver_domain>
certbot certonly --webroot -w /usr/local/www/<mailserver_domain> -d <mailserver_domain>
```
## NGINX Konfiguration
```
ssl_certificate      /usr/local/etc/letsencrypt/live/<webserver_domain>g/fullchain.pem;
ssl_trusted_certificate /usr/local/etc/letsencrypt/live/<webserver_domain>/chain.pem;
```

## Postfix Konfiguration
main.cf
```
smtpd_tls_key_file = /usr/local/etc/letsencrypt/live/<mailserver_domain>/privkey.pem
smtpd_tls_cert_file = /usr/local/etc/letsencrypt/live/<mailserver_domain>/fullchain.pem
```

## Dovecot Konfiguration
```
ssl_cert = </usr/local/etc/letsencrypt/live/<mailserver_domain>/fullchain.pem
ssl_key = </usr/local/etc/letsencrypt/live/<mailserver_domain>/privkey.pem
```

## Zertifikate erneuern
Eintrag in /etc/crontab
```
# Letsencrypt Certificate renewal
*        1      *       *       1       root    /usr/local/bin/certbot renew -q
```
