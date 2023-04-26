---
title: "ubuntu"
linkTitle: "ubuntu"
weight: 180
---

# Setup

## Set Hostname

Use `hostnamectl` to set the hostname

```sh
sudo hostnamectl set-hostname <hostname>
```

## Set Timezone

```sh
sudo timedatectl set-timezone Europe/Berlin
```

# Network

## Adding a self-signed certificate to the "trusted list"

e.g when using Proxy with TLS Inspection

```sh
sudo apt-get install -y ca-certificates
sudo cp local-ca.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
```

