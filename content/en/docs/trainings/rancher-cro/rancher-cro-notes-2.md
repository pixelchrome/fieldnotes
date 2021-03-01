---
title: "2. Installing and Managing Rancher"
linkTitle: "Installing and Managing Rancher"
weight: 2
---

# 2. Installing and Managing Rancher

Rancher offers two methods for installation, the sandbox method that uses a single Docker container for everything, and the HA method that installs into RKE.

In addition to not being highly available, the Docker method is also not compatible with the HA method. At the moment there is no supported way to migrate from one to the other, so if you deploy production clusters and later want to migrate to the HA version, you'll have to recreate all of your downstream clusters and configuration.

## 2.1 Installing Rancher With Docker

### 2.1.1 Installing Rancher

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.1.1.pdf)

[Lab 6](https://academy.rancher.com/assets/courseware/v1/d6f66921cb763f9f931472154d64a0f1/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-6-Install-Rancher-With-Docker.pdf)

#### Container Startup Flags

- `-d` daemonize
- `-p 80:80 -p 443:443` ports for HTTP and HTTPS
- `--restart=unless-stopped` the upgrade process need to stop the container

```sh
docker run -d --restart=unless-stopped \
-p 80:80 -p 443:443 \
rancher/rancher:v2.3.5
```

#### Certificates

##### Running a Rancher Server with your own certificate

```sh
$ docker run -d --restart=unless-stopped \
-p 80:80 -p 443:443 \
-v /home/ubuntu/certs/server.crt:/etc/rancher/ssl/cert.pem \
-v /home/ubuntu/certs/server.key:/etc/rancher/ssl/key.pem \
-v /home/ubuntu/certs/ca.crt:/etc/rancher/ssl/cacerts.pem \
rancher/rancher:v2.3.5
```

##### Letsencrypt

- Needs a DNS Name
- Port 80 has to be open

```sh
$ docker run -d --restart=unless-stopped \
-p 80:80 -p 443:443 \
rancher/rancher:v2.4.1 \
--acme-domain \
rancher.mydomain.com
```

#### Persistent Data

- Monted at `/var/lib/rancher`
- Bydefault a Docker volume
- Bind-mount a directory with `-v /opt/rancher:/var/lib/rancher`

Bind mounted directories are easier to backup :-)

### 2.1.2 Making Backups

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.1.2.pdf)

#### Backup Naming

- Use the software version
- Use the date

e.g. `rachner-data-backup-v2.3.5-2020-03-15.tar.gz`

#### Rancher Backups (Docker Volume)

1. Stop the Rancher Container
2. Create data container
3. Backup with a temp container that uses the same volume (e.g. busybox)
4. Start Rancher
5. Move backups offsite

##### Example

Create the volume and run a container to backup `/var/lib/rancher`

Stop the Rancher Container

```sh
docker create \
--volumes-from rancher
--name rancher-data-2020-12-12 \
racher/rancher:v2.3.5

docker run \
--volumes-from rancher-data-2020-12-12 
-v $PWD:/backup \
busybox tar pzcvf /backup/rancher-data-2020-12-12-2.3.5-2020-04-06.tar.gz /var/lib/rancher
```

Start Rancher

#### Rancher Backups (Bound Volume)

1. Stop the Rancher Container
2. Tar the local directory
3. Start Rancher
4. Move backup offsite

##### Option : Create a backup directory

Stop the Rancher Container

```sh
cd /opt
sudo cp -Rp rancher rancher.bak
```

Start Rancher

### 2.1.3 Restoring from a backup

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.1.3.pdf)

[Lab 7](https://academy.rancher.com/assets/courseware/v1/7bcff023697d1ed55da58b5ab5486afd/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-7-Backup-and-Restore-Rancher.pdf)

#### Restoring Rancher (Docker Volume)

1. Move backup onto the host
2. Stop Rancher
3. Make fresh backup
4. Restore with a temp container
5. Start Rancher

##### Example

Stop the Rancher Container

```sh
docker run \
--volumes-from rancher-data-2020-12-12 
-v $PWD:/backup \
busybox sh -c \
"rm /var/lib/rancher/* -rf && \
tar pzxvf /backup/rancher-data-2020-12-12-2.3.5-2020-04-06.tar.gz"
```

Start Rancher

#### Restoring Rancher (Bound Volume)

1. Place the backup in `/opt`
1. Stop the Rancher Container
3. Move `/opt/rancher` to `/opt/rancher.bak`
4. Extract the tarball
5. Start Rancher

##### Option : Use a backup directory

Stop the Rancher Container

```sh
cd /opt
sudo mv rancher rancher.old
sudo mv rancher.bak rancher
```

Start Rancher

### 2.1.4 Upgrading Rancher

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.1.4.pdf)

[Lab 8](https://academy.rancher.com/assets/courseware/v1/1bbf9041379503610c22cf804b7b3726/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-8-Upgrade-Rancher-Docker.pdf)

#### Upgrading Rancher (Docker Volume)

1. Stop the Rancher Container
2. Create data container
3. Backup `/var/lib/rancher`
4. Pull new container
5. Start a new container
6. Verify the upgrade
7. Delete the stopped container

##### Example

Stop the Rancher Container

Create the volume
```sh
docker create \
--volumes-from rancher
--name rancher-data-2020-12-12 \
racher/rancher:v2.3.5
```

Backup
```sh
docker run \
--volumes-from rancher-data-2020-12-12 
-v $PWD:/backup \
busybox tar pzcvf /backup/rancher-data-2020-12-12-2.3.5-2020-04-06.tar.gz /var/lib/rancher
```

Run the new container
```sh
docker run -d --volumes-from rancher-data-2020-12-12 \
-p 80:80 -p 443:443 \
rancher/rancher:v2.4.2
```


#### Upgrading Rancher (Bound Volume)

1. Stop the Rancher Container
2. Backup the local directory (tar or copy)
3. Pull new container image
4. Start a new container
5. Verify the upgrade
6. Delete the stopped container

##### Example

```sh
docker stop rancher
cd /opt
sudo cp -Rp rancher rancher.bak
docker run -d --restart=unless-stopped \
> -p 80:80 -p 443:443 \
> -v /opt/rancher:/var/lib/rancher \
> rancher/rancher:v2.4.2
```

Verify

Delete old Racher

```sh
docker rm rancher
```

## 2.2 Installing Rancher with Kubernetes

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.2.pdf)

Rancher is an application that runs inside of Kubernetes, so when deployed into an RKE cluster, Rancher uses the high availability infrastructure of Kubernetes

### 2.2.1 Deploying into RKE

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.2.1.pdf)

[Lab 9](https://academy.rancher.com/assets/courseware/v1/0db33ee145df8a780d52bee928f2e6a9/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-9-Deploy-Rancher-into-RKE.pdf)

#### Install Helm

[see here](https://helm.sh/docs/intro/install/)

```sh
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

#### Add the helm repo and update

```sh
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update
```

**Use Stable for Production!**

#### Create Namespace

The Namespace cattle-system is required

```sh
kubectl get namespaces
kubectl create namespace cattle-system
```

#### SSL Certificate Options

1. Rancher-generated self-signed
2. Auto-generated from Let's encrypt
3. Bring your own

[certmanager](https://cert-manager.io) is required for 1. & 2.

##### Install certmanager

See [documentation](https://cert-manager.io/docs/installation/kubernetes/) (v1.1.0) is currently actual

###### Example

```sh
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml
```

```sh
kubectl get deployments --namespace cert-manager
...
kubectl get deployments --namespace cert-manager
NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
cert-manager              1/1     1            1           44s
cert-manager-cainjector   1/1     1            1           44s
cert-manager-webhook      1/1     1            1           44s
```

```sh
kubectl rollout status deployments --namespace cert-manager cert-manager
deployment "cert-manager" successfully rolled out

kubectl rollout status deployments --namespace cert-manager cert-manager-cainjector
deployment "cert-manager-cainjector" successfully rolled out
```

```sh
kubectl get pods --namespace cert-manager
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-744fdd4d96-4dvck              1/1     Running   0          83s
cert-manager-cainjector-868b4b477c-ngmpg   1/1     Running   0          83s
cert-manager-webhook-6c88bc4cb8-8khxl      1/1     Running   0          83s
```

#### Default Installation of Rancher (with self-signed certificate)

- `--set hostname=rancher.mydomain.com`
- `--namespace cattle-system`

```sh
helm install rancher rancher-stable/rancher \
--version v2.3.5 \
--namespace cattle-system \
--set hostname=rancher.mydomain.com
```

##### Check the status of the rollout

```sh
kubectl rollout status deployments --namespace cattle-system rancher
deployment "rancher" successfully rolled out
```

##### Enter the Webgui

https://rancher.mydomain.com

Cluster might be unhelathy due to a bug. Got to the cluster edit screen and click safe.

#### Let's Encrypt Installation

- `--set hostname=rancher.mydomain.com`
- `--namespace cattle-system`
- `--set ingress.tls.source=letsEncrypt`
- `--set letsEncrypt.email=you@mydomain.com`

#### BYO Certificates Installation

- `--set hostname=rancher.mydomain.com`
- `--namespace cattle-system`
- `--set ingress.tls.source=secret`
- `--set privateCA=true`

Provide the certificate via a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/)

##### Create a Certificate Secret

- Create `tls.crt` with the certificates
- Create `tls.key` with the private key
- Create a secret "tls-rancher-ingress" from those files (type "tls")

```sh
kubeclt -n cattle-system cerate secret \
tls tls-rancher-ingress \
--cert=server.crt --key=server.key
```

##### Create the CA Secret

- Create `cacerts.pem` with the CA information
- Create the secret "tls-ca" from the file
- This is a "generic" secret

```sh
kubeclt -n cattle-system cerate secret \
generic tls-ca \
--from-file=cacerts.pem=./ca.crt
```

### 2.2.2 Making Backups

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.2.2.pdf)

See 1.3.2

### 2.2.3 Restoring from a backup

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-2.2.3.pdf)

[Lab 10](https://academy.rancher.com/assets/courseware/v1/505b4d1c184b06b47de978d9dfd57966/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-10-Make-and-Restore-a-Backup-in-RKE.pdf)

#### Restoring a Backup

These instructions assume that you're running a three-node HA RKE cluster for Rancher. If you're running a single-node cluster, skip the step where you add the additional two nodes and continue with repointing the load balancer or DNS entry.

#### Shut Down the Old Cluster

When you shut down the Rancher cluster that you're replacing, all of the downstream clusters will continue to operate. Users who connect through the Rancher server to manage clusters will be unable to do so until the Rancher cluster is restored, but all operational workloads will continue to run. Kubernetes will continue to maintain state.
We shut down the old cluster to cleanly disconnect the downstream clusters from Rancher.

#### Prepare New Nodes

1. Prepare three new nodes for the new cluster. These can be the same size or larger than the existing Rancher server nodes.
2. Choose one of these nodes to be the initial "target node" for the restore. We will bring this node up first and then add the other two once the cluster is online.

#### Configure RKE for Restore

1. Make a backup copy of the RKE files you used to build the original cluster. Store these in a safe place until the new cluster is online.
2. Edit cluster.yml and make the following changes:
    - Remove the "addons" section
    - Change the "nodes" section to point to the new nodes
    - Comment out all but the target node

#### Restore the Database

##### Snapshot Stored Locally

1. Place the snapshot into `/opt/rke/etcd-snapshots` on the target node
2. Restore the snapshot with `rke etcd snapshot-restore --name rke-etc-snapshot`, passing it the name of the snapshot and pointing to the `cluster.yml` file.

##### Snapshot Stored on S3

1. Restore the snapshot with `rke etcd snapshot-restore`, passing it the parameters needed to access S3.

Verify the bucket- and filename

```sh
aws s3 ls <bucketname>
```

And restore from S3
```sh
rke etcd snapshot-restore --s3 \
--name rke-etc-snapshot \
--s3-endpoint s3.amazon.com \
--bucket-name <bucketname> \
--access-key ${AWS_ACCESS_KEY_ID} --secret-key ${AWS_SECRET_ACCESS_KEY}
```

#### Bring Up the Cluster

Bring up the cluster on the target node by running `rke up`

When the cluster is ready, RKE will write a credentials file to the local directory. Configure `kubectl` to use this file and then check on the status of the cluster. Wait for the target node to change to Ready. The three old nodes will be in a NotReady state.

#### Complete the Transition to the New Cluster

1. When the target node is Ready, remove the old nodes with `kubectl delete node`.
2. Reboot the target node to ensure cluster networking and services are in a clean state
3. Wait until all pods in kube-system, ingress-nginx, and the rancher pod in cattle-system return to a Running state. `kubectl get deployments -A` & `kubectl get daemonsets -A`

The cattle-cluster-agent and cattle-node-agent pods will be in an Error or CrashLoopBackOff state until the Rancher server is up and DNS has been pointed to the new cluster.

#### Add the New Nodes
Skip this step if you're restoring a single-node cluster.
1. Edit `cluster.yml` and uncomment the additional nodes
2. Run `rke up` to add the new nodes to the cluster
3. Wait for all nodes to show Ready in the output of `kubectl get nodes`

#### Reconfigure Inbound Access

Complete any final DNS or load balancer change necessary to point the external URL to the new cluster.

After making this change the agents on the downstream clusters will automatically reconnect. Because of backoff timers on the clusters, they may take up to 15 minutes to reconnect.

#### Finishing Up

1. Securely store the new `cluster.yml`, `kube_config_cluster.yml` and `cluster.rkestate` files for future use.
2. Delete the archived configuration files from the old cluster.
3. Delete the nodes from the old cluster or clean them.

### 2.2.4 Upgrading Rancher

#### Upgrading with helm

(Don't use an alpha release - unsupported)

- Make a one-time snapshot
- Update the helm repo
- Fetch the most recent chart version (latest or stable)
- Fetch the values used in the original installation
- Use `helm upgrade` with the namespace and values
- Verify that the upgrade was successful

##### Example

Make a backup
```sh
rke etcd snapshot-save --name rke-etcd-snapshot-20200208T1932
```

Copy the backup file to a safe location! (it is in `/opt/rke/etcd-snapshots/`)

Update the repo
```sh
helm repo update
```

Fetch the values
```sh
helm list --all-namespaces -f rancher -o yaml
- app_version: v2.3.5
  chart: rancher-2.3.5
  name: rancher
  namespace: cattle-system
  revision: "1"
  status: deployed
  updated: 2021-02-08 18:21:12.721217 +0100 CET
```

```sh
helm get values -n cattle-system rancher -o yaml > values.yml
```

Upgrade
```sh
helm upgrade rancher rancher-stable/rancher \
> --version 2.3.6 \
> --namespace cattle-system \
> --values values.yml
```

```
W0208 19:39:43.482431   96484 warnings.go:70] extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
W0208 19:39:43.484913   96484 warnings.go:70] extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
W0208 19:39:43.496413   96484 warnings.go:70] extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
Release "rancher" has been upgraded. Happy Helming!
NAME: rancher
LAST DEPLOYED: Mon Feb  8 19:39:43 2021
NAMESPACE: cattle-system
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
Rancher Server has been installed.

NOTE: Rancher may take several minutes to fully initialize. Please standby while Certificates are being issued and Ingress comes up.

Check out our docs at https://rancher.com/docs/rancher/v2.x/en/

Browse to https://rancher.47.dmdy.de

Happy Containering!
```

Check the rollout status
```sh
kubectl rollout status deployments --namespace cattle-system rancher
deployment "rancher" successfully rolled out
```
