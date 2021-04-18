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

Prepare the Cluster Hosts and add the copy ssh key with `ssh-copy-id` or if you have `tmux` installed

```sh
xpanes -t -C 3 -c "ssh-copy-id -l ubuntu@{}" clupi{1..6}
```

#### Raspberry Pi

**!!! Important**

Add the line below to the first line of:

Raspbian `/boot/cmdline.txt`
Ubuntu `/boot/firmware/cmddline.txt`

```sh
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```

*Reboot*

### Run `k3sup` 

#### Install 1st Master

```sh
k3sup install --ip 192.168.11.101 --user ubuntu
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
k3sup join --ip 192.168.11.103 --server-ip 192.168.11.101 --user ubuntu
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
export USER=ubuntu

k3sup install \
  --ip $SERVER_IP \
  --user $USER \
  --cluster
```

#### Additional Master

```sh
export SERVER_IP=192.168.11.101
export USER=ubuntu
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
k3sup install --ip 192.168.11.106 --user ubuntu
export KUBECONFIG=/Users/harry/kubeconfig
kubectl config set-context default
k3sup join --ip 192.168.11.105 --server-ip 192.168.11.106 --user ubuntu
k3sup join --ip 192.168.11.104 --server-ip 192.168.11.106 --user ubuntu
k3sup join --ip 192.168.11.103 --server-ip 192.168.11.106 --user ubuntu
3sup join --ip 192.168.11.102 --server-ip 192.168.11.106 --user ubuntu
k3sup join --ip 192.168.11.101 --server-ip 192.168.11.106 --user ubuntu
```

##### Example all in one (HA)

```sh
k3sup install --ip 192.168.11.102 --user ubuntu --cluster
k3sup join --ip 192.168.11.104 --server-ip 192.168.11.102 --user ubuntu
k3sup join --ip 192.168.11.103 --user ubuntu --server-user ubuntu --server-ip 192.168.11.102 --server
k3sup join --ip 192.168.11.105 --server-ip 192.168.11.102 --user ubuntu
k3sup join --ip 192.168.11.106 --server-ip 192.168.11.102 --user ubuntu
k3sup join --ip 192.168.11.101 --user ubuntu --server-user ubuntu --server-ip 192.168.11.102 --server
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