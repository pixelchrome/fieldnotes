---
title: "ssh"
linkTitle: "ssh"
weight: 90
---

# SSH

## Use SSH Tunnel to forward RDP session to a Windows System

```
| Your Mac or Linux | ----> | Jumphost Linux | ----> | Windows |
```

### On your local Mac/Linux system

#### Configure `ssh_config`
`~/.ssh/ssh_config`
```
Host win10
    HostName        <jumphost-ip>
    LocalForward    133989 <windows-ip>:3390
```

#### Start Tunnel
```sh
ssh -F ~/.ssh/ssh_config win10
```
This will login to the jumphost. Leave the session open!

#### Start the RDP Session