---
title: "1. Intro to Rancher and RKE"
linkTitle: "Intro to Rancher and RKE"
weight: 1
---

# 1. Intro to Rancher and RKE

## 1.1 Learning the Architecture - Introduction

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.1.pdf)

Company Rancher Labs

Product Rancher Server 

Product RKE **R**ancher **K**ubernetes **E**ngine - makes it easy to install Kubernetes

### 1.1.1 Rancher Server Concepts

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.1.1.pdf)

The Rancher Management Cluster

- Authentication Proxy
- Rancher API Server
- etcd (Rancher Server Data Store)
- Cluster Controler 1 & 2

![Rancher Architecture](https://rancher.com/docs/img/rancher/rancher-architecture-rancher-api-server.svg)

### 1.1.2 Communication With Downstream Clusters

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.1.2.pdf)

--------------------------

##### Authentication

- Who are you?
- Handled by Rancher

##### Authorization

- What are you allowed to do?
- Handled by Kubernetes

--------------------------

#### [Athentication Proxy](https://rancher.com/docs/rancher/v2.x/en/overview/architecture/#1-the-authentication-proxy)

- Receives requests from a user
- *Authenticates* the user
- Forwards request to Kubernetes on behalf of user

#### [API Server](https://rancher.com/docs/rancher/v2.x/en/overview/#features-of-the-rancher-api-server)

- Performs *Authorization* of the request

#### [Cluster Controller](https://rancher.com/docs/rancher/v2.x/en/overview/architecture/#2-cluster-controllers-and-cluster-agents)

- Runs within Rancher cluster
- One per Kubernetes cluster
- Watches for resource changes
- Controls downstream cluster state
- Configures access control policies
- Provision clusters

#### Cluster Agent

- Connects to the Kubernetes API
- Manages workloads within each cluster
- Applying roles and bindings
- Communicates w/ Rancher server through tunnel

#### [Node Agent](https://rancher.com/docs/rancher/v2.x/en/overview/architecture/#1-the-authentication-proxy)

- Runs as a DaemonSet
- Upgrades Kubernetes
- Restores etcd snapshots
- Can fill in for Cluster Agent

#### kube-api-auth

*The `kube-api-auth` microservice is deployed to provide the user authentication functionality for the authorized cluster endpoint. When you access the user cluster using `kubectl`, the cluster’s Kubernetes API server authenticates you by using the `kube-api-auth` service as a webhook.*

#### [Authorized Cluster Endpoint](https://rancher.com/docs/rancher/v2.x/en/overview/architecture/#4-authorized-cluster-endpoint)

- Enables direct communication
- Useful if the Rancher Server is down
- Useful if the cluster is closer to the user than Rancher

#### Communicating with Downstream User Clusters

![Communicating with Downstream User Clusters](https://rancher.com/docs/img/rancher/rancher-architecture-cluster-controller.svg)

### 1.1.3 Architectural Best Practices

- Run a Docker deployment of Rancher on its own node
- Run a Kubernetes deployment of Rancher in an RKE cluster
  - Dedicate that cluster to Rancher
  - Don't run user workloads on that cluster
- If Rancher is managing production workloads, run an HA Rancher cluster
- Use a Layer 4 load balancer in front of an HA Rancher cluster (Port 80 & 443)
  - Avoid doing SSL termination on the load balancer
- Run the Rancher cluster near the downstream cluster it's managing
- The Rancher management cluster can start with three nodes and add additional workers as it grows
  - Downstream clusters can combine or split etcd and controlplane roles
- Put a Layer 4 load balancer in front of the controlplane nodes when using the Authorized Cluster Endpoint feature
- Watch the Rancher management cluster. As you add more downstream clusters, it will need to grow to handle them

## 1.2 Discovering RKE - Introduction

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.2.pdf)

#### **R**ancher **K**ubernetes **E**ngine - **RKE**

Certified by CNCF runs entirly in Docker Containers

#### RKE Configuration:

- Declarative configuration file
- Apply with `rke up`
- Runs from a local workstation
- Connects over SSH
- Installs Kubernetes
- Generates a kubectl config

#### Changes:

- Changes happen in the config file
- Changes are applied with `rke up`

### 1.2.1 Installing RKE

- [Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.2.1.pdf)
- [Lab 1](https://academy.rancher.com/assets/courseware/v1/934f8183b7c8a2949ff3c590916fad06/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-1-Download-and-Install-RKE.pdf)

https://github.com/rancher/rke

Binaries exist for Windows, macOS and Linux

- Download the binary
- Move it into your path
- Make it executable

Install it on a Mac wit `brew`

### 1.2.2 Preparing Nodes for Kubernetes

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.2.2.pdf)

Install Docker on Host. 

#### Node Preparation

1. SSH user in docker group
2. Disable swap on worker nodes

#### Example:

[See here](https://rancher.com/docs/rancher/v2.x/en/installation/requirements/installing-docker/)

`curl https://releases.rancher.com/install-docker/18.09.sh | sh`

#### Network Requirements

`rke` needs access via SSH (Port 22) and Port 6443 on every controlplane-node

#### SSH Configuration (server)

- `AllowTcpForwarding yes`
- Your public key in the `authorized_keys`


#### SSH Configuration (client)

- Use `--ssh-agent-auth` if your key has a passphrase

### 1.2.3 Creating the Cluster Configuration File

- [Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.2.3.pdf)
- [Lab 2](https://academy.rancher.com/assets/courseware/v1/0a06878ce1bac008013c9bb31d143adf/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-2-Create-an-RKE-Configuration-File.pdf)

#### Minimal RKE Configuration

```yml
nodes:
    - address: 192.168.100.101
      user: ubuntu
      role:
        - controlplane
        - etcd
        - worker
```

#### Generating the Config

- Use `rke config`
- Answer the questions
- Customize the config

### 1.2.4 Certificate Option

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.2.4.pdf)

Kubernetes secures its communication between its nodes with TLS certificates. RKE generates the certificates for you. RKE can use Certificates from a directory or create CSRs (Certificate Signing Requests)

### 1.2.5 Deploying Kubernetes

- [Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.2.5.pdf)
- [Lab 3](https://academy.rancher.com/assets/courseware/v1/6c0cf27401e4e08fee57fe50aad27745/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-3-Deploy-an-RKE-Cluster.pdf)

`rke up`

## 1.3 Day Two Operations

- Set `$KUBECONFIG` to use with `kubectl`

```sh
export KUBECONFIG=$(pwd)/kube_config_cluster.yml
```

### 1.3.1 Secure the Installation Files

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.3.1.pdf)

Generated Files. These are critical for accessing the cluster and for late changes of the config.

- `kube_config_cluster.yml` - Kubeconfig File. Copy it to `~/.kube/config` **but keep the original in this directory**
- `cluster.rkestate` - Certificate and Credential Information for accessing the cluster

### 1.3.2 Backup and Recovery

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.3.2.pdf)

#### Snapshot defaults

- Every 6 hours
- Keep for 24 hours

#### Manual Backups

```sh
rke etcd snapshot-save
```

Writes to the directory `/opt/rke/etcd-snapshots` on all etcd nodes

Copy the backup of the hosts or configure to safe it to a S3 target.

#### Examples

##### Manual Backup

```sh
➜  rke-cluster rke etcd snapshot-save \
--config cluster.yml \
--name snapshot-20201124T1507


INFO[0000] Running RKE version: v1.1.0                  
INFO[0000] Starting saving snapshot on etcd hosts       
INFO[0000] [dialer] Setup tunnel for host [192.168.11.113] 
INFO[0000] [dialer] Setup tunnel for host [192.168.11.112] 
INFO[0000] [dialer] Setup tunnel for host [192.168.11.111] 
INFO[0000] [etcd] Running snapshot save once on host [192.168.11.111] 
INFO[0000] Image [rancher/rke-tools:v0.1.56] exists on host [192.168.11.111] 
INFO[0000] Starting container [etcd-snapshot-once] on host [192.168.11.111], try #1 
INFO[0001] [etcd] Successfully started [etcd-snapshot-once] container on host [192.168.11.111] 
INFO[0001] Waiting for [etcd-snapshot-once] container to exit on host [192.168.11.111] 
INFO[0001] Container [etcd-snapshot-once] is still running on host [192.168.11.111] 
INFO[0002] Waiting for [etcd-snapshot-once] container to exit on host [192.168.11.111] 
INFO[0002] Removing container [etcd-snapshot-once] on host [192.168.11.111], try #1 
INFO[0002] [etcd] Running snapshot save once on host [192.168.11.112] 
INFO[0002] Image [rancher/rke-tools:v0.1.56] exists on host [192.168.11.112] 
INFO[0002] Starting container [etcd-snapshot-once] on host [192.168.11.112], try #1 
INFO[0002] [etcd] Successfully started [etcd-snapshot-once] container on host [192.168.11.112] 
INFO[0002] Waiting for [etcd-snapshot-once] container to exit on host [192.168.11.112] 
INFO[0002] Container [etcd-snapshot-once] is still running on host [192.168.11.112] 
INFO[0003] Waiting for [etcd-snapshot-once] container to exit on host [192.168.11.112] 
INFO[0003] Removing container [etcd-snapshot-once] on host [192.168.11.112], try #1 
INFO[0003] [etcd] Running snapshot save once on host [192.168.11.113] 
INFO[0003] Image [rancher/rke-tools:v0.1.56] exists on host [192.168.11.113] 
INFO[0003] Starting container [etcd-snapshot-once] on host [192.168.11.113], try #1 
INFO[0003] [etcd] Successfully started [etcd-snapshot-once] container on host [192.168.11.113] 
INFO[0003] Waiting for [etcd-snapshot-once] container to exit on host [192.168.11.113] 
INFO[0003] Container [etcd-snapshot-once] is still running on host [192.168.11.113] 
INFO[0004] Waiting for [etcd-snapshot-once] container to exit on host [192.168.11.113] 
INFO[0004] Removing container [etcd-snapshot-once] on host [192.168.11.113], try #1 
INFO[0004] Finished saving/uploading snapshot [snapshot-20201124T1507] on all etcd hosts
```

```sh
➜  rke-cluster ssh ubuntu@rke1 ls /opt/rke/etcd-snapshots
snapshot-20201124T1507.zip
```

##### Write to a S3 bucket

```sh
➜  rke-cluster rke etcd snapshot-save \
--config cluster.yml \
--name snapshot-20201124T1507
--s3 \
--access-key $ACCESS_KEY \
--secret-key $SECRET_KEY \
--bucket-name examlpe-rke-bucket \
--folder test \
--s3-endpoint s3.example.com --ssh-agent-auth
```

This will write a local snapshot and also to the s3 bucket!

#### Snapshot Configuration

![](img/backup_config.png)

`cluster.yml`

- `interval_hours`
- `retention`
- `s3backupconfig`

`cluster.yml`
```yml
...
    backup_config: null
...
```

Change to:

```yml
    backup_config:
        interval_hours: 6
        retention: 8
```



#### Using Minio

- Drop-in replacement for S3
- Works with private and self-signed certs
- Place CA signing cert in RKE config

(Will be shown in Level 2 of this program)

#### Restoring a Snapshot

- Use `rke etcd snapshot-restore --name <name-of-the-snapshot>`
- Run from the directory with the configs
- Place snapshot in the directory `/opt/rke/etcd-snapshots` on one node

### 1.3.3 Upgrading Kubernetes

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.3.3.pdf)

[Lab 4](https://academy.rancher.com/assets/courseware/v1/8e1b9468e404d48355fd46e7586e6046/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-4-Upgrade-an-RKE-Cluster.pdf)

- Upgrade your local copy of `rke`
- Use `rke config --version -all` to see available versions
- Make a one-time snapshot (and move it off the cluster hosts)
- Set the version in the `kubernetes_version` key in `cluster.yml`
- Don't set it under `sytem_images`
- Remove every version under the `system_images:`

#### Get Versions

```sh
$ rke -v
rke version v1.2.5
```

```sh
$ rke config --version -all
v1.16.15-rancher1-4
v1.17.17-rancher1-1
v1.18.15-rancher1-1
v1.19.7-rancher1-1
```

```sh
$ kubectl get nodes -o wide --kubeconfig kube_config_cluster.yml
NAME             STATUS   ROLES                      AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
192.168.11.111   Ready    controlplane,etcd,worker   79d   v1.19.7   192.168.11.111   <none>        Ubuntu 20.04.1 LTS   5.4.0-65-generic   docker://19.3.13
```

#### Upgrading

```sh
$ rke up
```

### 1.3.4 Certificate Management

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.3.4.pdf)

#### Certificate Rotation

- Use `rke cert rotate`
- Pass flags for
  - All Certificates
  - Certificates for specific services
  - All certs and the CA


#### Rotate Everything! :-)

```sh
$ rke cert rotate --rotate-ca
```
##### Example

```sh
❯ rke cert rotate --rotate-ca
INFO[0000] Running RKE version: v1.2.5                  
INFO[0000] Initiating Kubernetes cluster                
INFO[0000] Rotating Kubernetes cluster certificates     
INFO[0000] [certificates] Generating CA kubernetes certificates 
INFO[0000] [certificates] Generating Kubernetes API server aggregation layer requestheader client CA certificates 
INFO[0000] [certificates] GenerateServingCertificate is disabled, checking if there are unused kubelet certificates 
INFO[0000] [certificates] Generating Kubernetes API server certificates 
INFO[0000] [certificates] Generating Kube Controller certificates 
INFO[0000] [certificates] Generating Kube Scheduler certificates 
INFO[0001] [certificates] Generating Kube Proxy certificates 
INFO[0001] [certificates] Generating Node certificate   
INFO[0001] [certificates] Generating admin certificates and kubeconfig 
INFO[0001] [certificates] Generating Kubernetes API server proxy client certificates 
INFO[0001] [certificates] Generating kube-etcd-192-168-11-111 certificate and key 
INFO[0001] Successfully Deployed state file at [./cluster.rkestate] 
INFO[0001] Rebuilding Kubernetes cluster with rotated certificates 
INFO[0001] [dialer] Setup tunnel for host [192.168.11.111] 
INFO[0002] [certificates] Deploying kubernetes certificates to Cluster nodes 
INFO[0002] Checking if container [cert-deployer] is running on host [192.168.11.111], try #1 
INFO[0002] Image [rancher/rke-tools:v0.1.69] exists on host [192.168.11.111] 
INFO[0002] Starting container [cert-deployer] on host [192.168.11.111], try #1 
INFO[0002] Checking if container [cert-deployer] is running on host [192.168.11.111], try #1 
INFO[0007] Checking if container [cert-deployer] is running on host [192.168.11.111], try #1 
INFO[0008] Removing container [cert-deployer] on host [192.168.11.111], try #1 
INFO[0008] [reconcile] Rebuilding and updating local kube config 
INFO[0008] Successfully Deployed local admin kubeconfig at [./kube_config_cluster.yml] 
WARN[0008] [reconcile] host [192.168.11.111] is a control plane node without reachable Kubernetes API endpoint in the cluster 
WARN[0008] [reconcile] no control plane node with reachable Kubernetes API endpoint in the cluster found 
INFO[0008] [certificates] Successfully deployed kubernetes certificates to Cluster nodes 
INFO[0008] [file-deploy] Deploying file [/etc/kubernetes/audit-policy.yaml] to node [192.168.11.111] 
INFO[0008] Image [rancher/rke-tools:v0.1.69] exists on host [192.168.11.111] 
INFO[0008] Starting container [file-deployer] on host [192.168.11.111], try #1 
INFO[0008] Successfully started [file-deployer] container on host [192.168.11.111] 
INFO[0008] Waiting for [file-deployer] container to exit on host [192.168.11.111] 
INFO[0008] Waiting for [file-deployer] container to exit on host [192.168.11.111] 
INFO[0008] Container [file-deployer] is still running on host [192.168.11.111]: stderr: [], stdout: [] 
INFO[0009] Waiting for [file-deployer] container to exit on host [192.168.11.111] 
INFO[0009] Removing container [file-deployer] on host [192.168.11.111], try #1 
INFO[0009] [remove/file-deployer] Successfully removed container on host [192.168.11.111] 
INFO[0009] [/etc/kubernetes/audit-policy.yaml] Successfully deployed audit policy file to Cluster control nodes 
INFO[0009] Successfully Deployed state file at [./cluster.rkestate] 
INFO[0009] [state] Saving full cluster state to Kubernetes 
INFO[0014] [state] Successfully Saved full cluster state to Kubernetes ConfigMap: full-cluster-state 
INFO[0014] [etcd] Restarting up etcd plane..            
INFO[0014] Restarting container [etcd] on host [192.168.11.111], try #1 
INFO[0014] [restart/etcd] Successfully restarted container on host [192.168.11.111] 
INFO[0014] [etcd] Successfully restarted etcd plane..   
INFO[0014] [controlplane] Check if rotating a legacy cluster 
INFO[0014] [controlplane] Restarting the Controller Plane.. 
INFO[0014] Restarting container [kube-apiserver] on host [192.168.11.111], try #1 
INFO[0020] [restart/kube-apiserver] Successfully restarted container on host [192.168.11.111] 
INFO[0020] Restarting container [kube-controller-manager] on host [192.168.11.111], try #1 
INFO[0020] [restart/kube-controller-manager] Successfully restarted container on host [192.168.11.111] 
INFO[0020] Restarting container [kube-scheduler] on host [192.168.11.111], try #1 
INFO[0020] [restart/kube-scheduler] Successfully restarted container on host [192.168.11.111] 
INFO[0020] [controlplane] Successfully restarted Controller Plane.. 
INFO[0020] [worker] Restarting Worker Plane..           
INFO[0020] Restarting container [kubelet] on host [192.168.11.111], try #1 
INFO[0020] [restart/kubelet] Successfully restarted container on host [192.168.11.111] 
INFO[0020] Restarting container [kube-proxy] on host [192.168.11.111], try #1 
INFO[0021] [restart/kube-proxy] Successfully restarted container on host [192.168.11.111] 
INFO[0021] [worker] Successfully restarted Worker Plane.. 
INFO[0021] Restarting network, ingress, and metrics pods
```

### 1.3.5 Adding and removing Nodes

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-1.3.5.pdf)
[Lab 5](https://academy.rancher.com/assets/courseware/v1/cfc9d4e9fd3a0587bdafcf38e5076532/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-5-Add-Nodes-to-an-RKE-Cluster.pdf)

#### Add Nodes

Edit `cluster.yml` and copy the section below `nodes:`

From this

```yml
nodes:
- address: 192.168.11.111
  port: "22"
  internal_address: ""
  role:
  - controlplane
  - worker
  - etcd
  hostname_override: ""
  user: ubuntu
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: ~/.ssh/id_rsa
  ssh_cert: ""
  ssh_cert_path: ""
  labels: {}
  taints: []
```

to that

```yml
nodes:
- address: 192.168.11.111
  port: "22"
  internal_address: ""
  role:
  - controlplane
  - worker
  - etcd
  hostname_override: "rke-1"
  user: ubuntu
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: ~/.ssh/id_rsa
  ssh_cert: ""
  ssh_cert_path: ""
  labels: {}
  taints: []
- address: 192.168.11.112
  port: "22"
  internal_address: ""
  role:
  - controlplane
  - worker
  - etcd
  hostname_override: "rke-2"
  user: ubuntu
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: ~/.ssh/id_rsa
  ssh_cert: ""
  ssh_cert_path: ""
  labels: {}
  taints: []
- address: 192.168.11.113
  port: "22"
  internal_address: ""
  role:
  - controlplane
  - worker
  - etcd
  hostname_override: "rke-3"
  user: ubuntu
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: ~/.ssh/id_rsa
  ssh_cert: ""
  ssh_cert_path: ""
  labels: {}
  taints: []
```

After that `rke up`

