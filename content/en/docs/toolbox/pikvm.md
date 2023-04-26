---
linkTitle: "pikvm"
weight: 67
---
# pikvm

## VNC

Enable VNC

### add the folowing to `/etc/kvmd/override.yaml`

```yaml
vnc:
    keymap: /usr/share/kvmd/keymaps/de
```

```yaml
vnc:
    auth:
        vncauth:
            enabled: true
```

###  Set the vncpasswd

`/etc/kvmd/vncpasswd`