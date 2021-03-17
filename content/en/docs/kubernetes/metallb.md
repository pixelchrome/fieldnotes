---
linkTitle: "MetalLB"
weight: 15
---

# MetalLB

## Methods of announcement

* Layer 2 mode - ARP (IPv4) NDP (IPv6)
* BGP

## Prerequisites

* Multiple IPs per node must be possible
    - (this is for most public cloud provider not possible, use their Loadbalancer Service)
* Dynamic IP assignments
* Layer 2 or BGP support

## Install MetalLB with NGINX on RKE

### 1. Disable NGINX Ingress

1. Open Rancher
2. Choose the cluster
3. Edit the config (3 dots)
4. Disable under *Advanced Options*

![DisableNGINX](/notes/images/disable_ingress_nginx.png)

### 2. Install MetalLB

The following files are needed

- [`configmap.yaml`](/notes/files/ingress-nginx/configmap.yaml)
- [`generate.sh`](/notes/files/ingress-nginx/generate.sh)
- [`kustomization.yaml`](/notes/files/ingress-nginx/kustomization.yaml)

`generate.sh`

```sh
#!/bin/bash

kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey=$(openssl rand 128 | openssl enc -base64 -A) --dry-run=client -o yaml > secret.yaml
```

```sh
sh generate.sh
```

```yml
# kustomization.yaml
namespace: metallb-system
bases:
  - github.com/metallb/metallb//manifests?ref=v0.9.5
resources:
  - configmap.yaml 
  - secret.yaml
```

```yml
# configmap.yaml
# Adjust for your local IP address pool
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 10.68.0.221-10.68.0.225
```

```sh
kustomize build . | kubectl apply -f -
```

```sh
kubectl get pods -n metallb-system
NAME                          READY   STATUS    RESTARTS   AGE
controller-65db86ddc6-s6tj9   1/1     Running   0          11m
speaker-7ck5k                 1/1     Running   0          11m
speaker-h2skc                 1/1     Running   0          11m
speaker-klkbl                 1/1     Running   0          11m
```

### 3. Install NGINX

The following files are needed

- [`kustomization.yaml`](/notes/files/ingress-nginx/kustomization.yaml)
- [`namespace.yaml`](/notes/files/ingress-nginx/namespace.yaml)
- [`service.yaml`](/notes/files/ingress-nginx/service.yaml)
- [`base/deployment.yaml`](/notes/files/ingress-nginx/base/deployment.yaml)
- [`base/kustomization.yaml`](/notes/files/ingress-nginx/base/kustomization.yaml)
- [`base/role-binding.yaml`](/notes/files/ingress-nginx/base/role-binding.yaml)
- [`base/role.yaml`](/notes/files/ingress-nginx/base/role.yaml)
- [`base/service-account.yaml`](/notes/files/ingress-nginx/base/service-account.yaml)
- [`base/service.yaml`](/notes/files/ingress-nginx/base/service.yaml)
- [`configs/nginx.conf.yaml`](/notes/files/ingress-nginx/configs/nginx.conf.yaml)
- [`configs/tcp-services.yaml`](/notes/files/ingress-nginx/configs/tcp-services.yaml)
- [`configs/udp-services.yaml`](/notes/files/ingress-nginx/configs/udp-services.yaml)

```sh
kustomize build . | kubectl apply -f -
namespace/ingress-nginx created
serviceaccount/nginx-ingress-serviceaccount created
Warning: rbac.authorization.k8s.io/v1beta1 Role is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 Role
role.rbac.authorization.k8s.io/nginx-ingress-role created
Warning: rbac.authorization.k8s.io/v1beta1 RoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 RoleBinding
rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
configmap/nginx-configuration created
configmap/tcp-services created
configmap/udp-services created
service/ingress-nginx created
limitrange/ingress-nginx created
deployment.apps/nginx-ingress-controller created
```

```sh
kubectl get service -n ingress-nginx
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                      AGE
ingress-nginx   LoadBalancer   10.43.113.128   192.168.11.118   80:31103/TCP,443:32270/TCP   98s
```

```sh
ping 192.168.11.118
PING 192.168.11.118 (192.168.11.118) 56(84) bytes of data.
64 bytes from 192.168.11.118: icmp_seq=1 ttl=64 time=0.475 ms
```

## Links
* [MetalLB](https://metallb.universe.tf)
* [Configs for ingress-nginx](https://gitlab.com/monachus/channel/-/tree/master/resources/2020.01)
* [Kubernetes 101: Why You Need To Use MetalLB](https://www.youtube.com/watch?v=Ytc24Y0YrXE)
