---
title: "proxmox ZFS"
linkTitle: "proxmox ZFS"
weight: 130
---

# Wipe Disks

Clear Disks before usage with `wipefs` and add a partition

```sh
wipefs -fa /dev/sdXXX
```

Write a GPT disklabel and add a partition `fdisk /dev/sdXXX -- g -- n -- t -- 48 -- w`

```sh
fdisk /dev/sdXXX

Command (m for help): g
Created a new GPT disklabel (GUID: F7F89997-08EB-5348-943F-CF56859E7F62).

Command (m for help): n
Partition number (1-128, default 1): 1
First sector (2048-23437770718, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-23437770718, default 23437770718): 

Created a new partition 1 of type 'Linux filesystem' and of size 10.9 TiB.
Partition #1 contains a zfs_member signature.

Do you want to remove the signature? [Y]es/[N]o: y

The signature will be removed by a write command.

Command (m for help): t
Selected partition 1
Partition type (type L to list all types): 48
Changed type of partition 'Linux filesystem' to 'Solaris /usr & Apple ZFS'.

Command (m for help): p
Disk /dev/sdb: 10.9 TiB, 12000138625024 bytes, 23437770752 sectors
Disk model: WDC WD120EDAZ-11
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: F7F89997-08EB-5348-943F-CF56859E7F62

Device     Start         End     Sectors  Size Type
/dev/sdb1   2048 23437770718 23437768671 10.9T Solaris /usr & Apple ZFS

Filesystem/RAID signature on partition 1 will be wiped.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

# Replace Disks - and resize Diskpool

## Resize by replacing all disks

You can only replace or resize a redundant zpool (e.g. mirror, Raid-Zx). If you want to exand a zpool with larger disks, the hard disks must be replaced one after the other.

But first it is necessary to set this option `autoexpand=on`

Note: It might be necessary to reboot or export / import the pool for the expansion.

```sh
zpool set autoexpand=on datapool
```

## here are the steps to replace a disk

Check `zpool status`

```sh
zpool status datapool -vP
  pool: datapool
 state: ONLINE
  scan: scrub repaired 0B in 10:19:48 with 0 errors on Sun Oct 10 10:43:50 2021
config:

	NAME                                                                STATE     READ WRITE CKSUM
	datapool                                                            ONLINE       0     0     0
	  raidz1-0                                                          ONLINE       0     0     0
	    /dev/disk/by-id/ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1480402-part1  ONLINE       0     0     0
	    /dev/disk/by-id/ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1474001-part1  ONLINE       0     0     0
	    /dev/disk/by-id/ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1476807-part1  ONLINE       0     0     0
```

Replace Disk

```sh
zpool replace datapool /dev/disk/by-id/ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1476807-part1 /dev/disk/by-id/ata-WDC_WD120EDAZ-11F3RA0_5PJH7RGF-part1
```

```sh
zpool status datapool
  pool: datapool
 state: ONLINE
status: One or more devices is currently being resilvered.  The pool will
	continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Tue Oct 19 12:18:41 2021
	404G scanned at 36.7G/s, 59.3M issued at 5.39M/s, 4.25T total
	0B resilvered, 0.00% done, no estimated completion time
config:

	NAME                                            STATE     READ WRITE CKSUM
	datapool                                        ONLINE       0     0     0
	  raidz1-0                                      ONLINE       0     0     0
	    ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1480402    ONLINE       0     0     0
	    ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1474001    ONLINE       0     0     0
	    replacing-2                                 ONLINE       0     0     0
	      ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E1476807  ONLINE       0     0     0
	      ata-WDC_WD120EDAZ-11F3RA0_5PJH7RGF-part1  ONLINE       0     0     0

errors: No known data errors
``` 

## Links

* 