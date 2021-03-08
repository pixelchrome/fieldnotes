---
title: "FreeBSD: Howto convert a single disk zroot into a mirrored"
linkTitle: "Convert a single disk into a mirror"
weight: 40
---

# Howto convert a single disk zroot into a mirrored

## Layout of the existing disk
```
# gpart show da0
=>      34  41942973  da0  GPT  (20G)
        34         6       - free -  (3.0K)
        40      1024    1  freebsd-boot  (512K)
      1064       984       - free -  (492K)
      2048   4194304    2  freebsd-swap  (2.0G)
   4196352  37744640    3  freebsd-zfs  (18G)
  41940992      2015       - free -  (1.0M)
```
## Layout of the zpool
```
# zpool status 
  pool: zroot
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	zroot       ONLINE       0     0     0
	  gpt/zfs0  ONLINE       0     0     0

errors: No known data errors
```
## Partition the new disk
```
# gpart create -s gpt da1
da1 created
# gpart add -t freebsd-boot -l gptboot1 -b 40 -s 1024 da1
da1p1 added
# gpart add -t freebsd-swap -l swap1 -b 2048 -s 4194304 da1
da1p2 added
# gpart add -t freebsd-zfs -l zfs1 -b 4196352 -s 37744640 da1
da1p3 added

# gpart show da1
=>      34  41942973  da1  GPT  (20G)
        34         6       - free -  (3.0K)
        40      1024    1  freebsd-boot  (512K)
      1064       984       - free -  (492K)
      2048   4194304    2  freebsd-swap  (2.0G)
   4196352  37744640    3  freebsd-zfs  (18G)
  41940992      2015       - free -  (1.0M)
```
## Attach the new disk to the existing pool and updating the bootcode on the new disk
```
# zpool attach zroot /dev/gpt/zfs0 /dev/gpt/zfs1
Make sure to wait until resilver is done before rebooting.

If you boot from pool 'zroot', you may need to update
boot code on newly attached disk '/dev/gpt/zfs1'.

Assuming you use GPT partitioning and 'da0' is your new boot disk
you may use the following command:

	gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da0

# gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da1
bootcode written to da1
```
## Verify the status
### During the resilvering process
```
# zpool status
  pool: zroot
 state: ONLINE
status: One or more devices is currently being resilvered.  The pool will
	continue to function, possibly in a degraded state.
action: Wait for the resilver to complete.
  scan: resilver in progress since Thu Jun 16 14:52:54 2016
        1.87G scanned out of 2.44G at 54.8M/s, 0h0m to go
        1.87G resilvered, 76.66% done
config:

	NAME          STATE     READ WRITE CKSUM
	zroot         ONLINE       0     0     0
	  mirror-0    ONLINE       0     0     0
	    gpt/zfs0  ONLINE       0     0     0
	    gpt/zfs1  ONLINE       0     0     0  (resilvering)

errors: No known data errors
``` 
### Resilvering completed!
```
# zpool status
  pool: zroot
 state: ONLINE
  scan: resilvered 2.44G in 0h0m with 0 errors on Thu Jun 16 14:53:45 2016
config:

	NAME          STATE     READ WRITE CKSUM
	zroot         ONLINE       0     0     0
	  mirror-0    ONLINE       0     0     0
	    gpt/zfs0  ONLINE       0     0     0
	    gpt/zfs1  ONLINE       0     0     0

errors: No known data errors
```
## Adding additional swap
I usually don't mirror the swap. 
```
# swapinfo
Device          512-blocks     Used    Avail Capacity
/dev/da0p2         4194304        0  4194304     0%

# swapoff /dev/da0p2
# swapinfo          
Device          512-blocks     Used    Avail Capacity
```
Change `/etc/fstab` and start the service
```
# cat /etc/fstab 
# Device		Mountpoint	FStype	Options		Dump	Pass#
/dev/gpt/swap0		none	swap	sw		0	0
/dev/gpt/swap1		none	swap	sw		0	0

# service swap restart
# swapinfo           
Device          512-blocks     Used    Avail Capacity
/dev/gpt/swap0     4194304        0  4194304     0%
/dev/gpt/swap1     4194304        0  4194304     0%
Total              8388608        0  8388608     0%
```