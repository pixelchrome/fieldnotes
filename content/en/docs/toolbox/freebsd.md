---
linkTitle: "FreeBSD"
weight: 30
---

# FreeBSD

# Package Management

## Dependencies

### List the dependencies of a particular pkg

```sh
pkg info -dx <pkg>
```

Example:

```sh
pkg info -dx mariadb102-client
mariadb102-client-10.2.26:
	openssl-1.0.2t,1
	krb5-1.17_2
	readline-8.0.0
	libedit-3.1.20190324,1
	libiconv-1.14_11
```

### List the packages which *require* this particular package

> -r, --required-by

```sh
pkg info -r <pkg>
```

Example:

```sh
pkg info -r openssl
openssl-1.0.2t,1:
	mariadb102-server-10.2.26
	mariadb102-client-10.2.26
	krb5-1.17_2
	postfix-3.4.7_1,1
	py36-cryptography-2.6.1
	curl-7.66.0
	libarchive-3.4.0,1
	node4-4.8.7
	python27-2.7.16_1
	python36-3.6.9
	rspamd-1.9.0_1
	libevent-2.1.8_3
	dovecot-pigeonhole-0.5.5
	dovecot-2.3.5.1
```
