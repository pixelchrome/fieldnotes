---
linkTitle: "Raspberry Pi OS"
weight: 1
---

## Install

```sh
sudo dd if=2021-03-04-raspios-buster-armhf-lite.img of=/dev/diskXX bs=1024k
```

### Enable SSH

Create an empty file `ssh` on the *boot*partition

e.g. macOS

```sh
touch /Volumes/boot/ssh
```

{{% alert title="Tip" %}}
> User is **pi** default password is **raspberry**
{{% /alert %}}

### Setup with `raspi-config`

## Fixing `perl: warning: Setting locale failed.`

macOS

`/etc/ssh/ssh_config`

remove

```
SendEnv LANG LC_*
```

## Blinkt!

Install the Software for the **Blinkt!** LED Bar from [Pimoroni](https://learn.pimoroni.com/tutorial/sandyj/getting-started-with-blinkt)

```sh
curl https://get.pimoroni.com/blinkt | bash
```

{{% alert title="Tip" %}}
> This script doesnt work on a 64-Bit Version of raspbian. But it is possible to install the library with `sudo apt-get install python3-blinkt`
{{% /alert %}}