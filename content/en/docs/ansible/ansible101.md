---
title: "Ansible 101 WIP"
linkTitle: "Ansible"
weight: 30
---

# WIP

# Ansible 101 - Jeff Geerlings - Ansible for DevOps  

#training #ansible  
	 
https://www.youtube.com/watch?v=goclfp6a2IQ&list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN  

## First steps - chapter 1 & chapter 2  

### Using an `inventory` file  

#### `inventory`  
			 
``` yaml
[example]
192.168.11.46
```

`ansible -i inventory example -m ping -u harry`  

### Using `ansible.cfg`  
#### `ansible.cfg`  

``` yaml
[defaults]
INVENTORY = inventory
```

`ansible example -m ping -u harry`  

### Ad-Hoc Command `-a`  

```
ansible example -a "free -h" -u harry
192.168.11.46 | CHANGED | rc=0 >>
                 total        used        free      shared  buff/cache   available
  Mem:           3.8Gi       179Mi       2.7Gi       0.0Ki       964Mi       3.4Gi
  Swap:          3.8Gi          0B       3.8Gi
```

### `-m` - Module  

### `-a` - Argument  
`-a` without specifying `-m` defaults to `ansible example -m command -a "free -h" -u harry`  

## Vagrant  

## Ad-Hoc - chapter 3

### `Inventory`
```ini
# Application Servers - miracle & magician
[app]
192.168.11.54
192.168.11.55

# Database Servers - whormhole
[db]
192.168.11.46

# Group has all Servers
[multi:children]
app
db

# Variable for all Servers
[multi:vars]
```

### Run an ad-hoc command
```sh
ansible multi -i inventory -a "hostname"
192.168.11.55 | CHANGED | rc=0 >>
magician
192.168.11.54 | CHANGED | rc=0 >>
miracle
192.168.11.46 | CHANGED | rc=0 >>
whormhole
```

Ansible runs 5 threads / forks in parallel. Option `-f` changes the number. E.g. `ansible multi -i inventory -a "hostname" -f 1` runs one fork. But you can add many forks for speeding up...

#### `ansible multi -i inventory -m setup`

Gather information about the system

#### Install a package with ad-hoc command

`ansible multi -i inventory -b -m package -a "name=ntp state=present"`

`-m package` general package module - if used on centos, ubuntu, ...
`-b` become ... sudo
`--ask-become-pass` become ... sudo - if you need to enter a password for sudo

#### Check if a service is running

`ansible multi -i inventory -b -m service -a "name=ntpd state=started enabled=yes"`

### Background Jobs

- -B <seconds>: the maximum amount of time (in seconds) to let the job run.
- -P <seconds>: the amount of time (in seconds) to wait between polling the servers for an updated job status.

```sh
ansible -i inventory multi -b -B 3600 -P 0 -a "apt-get update"
192.168.11.46 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "ansible_job_id": "284017084444.3562",
    "changed": true,
    "finished": 0,
    "results_file": "/root/.ansible_async/284017084444.3562",
    "started": 1
}
192.168.11.55 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "ansible_job_id": "959425920871.5644",
    "changed": true,
    "finished": 0,
    "results_file": "/root/.ansible_async/959425920871.5644",
    "started": 1
}
192.168.11.54 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "ansible_job_id": "916287187016.6222",
    "changed": true,
    "finished": 0,
    "results_file": "/root/.ansible_async/916287187016.6222",
    "started": 1
```

#### Check the status of a job

`ansible multi -b -m async_status -a "jid=916287187016.6222"`

### Deploy a git repo

`ansible app -b -m git -a "repo=git://example.com/path/to/repo.git dest=/opt/myapp update=yes version=1.2.4"`

`ansible app -b -a "/opt/myapp/scripts/update.sh"`

### Ansible Playbooks - chapter 4

