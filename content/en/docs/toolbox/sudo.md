---
title: "sudo"
linkTitle: "sudo"
weight: 90
---

# Enable `sudo` without password

> never edit `/etc/sudoers`! use `visudo`

Add `username     ALL=(ALL) NOPASSWD:ALL` at the end of `/etc/sudoers`

```sh
sudo visudo
```