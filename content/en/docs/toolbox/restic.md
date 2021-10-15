---
title: "restic"
linkTitle: "restic"
weight: 80
---

# Using [restic](https://restic.net) as a backuptool for servers

In this example I use a Hetzner 'Storagebox'. It is included with dedicated server (100GB). But it is also available for other use cases.

# Install `restic`

## Ubuntu

```sh
sudo apt install restic
```

# Prepare

## Generate ssh keys

```sh
ssh-keygen
```
```sh 
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): /root/.ssh/id_rsa_backup
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa_backup
Your public key has been saved in /root/.ssh/id_rsa_backup.pub
```


```sh
ssh-keygen -e -f ~/.ssh/id_rsa_backup.pub | grep -v "Comment:" > ~/.ssh/id_rsa_backup_rfc.pub
```

```sh
cat id_rsa_backup.pub id_rsa_backup_rfc.pub > authorized_keys_storagebox
```

```sh
sftp <username>@<username>.your-storagebox.de                                                      
<username>@<username>.your-storagebox.de's password: 
Connected to <username>.your-storagebox.de.
sftp> mkdir .ssh
sftp> chmod 0700 .ssh
Changing mode on /.ssh
sftp> put authorized_keys_storagebox authorized_keys
Uploading authorized_keys_storagebox to /.ssh/authorized_keys
authorized_keys_storagebox                                                                                                                            100% 1186    45.6KB/s   00:00    
sftp> cd /
sftp> chmod 600 .ssh/authorized_keys
Changing mode on /.ssh/authorized_keys
```

## prepare `~/.ssh/config``

```sh
Host storage-box
	Hostname <username>.your-storagebox.de
	User <username>
	IdentityFile ~/.ssh/id_rsa_backup
	Port 23
```

## Test

```sh
sftp storage-box                                
Connected to storage-box.
```

# Init 

```sh
export RESTIC_PASSWORD="mysecret"
```

```sh
restic init restic init -r "sftp:storage-box:./restic"
```

# Run Backup

```sh
export RESTIC_PASSWORD="mysecret"
```

```sh
restic --exclude={/dev,/media,/mnt,/proc,/run,/sys,/tmp,/var/tmp} -r "sftp:storage-box:./restic" backup /
```
```sh
repository 113fa6c9 opened successfully, password is correct
created new cache in /root/.cache/restic

Files:       32089 new,     0 changed,     0 unmodified
Dirs:            0 new,     0 changed,     0 unmodified
Added to the repo: 1.949 GiB

processed 32089 files, 2.220 GiB in 1:16
snapshot d43223e8 saved
```

# Automate with a script

```sh
#!/bin/bash

#source .restic-keys
export RESTIC_REPOSITORY="sftp:storage-box:./restic"

echo -e "\n`date` - Starting backup...\n"

restic --exclude={/dev,/media,/mnt,/proc,/run,/sys,/tmp,/var/tmp} backup /

# mysqldump database | restic backup --stdin --stdin-filename database.sql

echo -e "\n`date` - Running forget and prune...\n"

restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 12

echo -e "\n`date` - Backup finished.\n"
```

# Links
* https://stanislas.blog/2018/07/backup-servers-using-restic-wasabi-object-storage/
* http://zockertown.de/s9y/index.php?/archives/1736-Backup-mit-restic.html