---
linkTitle: "Cheatsheet ZFS"
weight: 1
---

# Cheatsheet ZFS

## Delete Snapshots

```sh
zfs list -t snapshot | grep <to_be_deleted> | awk '{ printf "zfs destroy %s\n",$1 }' > /tmp/del_snaps.sh
```

Verify!!!

```sh
sh /tmp/del_snaps.sh
```