---
linkTitle: "GlusterFS"
weight: 99
---

# GlusterFS
## Installation
On all Nodes
```
$ sudo apt-get install glusterfs-server
```
## Peering
On Node 1 (pi1)
```
$ sudo gluster peer probe pi2
$ sudo gluster peer probe pi3
$ sudo gluster peer probe pi4
$ sudo gluster peer probe pi5
$ sudo gluster peer probe pi6
```
For each command you should get a `peer probe: success.` back
## Checking status
```
$ sudo gluster peer status
Number of Peers: 5

Hostname: pi5
Uuid: 723b232c-137c-4a72-a1ff-ff885dbd8003
State: Peer in Cluster (Connected)

Hostname: pi2
Uuid: a1b92712-919a-4af2-911b-8fa75de73111
State: Peer in Cluster (Connected)

Hostname: pi3
Uuid: 9d1197c9-0235-4bee-bab2-4c05e0155e74
State: Peer in Cluster (Connected)

Hostname: pi4
Uuid: e7900257-a9c7-42db-ac46-9d4e85057921
State: Peer in Cluster (Connected)

Hostname: pi6
Uuid: b6559fa6-9358-4eef-8766-83bff8cf9935
State: Peer in Cluster (Connected)
```

## Creating the storage volume
```
$ sudo gluster volume create gvol1 replica 2 transport tcp \
 pi1:/export/gluster pi2:/export/gluster \
 pi3:/export/gluster pi4:/export/gluster \
 pi5:/export/gluster pi6:/export/gluster
```
I have to use the force command, as I use the root-partition.
```
volume create: gvolume1: success: please start the volume to access data
```

## Starting the volume
```
$ sudo gluster volume start gvol1
volume start: gvol1: success
```

## Mounting the volume
```
$ sudo mount -t glusterfs pi6:/gvol1 /storage-pool
```

## Volume status
```
$ sudo gluster volume status gvol1
Status of volume: gvol1
Gluster process						Port	Online	Pid
------------------------------------------------------------------------------
Brick pi1:/export/gluster				49152	Y	20739
Brick pi2:/export/gluster				49152	Y	3299
Brick pi3:/export/gluster				49152	Y	17356
Brick pi4:/export/gluster				49152	Y	17362
Brick pi5:/export/gluster				49152	Y	17383
Brick pi6:/export/gluster				49152	Y	17385
NFS Server on localhost					N/A	N	N/A
Self-heal Daemon on localhost				N/A	Y	17381
NFS Server on pi5					N/A	N	N/A
Self-heal Daemon on pi5					N/A	Y	17402
NFS Server on pi6					N/A	N	N/A
Self-heal Daemon on pi6					N/A	Y	18696
NFS Server on pi1					N/A	N	N/A
Self-heal Daemon on pi1					N/A	Y	20758
NFS Server on pi3					N/A	N	N/A
Self-heal Daemon on pi3					N/A	Y	17375
NFS Server on pi2					N/A	N	N/A
Self-heal Daemon on pi2					N/A	Y	3319

Task Status of Volume gvol1
------------------------------------------------------------------------------
There are no active volume tasks
```

# Sources
* https://www.digitalocean.com/community/tutorials/how-to-create-a-redundant-sorage-pool-using-glusterfs-on-ubuntu-servers
* http://www.raspberry-pi-geek.de/Magazin/2015/01/Experimente-zu-Clustering-und-Lastverteilung-mit-dem-RasPi/(offset)/2