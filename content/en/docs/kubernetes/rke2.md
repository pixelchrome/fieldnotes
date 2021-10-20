---
linkTitle: "RKE2"
weight: 1
---
# Setup the NGINX Loadbalancer

`nginx.conf`

```
worker_processes 4;
worker_rlimit_nofile 40000;

events {
    worker_connections 8192;
}

stream {
    upstream rancher_servers_http {
        least_conn;
        server 192.168.11.41:80 max_fails=3 fail_timeout=5s;
        server 192.168.11.42:80 max_fails=3 fail_timeout=5s;
        server 192.168.11.43:80 max_fails=3 fail_timeout=5s;
    }
    server {
        listen 80;
        proxy_pass rancher_servers_http;
    }

    upstream rancher_servers_https {
        least_conn;
        server 192.168.11.41:443 max_fails=3 fail_timeout=5s;
        server 192.168.11.42:443 max_fails=3 fail_timeout=5s;
        server 192.168.11.43:443 max_fails=3 fail_timeout=5s;
    }
    server {
        listen     443;
        proxy_pass rancher_servers_https;
    }

        upstream rancher_servers_rke2 {
        least_conn;
        server 192.168.11.41:9345 max_fails=3 fail_timeout=5s;
        server 192.168.11.42:9345 max_fails=3 fail_timeout=5s;
        server 192.168.11.43:9345 max_fails=3 fail_timeout=5s;
    }
    server {
        listen     9345;
        proxy_pass rancher_servers_rke2;
    }

        upstream rancher_servers_k8s_api {
        least_conn;
        server 192.168.11.41:6443 max_fails=3 fail_timeout=5s;
        server 192.168.11.42:6443 max_fails=3 fail_timeout=5s;
        server 192.168.11.43:6443 max_fails=3 fail_timeout=5s;
    }
    server {
        listen     6443;
        proxy_pass rancher_servers_k8s_api;
    }

}
```

Add `/etc/rancher/rke2/config.yaml`

```yml
server: https://my-kubernetes-domain.com:9345
token: my-shared-secret
tls-san:
  - my-kubernetes-domain.com
  - another-kubernetes-domain.com
```



# Installation

## Installation Node1

```sh
root@rke2-1:~# curl -sfL https://get.rke2.io | sh -
[INFO]  finding release for channel stable
[INFO]  using v1.21.5+rke2r2 as release
[INFO]  downloading checksums at https://github.com/rancher/rke2/releases/download/v1.21.5+rke2r2/sha256sum-amd64.txt
[INFO]  downloading tarball at https://github.com/rancher/rke2/releases/download/v1.21.5+rke2r2/rke2.linux-amd64.tar.gz
[INFO]  verifying tarball
[INFO]  unpacking tarball file to /usr/local
```






# ----------------- OLD - RKE1 - will be removed -----------------

Get an RKE Cluster up and running.

# ssh key

You need a ssh-key for using `rke`

```sh
ssh-keygen -t ed25519 -o -a 100
ssh-keygen -t rsa -b 4096 -o -a 100
```

Make sure you can login with this ssh-key

# Installation RKE

## Install `rke`

### macOS

```sh
brew install rke
```

### Linux

Download it from [GitHub](https://github.com/rancher/rke)

```sh
curl -o rke -L https://github.com/rancher/rke/releases/download/v1.1.15/rke_linux-amd64
chmod 755 rke
```

Move `rke` into your $PATH (e.g. `/usr/local/bin`)

3. Install `kubectl`

```sh
brew install kubectl
```

# Install Docker

Check [here](https://github.com/rancher/install-docker) for the latest version of the install script

```sh
curl https://releases.rancher.com/install-docker/20.10.sh | sh
```

## Add your user to `docker` group

```sh
sudo usermod -aG docker $USER
```

## Install `rke`

### macOS

```sh
brew install rke
```

### Linux

Download it from [GitHub](https://github.com/rancher/rke)

```sh
curl -o rke -L https://github.com/rancher/rke/releases/download/v1.1.15/rke_linux-amd64
chmod 755 rke
```

Move `rke` into your $PATH (e.g. `/usr/local/bin`)

# Install `kubectl` see [here](../kubectl)

## macOS

```sh
brew install kubectl
```

## Linux (Ubuntu, Debian)

```sh
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

See RHEL, Centos [here](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)

# Configure Kubernetes and start the cluster

## `rke config``

Use `rke config`to generate the `cluster.yml` file

If Rancher should be installed on this cluster, edit `cluster.yml`

```yml
# enable regular backups
services:
  etcd:
    snapshot: true
    creation: 6h
    retention: 24h

# Required for external TLS termination with
# ingress-nginx v0.22+
ingress:
  provider: nginx
  options:
    use-forwarded-headers: "true"
```

## Get RKE up and running with `rke up`

```sh
rke up
```

## Check the cluster

Use the generated `kube_config_cluster.yml` and check with `kubectl`

```sh
export KUBECONFIG=$(pwd)/kube_config_cluster.yml
```

```sh
kubectl get nodes
NAME             STATUS   ROLES                      AGE     VERSION
192.168.11.100   Ready    controlplane,etcd,worker   6m39s   v1.18.16
```

```sh
kubectl get pods --all-namespaces
NAMESPACE       NAME                                      READY   STATUS      RESTARTS   AGE
ingress-nginx   default-http-backend-598b7d7dbd-cgd4d     1/1     Running     0          6m51s
ingress-nginx   nginx-ingress-controller-vnkcp            1/1     Running     0          6m51s
kube-system     canal-6hn5w                               2/2     Running     0          7m8s
kube-system     coredns-849545576b-mcvvl                  1/1     Running     0          7m2s
kube-system     coredns-autoscaler-5dcd676cbd-8nchk       1/1     Running     0          7m1s
kube-system     metrics-server-697746ff48-c5mtp           1/1     Running     0          6m54s
kube-system     rke-coredns-addon-deploy-job-5whdd        0/1     Completed   0          7m3s
kube-system     rke-ingress-controller-deploy-job-srtcm   0/1     Completed   0          6m53s
kube-system     rke-metrics-addon-deploy-job-64mff        0/1     Completed   0          6m58s
kube-system     rke-network-plugin-deploy-job-5vpcv       0/1     Completed   0          7m13s
```

# Backup your Config Files!

Store `cluster.rkestate`  `cluster.yml`  `kube_config_cluster.yml` on a safe place!


