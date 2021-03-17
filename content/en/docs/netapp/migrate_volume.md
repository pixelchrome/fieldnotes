---
linkTitle: "Migrate a XDP volume to a different cluster"
weight: 80
---

# Migrate a SnapMirror XDP destination volume to a different cluster

## Scnenario

**cluster1** / volume *OHOME* --> **cluster2** / volume *OHOME_DEST*

A specific snapshot of *OHOME_DEST* should be available on **cluster3**

### Cluster1

```sh
cluster1::> volume show -vserver svm_src1
Vserver   Volume       Aggregate    State      Type       Size  Available Used%
--------- ------------ ------------ ---------- ---- ---------- ---------- -----
svm_src1  OHOME        aggr_01      online     RW         35GB     3.35GB   89%
```

### Cluster2

```sh
cluster2::> snapmirror show
                                                                       Progress
Source            Destination Mirror  Relationship   Total             Last
Path        Type  Path        State   Status         Progress  Healthy Updated
----------- ---- ------------ ------- -------------- --------- ------- --------
svm_src1:OHOME XDP svm_dst1:OHOME_DEST Snapmirrored Idle -     true    -
```

#### Create a clone of the snapshot *TOBECOPIED*

```sh
cluster2::> volume snapshot show -vserver svm_dst1 -volume OHOME_DEST
                                                                 ---Blocks---
Vserver  Volume   Snapshot                                  Size Total% Used%
-------- -------- ------------------------------------- -------- ------ -----
svm_dst1 OHOME_DEST
                  TOBECOPIED                               144KB     0%    0%
                  hdvaultsched.2021-03-11_1115             144KB     0%    0%
                  hdvaultsched.2021-03-11_1120             144KB     0%    0%
                  hdvaultsched.2021-03-11_1125             144KB     0%    0%
                  hdvaultsched.2021-03-11_1130             144KB     0%    0%
                  hdvaultsched.2021-03-11_1135             140KB     0%    0%
```

```sh
cluster2::> volume clone create -flexclone OHOME_DEST_CLONE -type RW -parent-vserver svm_dst1 -parent-volume OHOME_DEST -parent-snapshot TOBECOPIED
```

### Cluster3

```sh
cluster3::> snapmirror create -source-path svm_dst1:OHOME_DEST_CLONE -destination-path svm_dst2:OHOME_COPY -type XDP -Policy hdvault
```

```sh
cluster3::> snapmirror initialize -destination-path svm_dst2:OHOME_NOTFALL
```

Check

```sh
cluster3::> snapmirror show
                                                                       Progress
Source            Destination Mirror  Relationship   Total             Last
Path        Type  Path        State   Status         Progress  Healthy Updated
----------- ---- ------------ ------- -------------- --------- ------- --------
svm_dst1:OHOME_DEST_CLONE XDP svm_dst2:OHOME_NOTFALL Snapmirrored Idle 0B true 03/11 12:45:03
```

## Link
* https://kb.netapp.com/Advice_and_Troubleshooting/Data_Protection_and_Security/SnapMirror/How_to_migrate_a_SnapMirror_XDP_destination_volume_to_a_different_cluster