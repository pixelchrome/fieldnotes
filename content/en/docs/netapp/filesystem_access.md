
# ONTAP Filesystem acces for Admins

## Via nodeshell

```sh
cluster1::> volume show -vserver svm1
Vserver   Volume       Aggregate    State      Type       Size  Available Used%
--------- ------------ ------------ ---------- ---- ---------- ---------- -----
svm1      sitea_nfs_vms
                       aggr1_cluster1_01
                                    online     RW        112GB    78.01GB    1%
svm1      svm1_root    aggr1_cluster1_02
                                    online     RW         40MB    37.39MB    1%
2 entries were displayed.
```
 
```sh
cluster1::> system node run -node cluster1-01
Type 'exit' or 'Ctrl-D' to return to the CLI
cluster1-01> priv set advanced
Warning: These advanced commands are potentially dangerous; use
         them only when directed to do so by NetApp
         personnel.
cluster1-01*> ls /vol/sitea_nfs_vms
.
..
.vSphere-HA
sitea_vm1
 
cluster1-01*> ls /vol/sitea_nfs_vms/sitea_vm1
.
..
sitea_vm1-1b742ffc.hlog
sitea_vm1.vmx
sitea_vm1-flat.vmdk
sitea_vm1.vmdk
sitea_vm1.vmsd

cluster1-01*> version
NetApp Release R9.4xN_180608_1539: Fri Jun  8 15:52:39 PDT 2018   <1>

cluster1-01*> rdfile /vol/sitea_nfs_vms/sitea_vm1/sitea_vm1.vmx
.encoding = "UTF-8"
config.version = "8"
virtualHW.version = "11"
nvram = "sitea_vm1.nvram"
pciBridge0.present = "TRUE"
svga.present = "TRUE"
pciBridge4.present = "TRUE"
pciBridge4.virtualDev = "pcieRootPort"
pciBridge4.functions = "8"
pciBridge5.present = "TRUE"
pciBridge5.virtualDev = "pcieRootPort"
pciBridge5.functions = "8"
pciBridge6.present = "TRUE"
pciBridge6.virtualDev = "pcieRootPort"
pciBridge6.functions = "8"
pciBridge7.present = "TRUE"
pciBridge7.virtualDev = "pcieRootPort"
pciBridge7.functions = "8"
vmci0.present = "TRUE"
hpet0.present = "TRUE"
memSize = "128"
scsi0.virtualDev = "lsilogic"
scsi0.pciSlotNumber = "16"
scsi0.present = "TRUE"
floppy0.startConnected = "FALSE"
floppy0.autodetect = "TRUE"
floppy0.clientDevice = "TRUE"
scsi0:0.deviceType = "scsi-hardDisk"
scsi0:0.fileName = "sitea_vm1.vmdk"
scsi0:0.present = "TRUE"
ethernet0.virtualDev = "e1000"
ethernet0.networkName = "VM Network"
ethernet0.addressType = "vpx"
ethernet0.generatedAddress = "00:50:56:a5:97:d5"
ethernet0.pciSlotNumber = "32"
ethernet0.present = "TRUE"
displayName = "sitea_vm1"
guestOS = "debian5"
uuid.bios = "42 25 e6 c2 22 2c 04 dc-fc ad b9 85 68 75 b1 ad"
vc.uuid = "50 25 4b de ea 56 b8 04-c0 56 91 81 36 72 59 aa"
migrate.hostLog = "sitea_vm1-1b742ffc.hlog"
```

## Via systemshell

### Diag-User ‚unlocken‘

```sh 
cluster1::> security login show -username diag
 
Vserver: cluster1
                                                                 Second
User/Group                 Authentication                 Acct   Authentication
Name           Application Method        Role Name        Locked Method
-------------- ----------- ------------- ---------------- ------ --------------
diag           console     password      admin            yes    none
 
cluster1::> security login unlock -username diag
 
Diag-User Passwort erstellen
 
cluster1::> security login password -username diag
 
Enter a new password:
Enter it again:
```
 
## Enter Systemshell

```sh
cluster1::> set -privilege diagnostic
 
Warning: These diagnostic commands are for use by NetApp personnel only.
Do you want to continue? {y|n}: y

cluster1::*> systemshell -node cluster1-01
  (system node systemshell)
diag@169.254.95.154's password:
 
Warning:  The system shell provides access to low-level
diagnostic tools that can cause irreparable damage to
the system if not used properly.  Use this environment
only when directed to do so by support personnel.
```
 
## Uhhh ‚sudo‘ works 😈
 
```sh
cluster1-01% sudo bash
```
 
## Look under `/clus` 😂

```sh 
bash-3.2# ls /clus/
.cserver        svm_test
bash-3.2# ls /clus/svm_test/
.snapshot               .vsadmin                vol_test_NFS_volume
bash-3.2# ls /clus/svm_test/vol_test_NFS_volume/
.snapshot       geheim.txt
bash-3.2# cd /clus/svm_test/vol_test_NFS_volume/
```
 
## Read and Write works also

```sh 
bash-3.2# head -10 geheim.txt
 
NetApp, Inc. is a hybrid cloud data services and data management company headquartered in Sunnyvale, California. It has ranked in the Fortune 500 since 2012. NetApp offers hybrid cloud data services for management of applications and data across cloud and on-premises environments.
 
NetApp was founded in 1992 by David Hitz, James Lau, It had its initial public offering in 1995. NetApp thrived in the internet bubble years of the mid 1990s to 2001, during which the company grew to $1 billion in annual revenue. After the bubble burst, NetApp's revenues quickly declined to $800 million in its fiscal year 2002. Since then, the company's revenue has steadily climbed.
 
In 2006, NetApp sold the NetCache product line to Blue Coat Systems
 
In May 2018 NetApp announced its first End to End NVMe array called All Flash FAS A800 with release of ONTAP 9.4 software.
In January 2019 Dave Hitz announced retirement from NetApp.
```

```sh 
bash-3.2# echo DOOMED > geheim.txt
 
bash-3.2# head -10 geheim.txt
DOOMED
```