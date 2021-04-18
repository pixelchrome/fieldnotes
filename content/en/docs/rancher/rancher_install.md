---
linkTitle: "Rancher Installation"
weight: 1
---

## Installing Rancher on a Single Node Using Docker

Create a directory for persistent data e.g. `/opt/rancher`

```sh
docker run -d --privileged \
--restart=unless-stopped \
--name rancher \
-p 80:80 -p 443:443 \
-v /opt/rancher:/var/lib/rancher \
rancher/rancher:latest
```

### Backup Rancher

```sh
docker stop rancher
sudo tar pzcf /opt/rancher.bak/backup_rancher_`date +%F`.tar.gz /opt/rancher
docker start rancher
```

## Installing Rancher on K8S

### Required CLI Tools

1. Install `kubectl` see [here](../../kubernetes/kubectl)
2. Install `helm` see [here](../../kubernetes/helm)

## Add the **STABLE** Helm Chart Repository

```sh
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
```

## Create a Namespace for Rancher *cattle-system*

```sh
kubectl create namespace cattle-system
```

## Install Cert-Manager

Here is the Rancher-generated TLS certificate used. For other options (LetsEncrypt or Bring your own Certificates) see the [documentation](https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/).

```sh
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml

kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.4
```

Verify it is deployed

```sh
kubectl get pods --namespace cert-manager
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-75dbbd5d6-rqztg               1/1     Running   0          8s
cert-manager-cainjector-85c559fd6c-6k4z9   1/1     Running   0          8s
cert-manager-webhook-6c77dfbdb8-l94wp      0/1     Running   0          8s
```

## Install Rancher with helm

```sh
helm install rancher rancher-stable/rancher \
   --namespace cattle-system \
   --set hostname=rancher.<domain>
```

### Check the rollout

```sh
kubectl -n cattle-system rollout status deploy/rancher
Waiting for deployment "rancher" rollout to finish: 0 of 3 updated replicas are available...
...
deployment "rancher" successfully rolled out
```

## Use the Browser to login!

https://rancher.\<domain>

## Links
* https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/