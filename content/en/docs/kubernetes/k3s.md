---
linkTitle: "k3s"
weight: 1
---

# k3sup

## Install `k3sup`

### macOS

```sh
brew install k3sup
```

## Install k3s with `k3sup`

### Prerequisites

#### SSH

Prepare the Cluster Hosts and add the copy ssh key with `ssh-copy-id` or if you have `tmux` installed

```sh
xpanes -t -C 3 -c "ssh-copy-id pi@{}" clupi{1..6}
```

##### Use the right SSH Key!

{{% alert title="Attention!" %}}
> `k3sup` uses by default `id_rsa` (and not `id_ed25519`). Be aware if the right key is used.
{{% /alert %}}

Error Message `Error: unable to connect to (server) clupi1:22 over ssh: ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey], no supported methods remain`

1. Run your `k3sup` commands with the option `--ssh-key ~/.ssh/id_ed25519` (e.g. `k3sup install --ip $IP --user pi --ssh-key ~/.ssh/id_ed25519`)
2. Use `ssh-copy-id` with the `-i ~/.ssh/id_rsa`

See this [issue](https://github.com/alexellis/k3sup/issues/99) for more details


#### Raspberry Pi

Use a 64-Bit Linux!

**!!! Important**

##### `cgroups v1` - like Debian Buster

Add the following bellow options to: 

* Raspbian `/boot/cmdline.txt`
* Ubuntu `/boot/firmware/cmddline.txt`

***ALL IN ONE LINE***

```sh
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```

##### `cgroups v2` - like Debian Bullseye

```sh
systemd.unified_cgroup_hierarchy=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```

##### Disable Swap

`/etc/dphys-swapfile``
```sh
CONF_SWAPSIZE=0
```

*Reboot*

### Run `k3sup` 

#### Install 1st Master

```sh
k3sup install --ip 192.168.11.101 --user pi
```

##### Check

```sh
export KUBECONFIG=/Users/harry/kubeconfig
kubectl config set-context default
kubectl get node -o wide
Context "default" modified.
NAME     STATUS   ROLES    AGE    VERSION         INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
clupi1   Ready    master   107s   v1.19.10+k3s1   192.168.11.101   <none>        Ubuntu 20.04.2 LTS   5.4.0-1034-raspi   containerd://1.4.4-k3s1
```

#### Join a Node

```sh
k3sup join --ip 192.168.11.103 --server-ip 192.168.11.101 --user pi
```

#### Check

```sh
kubectl get node -o wide
NAME                STATUS   ROLES    AGE     VERSION         INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
clupi1              Ready    master   9m23s   v1.19.10+k3s1   192.168.11.101   <none>        Ubuntu 20.04.2 LTS   5.4.0-1034-raspi   containerd://1.4.4-k3s1
clupi3              Ready    <none>   37s     v1.19.10+k3s1   192.168.11.103   <none>        Ubuntu 20.04.2 LTS   5.4.0-1034-raspi   containerd://1.4.4-k3s1
```

### HA Install

#### 1st Master

Note the `--cluster`flag

```sh
export SERVER_IP=192.168.11.101
export USER=pi

k3sup install \
  --ip $SERVER_IP \
  --user $USER \
  --cluster
```

#### Additional Master

```sh
export SERVER_IP=192.168.11.101
export USER=pi
export NEXT_SERVER=192.168.11.102

k3sup join \
  --ip $NEXT_SERVER_IP \
  --user $USER \
  --server-user $USER \
  --server-ip $SERVER_IP \
  --server
```

#### Join a Node

```sh
k3sup join --ip 192.168.11.104 --server-ip 192.168.11.101 --user ubuntu
```

##### Example all in one

```sh
k3sup install --ip 192.168.11.106 --user pi
export KUBECONFIG=/Users/harry/kubeconfig
kubectl config set-context default
k3sup join --ip 192.168.11.105 --server-ip 192.168.11.106 --user pi
k3sup join --ip 192.168.11.104 --server-ip 192.168.11.106 --user pi
k3sup join --ip 192.168.11.103 --server-ip 192.168.11.106 --user pi
k3sup join --ip 192.168.11.102 --server-ip 192.168.11.106 --user pi
k3sup join --ip 192.168.11.101 --server-ip 192.168.11.106 --user pi
```

##### Example all in one (HA)

```sh
k3sup install --host clupi1 --user pi --cluster && export KUBECONFIG=/Users/harry/kubeconfig \
kubectl config set-context default \
kubectl get node -o wide \
k3sup join --host clupi2 --server-host clupi1 --user pi --server && k3sup join --host clupi3 --server-host clupi1 --user pi --server && k3sup join --host clupi4 --server-host clupi1 --user pi && k3sup join --host clupi5 --server-host clupi1 --user pi && k3sup join --host clupi6 --server-host clupi1 --user pi \
for i in {1..6}
do
kubectl label node clupi$i node-role.kubernetes.io/worker=worker
done
```

### Label **worker** nodes

`kubectl label node ${node} node-role.kubernetes.io/worker=worker`

##### Example

```sh
for i in {1..6}
do
kubectl label node clupi$i node-role.kubernetes.io/worker=worker
done
```

## Uninstall k3s

### Server node

```sh
/usr/local/bin/k3s-uninstall.sh
```

### Agent node

```sh
/usr/local/bin/k3s-agent-uninstall.sh
```

# Links

* https://github.com/alexellis/k3sup