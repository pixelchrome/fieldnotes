---
title: "FreeBSD: Disaster Recovery with zfSnap and zxfer"
linkTitle: "DR with ZFS"
weight: 50
---

# Disaster Recovery with zfSnap and zxfer
## Creating regular Snapshots with zfSnap

Install `zfSnap`

```
prod# portmaster sysutils/zfsnap
```
### Traditional way. Without 'periodic'
Add the following to your `/etc/crontab

```
# ZFS Snapshots with zfSnap
# Delete old Snapshots at 1:00 am
0     1     *     *     *     root   /usr/local/sbin/zfSnap -d
# Create Snapshots
5     *     *     *     *     root   /usr/local/sbin/zfSnap -a 1d -r zroot
5     1     *     *     *     root   /usr/local/sbin/zfSnap -a 1w -r zroot
5     2     *     0     *     root   /usr/local/sbin/zfSnap -a 1m -r zroot
```

####Snapshot schedule for Screencast
```
# ZFS Snapshots with zfSnap
# Delete old Snapshots at 1:00 am
0          1      *              *       *             root   /usr/local/sbin/zfSnap -d
# Create Snapshots
# Snapshot every 5 Minutes - available for one hour
*/5          *      *              *       *             root   /usr/local/sbin/zfSnap -a 1h -r zroot
# Hourly Snapshot - available for one day
5          *      *              *       *             root   /usr/local/sbin/zfSnap -a 1d -r zroot
# Daily Snapshot - available for one week
5          1      *              *       *             root   /usr/local/sbin/zfSnap -a 1w -r zroot
```

You are done! This will create every hour a snapshot of all filesystems. The hourly snapshots will be removed after one day. Every day at 1:05 am a snapshot is created and after one week it will be removed. Every Sunday at 2:05 am a snapshot is created and after one month it will be removed. With this you will have 24 hourly, 7 daily and 30 weekly snapshots per filesystem. For a fresh installed system, you will have 13x (24+7+30) == 421 snapshots. This shouldn't be a problem for ZFS. Maybe you want to change this schedule.

##With periodic
FreeBSD runs periodic system functions. See `man periodic` for more infos.

With the installation of zfSnap, you can find also under `/usr/local/etc/persiodic` a new directory called `hourly`. Inside this directory you can see two new files

```
402.zfSnap
403.zfSnap_delete
```

###Configuring periodic hourly
The periodic utility is intended to be called by cron. Therefore you have to add the following lines to `/etc/crontab`

```
4        *       *       *       *       root    periodic hourly
@reboot                                  root    periodic reboot
```

This will start hourly periodic scripts every hour (4 minutes after the full hour).

###Configuring zfSnap
You need to do this with `/etc/periodic.conf`. In my case I want to do recursive snapshots of the `zroot` pool.

```
hourly_zfsnap_enable="YES"
hourly_zfsnap_recursive_fs="zroot"
hourly_zfsnap_verbose="NO"
hourly_zfsnap_flags="-s -S"
hourly_zfsnap_ttl="1d"

daily_zfsnap_enable="YES"
daily_zfsnap_recursive_fs="zroot"
daily_zfsnap_verbose="YES"
daily_zfsnap_flags="-s -S"

weekly_zfsnap_enable="YES"
weekly_zfsnap_recursive_fs="zroot"
weekly_zfsnap_verbose="YES"
weekly_zfsnap_flags="-s -S"

monthly_zfsnap_enable="YES"
monthly_zfsnap_recursive_fs="zroot"
monthly_zfsnap_verbose="YES"
monthly_zfsnap_flags="-s -S"

reboot_zfsnap_enable="YES"
reboot_zfsnap_recursive_fs="zroot"
reboot_zfsnap_verbose="YES"
reboot_zfsnap_flags="-s -S"

daily_zfsnap_delete_enable="YES"
daily_zfsnap_delete_flags="-s -S"
daily_zfsnap_delete_verbose="YES"
```

##Store the Disk-Layout in a safe place (for disaster recovery reasons)

```
prod# gpart show da0
=>      34  83886013  da0  GPT  (40G)
        34      1024    1  freebsd-boot  (512K)
      1058   4194304    2  freebsd-swap  (2.0G)
   4195362  79690685    3  freebsd-zfs  (38G)
```

```
prod# gpart list da0
Geom name: da0
modified: false
state: OK
fwheads: 255
fwsectors: 63
last: 83886046
first: 34
entries: 128
scheme: GPT
Providers:
1. Name: da0p1
   Mediasize: 524288 (512K)
   Sectorsize: 512
   Stripesize: 0
   Stripeoffset: 17408
   Mode: r0w0e0
   rawuuid: 915407d2-9ce6-11e4-8a30-000c29fa5c3e
   rawtype: 83bd6b9d-7f41-11dc-be0b-001560b84f0f
   label: gptboot0
   length: 524288
   offset: 17408
   type: freebsd-boot
   index: 1
   end: 1057
   start: 34
2. Name: da0p2
   Mediasize: 2147483648 (2.0G)
   Sectorsize: 512
   Stripesize: 0
   Stripeoffset: 541696
   Mode: r1w1e0
   rawuuid: 915f10f3-9ce6-11e4-8a30-000c29fa5c3e
   rawtype: 516e7cb5-6ecf-11d6-8ff8-00022d09712b
   label: swap0
   length: 2147483648
   offset: 541696
   type: freebsd-swap
   index: 2
   end: 4195361
   start: 1058
3. Name: da0p3
   Mediasize: 40801630720 (38G)
   Sectorsize: 512
   Stripesize: 0
   Stripeoffset: 2148025344
   Mode: r1w1e2
   rawuuid: 91692416-9ce6-11e4-8a30-000c29fa5c3e
   rawtype: 516e7cba-6ecf-11d6-8ff8-00022d09712b
   label: zfs0
   length: 40801630720
   offset: 2148025344
   type: freebsd-zfs
   index: 3
   end: 83886046
   start: 4195362
Consumers:
1. Name: da0
   Mediasize: 42949672960 (40G)
   Sectorsize: 512
   Mode: r2w2e4
```

##Backup to remote Server with zxfer

###Perparing SSH

###PermitRootLogin on the backup server
You need to allow the root login on the backup server. This is a potential security risk. **Be aware of that!**

Open the `/etc/ssh/sshd_config`, search for `#PermitRootLogin yes` and remove the `#`
Restart the sshd `service sshd restart`

### Generate SSH-Keys on the production server

Generate a SSH-Key with `ssh-keygen`, allow the standard file and use an empty passphrase

```
prod# ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
```

Copy the public key to the backup server

```
prod# scp id_rsa.pub root@backup:/tmp
Password for root@backup:
```

### Setting up the backup server for the passwordless login

```
backup# cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys
backup# chmod 600 /root/.ssh/authorized_keys 
```

#### Now you should be able to login from the production system on the backup server, without entering a password!

```
prod# ssh root@backup  
   
.______        ___       ______  __  ___  __    __  .______
|   _  \      /   \     /      ||  |/  / |  |  |  | |   _  \
|  |_)  |    /  ^  \   |  ,----'|  '  /  |  |  |  | |  |_)  |
|   _  <    /  /_\  \  |  |     |    <   |  |  |  | |   ___/
|  |_)  |  /  _____  \ |  `----.|  .  \  |  `--'  | |  |
|______/  /__/     \__\ \______||__|\__\  \______/  | _|

FreeBSD 10.1-RELEASE (GENERIC) #0 r274401: Tue Nov 11 21:02:49 UTC 2014

Welcome to FreeBSD!
root@backup:~ # 
```

### Setup the storage part on your backup server

Create a ZFS to store the snapshots of the production system

```
backup# zpool create backup da1
backup# zfs set compression=gzip9 backup
backup# zfs create backup/prod
```

### Test the backup

```
prod# zxfer  -dFkPv -o copies=2,compression=lzjb,dedup=on -T root@192.168.176.134 -R zroot zroot/backup/prod
```

### Setting up cron for a scheduled backup

**TODO!!!**
```
# Mirror zroot to backup system
*/15  *     *     *     *     root   /usr/local/bin/zxfer  -dFkPv -o copies=2,compression=lzjb,dedup=on -T root@backup -R zroot backup/prod
```


## DISASTER RECOVERY!

### Boot your Server from the DVD or USB and choose Live-CD

### Enable SSH Login on FreeBSD LiveCD

See [here](http://www.brainbugs.net/enable-ssh-login-on-freebsd-livecd/)

*Get FreeBSD CD from here (memstick or disk). I'm using FreeBSD-9.1-RELEASE-amd64-disc1.iso. 
Boot from it and select Live CD option when the installer has been started. 
To start the ssh daemon you need a writeable /etc folder and if you want public key authentication you also have to create a write /root directory. Those directories can be created with the following lines.*

```
mkdir /tmp/etc
mount_unionfs /tmp/etc /etc
mkdir /tmp/root
mount_unionfs /tmp/root /root
```

*As you are not going to create an additional user you should permit root logins* `vi /etc/ssh/sshd_config`

```
PermitRootLogin yes
```

*Furthermore you have to configure the network adapter.*

```
ifconfig bce0 inet 10.0.1.2 netmask 255.255.255.0
route add default 10.0.1.1
```

*OR*
```
dhclient em0
```

*Now, you are almost done. Before you can start the ssh daemon I recommend creating a password at least with* `passwd`

*Run the ssh daemon* `/etc/rc.d/sshd onestart.`

*You also may want to create your own ssh key pair.*

```
ssh-keygen -b 4096
```

*Finally you can copy our public key to your running FreeBSD LiveCD to enable public key authentication.*

```
scp ~/.ssh/id_rsa.pub root@10.0.1.2:/root/.ssh/authorized_keys
```

### Copy zxfer
From the Backup System, copy zxfer to the Live-FreeBSD

```
root@backup:~ # scp /usr/local/sbin/zxfer root@192.168.176.135:/root
```

### Preparing the disk

#### Delete Partitions (if necessary)
```
gpart delete -i <partition_number> <device>
```
```
gpart delete -i 1 da0
```



If you are using the same disk type, it might be useful to set it up like it was before the disaster happened

```
gpart create -s gpt da0
gpart add -t freebsd-boot -b 34 -s 1024 -i 1 -l gptboot0 da0
gpart add -t freebsd-swap -b 1058 -s 4194304 -i 2 -l swap0 da0
gpart add -t freebsd-zfs -b 4195362 -s 79690685 -i 3 -l zfs0 da0
```

 Maybe this is not required, because you change the disk size.

```
# gpart add -s 1024 -a 4k -t freebsd-boot -l gptboot0 da0
# gpart add -s 8g -a 4k -t freebsd-swap -l swap0 da0
# gpart add -a 4k -t freebsd-zfs -l zfs0 da0
```

```
gpart bootcode -b /boot/pmbr -p /boot/gptzfsboot -i 1 da0
```

If using an 'advanced format' drive, the following commands will create virtual devices with 4k sectors, to ensure ZFS uses the correct block size:

FreeBSD 10.1

```
zpool status
```

```
sysctl vfs.zfs.min_auto_ashift=12
```

Older FreeBSD Versions
```
gnop create -S 4096 /dev/gpt/zfs0
```

### Create the pool

```
zpool create -o altroot=/mnt -O canmount=off -m none zroot gpt/zfs0
```

### Transfer the data and setup the mountpoints

This needs to be done from the system which will be restored and has been booted from the Live-CD.

```
./zxfer -deFPv -O root@192.168.176.134 -R zroot/backup/prod/zroot/ROOT zroot
zfs set mountpoint=none zroot/ROOT
zfs set mountpoint=/ zroot/ROOT/default
```

```
./zxfer -deFPv -O root@192.168.176.134 -R zroot/backup/prod/zroot/tmp zroot
zfs set mountpoint=/tmp zroot/tmp
```

```
./zxfer -deFPv -O root@192.168.176.134 -R zroot/backup/prod/zroot/usr zroot
zfs set mountpoint=/usr zroot/usr
```

```
./zxfer -deFPv -O root@192.168.176.134 -R zroot/backup/prod/zroot/var zroot
zfs set mountpoint=/var zroot/var
```

All the data has been transferred!

### Set the dataset to boot from

```
zpool set bootfs=zroot/ROOT/default zroot
```

### Reboot, Keep calm and cross your fingers!