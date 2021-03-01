---
title: "4. Managing Kubernetes with Rancher"
linkTitle: "Managing Kubernetes with Rancher"
weight: 4
---

# 4. Managing Kubernetes with Rancher

## 4.1 Editing Clusters

### 4.1.1 Editing Cluster Options

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.1.1.pdf)

Once the cluster is up and running, you make changes to it from the edit screen. In addition to changing cluster membership for hosted, imported, and RKE clusters (infrastructure and custom), you can also edit cluster options and manage node pools for RKE clusters (infrastructure and custom).
The only option that you cannot change after installation is the network provider.

#### Example add dedicated worker nodes

```sh
kubectl get nodes
NAME   STATUS     ROLES                      AGE    VERSION
rke1   Ready      controlplane,etcd,worker   3d2h   v1.17.4
rke2   Ready      controlplane,etcd,worker   3d2h   v1.17.4
rke3   Ready      controlplane,etcd,worker   3d2h   v1.17.4
rke5   Ready      worker                     45s    v1.17.4
rke6   NotReady   worker                     46s    v1.17.4
```

```sh
kubectl drain rke1 --ignore-daemonsets=true
```

Remove the worker role from rke1,2,3

### 4.1.2 Upgrading Kubernetes

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.1.2.pdf)

[Lab 20](https://academy.rancher.com/assets/courseware/v1/ac1c62fa460838c9b4749c0e886c347b/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-20-Upgrade-Downstream-RKE-Cluster.pdf)

1. Review version release notes, and paying careful attention to the urgent upgrade notes.
2. Review how upgrades work.
3. Backup your Kubernetes cluster, where Rancher is installed.
4. Review the recommended best practices and the configuration options for upgrades.
5. To upgrade your Kubernetes version. Navigate to Global.
6. For the cluster you’re upgrading, select Edit
7. Under Cluster Options, change the Kubernetes Version.
8. Scroll to the bottom and click Save.
9. As the cluster updates, you’ll see its progress.
10. As the cluster upgrades, components may be unhealthy temporarily

## 4.2 Using the CLI Tools

Kubernetes and Rancher has APIs. Those can be used to make changes.

### 4.2.1 Kubectl

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.2.1.pdf)



#### `kubectl` can be used within the Rancher Web-UI

##### Example

```sh
kubectl config set-context --current --namespace test
kubectl create deploy nginx --image=nginx:1.17-alpine
```

Note: Environment is already set

#### `kubectl` can be used from your local system

- Download the `kubeconfig` file
- Set the `$KUBECONFIG` environment variable

##### Example

```sh
export KUBECONFIG=$(pwd)/kube_config.yml
kubectl get deploy --namespace test
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   2/2     2            2           11m
```

### 4.2.2 Rancher CLI

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.2.2.pdf)

[Lab 21](https://academy.rancher.com/assets/courseware/v1/024b6c4cd855ebeffbf43fba778ec328/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-21-kubectl-and-the-Rancher-CLI.pdf)

#### Get the Rancher CLI

* You can download the Rancher CLI from the Web UI (Bottom right corner)
* (macOS) Install it with `brew install rancher-cli`

#### API Key

You need to create a API Key. Save the information when shown!

##### Example

-------------------------------

Endpoint:
https://rancher.47.dmdy.de/v3  

Access Key (username):
token-9dvw4  

Secret Key (password):
zmz86xqtw8njlszvzdprgq6x4zffzcllrxb7mgm42xpmn8jkvd9j7z  

Access Key and Secret Key can be sent as the username and password for HTTP Basic auth to authorize requests. You can also combine them to use as a Bearer token:

Bearer Token:
token-9dvw4:zmz86xqtw8njlszvzdprgq6x4zffzcllrxb7mgm42xpmn8jkvd9j7z  

Save the info above! This is the only time you'll be able to see it.
If you lose it, you'll need to create a new API key.

-------------------------------

#### Usage

##### Login

```sh
rancher login https://rancher.47.dmdy.de/v3 --token token-9dvw4:zmz86xqtw8njlszvzdprgq6x4zffzcllrxb7mgm42xpmn8jkvd9j7z
The authenticity of server 'https://rancher.47.dmdy.de' can't be established.
Cert chain is : [Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 292221897768451679565166829765081162254 (0xdbd7e3ecc8cc175d1ce63a2262b3e20e)
    Signature Algorithm: SHA256-RSA
        Issuer: O=the-ranch,CN=cattle-ca
        Validity
            Not Before: Feb 8 17:22:18 2021 UTC
            Not After : May 9 17:22:18 2021 UTC
        Subject: O=cert-manager
        Subject Public Key Info:
            Public Key Algorithm: RSA
                Public-Key: (2048 bit)
                Modulus:
                    c2:c0:13:1d:a3:8e:22:b9:98:c5:f1:5f:0c:d3:ac:
                    aa:9f:0a:dc:f3:8d:5f:68:58:ad:4c:ed:12:6d:20:
                    f9:e6:fe:12:90:03:dc:ef:a4:18:be:0c:41:8c:5d:
                    c2:d9:78:60:51:95:1e:d9:d5:62:54:98:92:4e:37:
                    23:12:87:ba:34:90:fa:c4:03:2a:dc:01:42:cb:b5:
                    a4:43:8e:d9:65:5f:31:a8:dc:39:0e:a9:24:a2:c8:
                    9e:02:b9:f4:d8:a4:f3:62:b8:a4:a0:c6:26:bb:88:
                    17:95:56:a6:7f:aa:a7:c9:2c:16:50:48:25:49:73:
                    3c:76:5a:33:40:87:0f:e8:ec:32:84:ea:0f:be:71:
                    8d:28:2c:3b:df:25:c8:bc:93:57:3d:e3:16:47:1a:
                    d2:9a:1c:38:bf:b0:7d:8a:de:ee:f6:33:03:6a:ff:
                    f5:83:94:2e:d1:71:b4:47:ba:1c:24:93:f1:bb:91:
                    f5:c0:2a:b9:e4:42:29:4a:63:a4:16:53:78:1d:3f:
                    ee:08:bc:f3:5c:41:6c:0a:74:43:5a:9e:0c:e7:57:
                    50:62:a2:94:e8:70:73:16:cd:89:fe:16:44:40:cc:
                    9d:08:f1:70:c0:ec:ea:c6:44:87:e1:c3:29:c0:0f:
                    3a:d1:36:16:ef:1e:6a:cf:1c:2e:3e:a4:83:b6:c9:
                    13
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Subject Alternative Name:
                DNS:rancher.47.dmdy.de

    Signature Algorithm: SHA256-RSA
         23:2d:08:4f:4c:4f:a0:31:36:b1:a8:d6:fd:83:47:e9:93:8a:
         3c:7f:67:28:5d:c6:43:b7:e4:1b:95:e8:45:e8:f9:6c:8a:0e:
         bd:93:84:9d:20:35:58:40:17:98:11:33:8d:d0:04:93:33:e4:
         8a:6d:04:c1:4e:4a:e7:42:92:06:5f:1d:ac:19:f6:6a:5c:61:
         09:78:a4:29:9b:1d:5a:6e:40:ed:87:01:bb:b7:ab:36:79:f1:
         95:76:8d:95:a2:ab:3e:e4:98:ff:58:bf:31:e3:57:42:e3:a3:
         ed:65:cd:89:93:e9:41:c3:86:71:ac:78:da:fd:82:3e:eb:60:
         bd:e8:e1:1a:1d:31:a6:3a:a0:08:d5:dd:36:66:22:d3:8c:31:
         44:43:35:fc:de:53:79:ce:d0:18:ae:e8:20:c0:59:d7:f3:e5:
         5a:83:ce:a5:89:22:35:7c:75:14:41:ce:46:4a:5d:33:18:07:
         50:89:87:47:79:db:ce:51:ce:ff:02:a2:29:88:77:0f:a4:d0:
         a3:39:38:c5:86:12:8c:59:d0:9a:75:70:c3:a2:8e:9c:12:9b:
         12:b0:ee:46:aa:d8:9f:3d:64:bd:25:23:cc:45:c2:00:4f:6a:
         99:38:f7:8e:9c:65:ca:10:b4:a4:79:6d:f3:e6:aa:47:ec:99:
         fd:bc:56:c3
] 
Do you want to continue connecting (yes/no)? yes
NUMBER    CLUSTER NAME   PROJECT ID        PROJECT NAME   PROJECT DESCRIPTION
1         rke123-v6      c-stg88:p-d7wwk   test-project   
2         rke123-v6      c-stg88:p-hl76m   Default        Default project created for the cluster
3         rke123-v6      c-stg88:p-s2lrh   System         System project created for the cluster
4         local          local:p-fd5c7     Default        Default project created for the cluster
5         local          local:p-kvz97     System         System project created for the cluster
Select a Project:1
INFO[0007] Saving config to /Users/hdumdey/.rancher/cli2.json
```

#### Switch Context

```sh
rancher context switch
NUMBER    CLUSTER NAME   PROJECT ID        PROJECT NAME   PROJECT DESCRIPTION
1         rke123-v6      c-stg88:p-d7wwk   test-project   
2         rke123-v6      c-stg88:p-hl76m   Default        Default project created for the cluster
3         rke123-v6      c-stg88:p-s2lrh   System         System project created for the cluster
4         local          local:p-fd5c7     Default        Default project created for the cluster
5         local          local:p-kvz97     System         System project created for the cluster
Select a Project:2
INFO[0007] Setting new context to project Default       
INFO[0007] Saving config to /Users/hdumdey/.rancher/cli2.json 
```

#### Proxying Kubectl Commands

If you're using the Rancher CLI, you don't also need a kubectl config file.

##### Example

```sh
kubectl get nodes
NAME   STATUS   ROLES                      AGE    VERSION
rke1   Ready    controlplane,etcd,worker   3d5h   v1.17.4
rke2   Ready    controlplane,etcd,worker   3d5h   v1.17.4
rke3   Ready    controlplane,etcd,worker   3d5h   v1.17.4
rke5   Ready    worker                     154m   v1.17.4
rke6   Ready    worker                     154m   v1.17.4

rancher kubectl get nodes
NAME   STATUS   ROLES                      AGE    VERSION
rke1   Ready    controlplane,etcd,worker   3d5h   v1.17.4
rke2   Ready    controlplane,etcd,worker   3d5h   v1.17.4
rke3   Ready    controlplane,etcd,worker   3d5h   v1.17.4
rke5   Ready    worker                     154m   v1.17.4
rke6   Ready    worker                     154m   v1.17.4
```

## 4.3 Interacting With Monitoring and Logging

### 4.3.1 Enable Advanced Monitoring

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.3.1.pdf)

#### Prometheus Configuration

- Data Retention: How long to keep data
- Persistent Storage: Required for long-term retention
- Node Exporter: Enables host monitoring
- Selectors/Tolerations: Controls Workloads scheduling

#### Enable and setup

1. Click on 'Enable Monitoring'
2. Change the **Data Retention** to several Days (e.g. 72)
3. Enable **Persistent Storage** (also for *Grafana*)

Check the 'System' Project for status


![rancher enable monitoring](img/rancher_cluster.png)

#### Access

See **Cluster Metrics** and more

![rancher monitoring](img/rancher_monitoring.png)

### 4.3.2 Use the Grafana Dashboards

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.3.2.pdf)

[Lab 22](https://academy.rancher.com/assets/courseware/v1/ce2fe5d60a5725bf42033db918807882/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-22-Activate-and-Use-Advanced-Monitoring.pdf)

### 4.3.3 Configure Notifiers

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.3.3.pdf)

Notifiers are the services which inform you of alert events.

Rancher integrates with the following services:

- Slack, which also works with Mattermost
- Email
- PagerDuty
- Webhook
- WeChat

These can be only set on the cluster level

### 4.3.4 Configure Alerts

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.3.4.pdf)

[Lab 23](https://academy.rancher.com/assets/courseware/v1/6513938121a94a09aedb974ecbb18206/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-23-Cluster-Alert-and-Notifier.pdf)

#### Default Alerts
When Rancher builds a cluster with RKE, it installs a number of alerts for the cluster components.

They're things like:
- Send an alert if etcd leader changes more than three times in three minutes. This could indicate a networking issue affecting etcd quorum.
- Send an alert if one of the Kubernetes masters enters an unhealthy state.
- Send an alert if a node's resources are under excessive load.

Rancher also installs a set of alerts when monitoring is activated for a **project**.

#### Alert Groups
You can group alerts into arbitrary collections. The defaults have them grouped by component or node.

#### Alert Timing

- **Group Wait Time** - How long to buffer alerts of the same group before sending out the first alert
- **Group Interval Time** - How long to wait before sending out a new notification for an alert that is added to a group that contains alerts which have already fired
- **Repeat Interval Time** - How long to wait before resending any alert that has already been sent.

#### Alert Urgency

All alerts have an urgency level.

#### Cluster Alerts

Alert configuration is available for different types.

- System services - Core Components
- Resource events - Operations Kubernetes resources
- Node events - Unresponsive oversubscribed nodes
- Node selector events - similar to Node events but for all nodes that match a selector.
- Metric expression - configure alerts for arbitrary PromQL expressions.

#### Project Alerts

- Pod alerts - configure alerts for a specific Pod.
- Workload alerts - All Pods within a specific workload
- Workload selector alerts - configure alerts for workloads that match a selector
- Metric expression - Arbitrary PromQL expressions (require that advanced monitoring is active for the cluster)

#### Limitations for Imported and Hosted Clusters

- Imported and hosted clusters don't provide access to etcd, so Rancher is unable to perform monitoring of the data plane.
- You'll see this after activating advanced monitoring - the default alerts that it installs will report “No metric graph data”
- The ETCD tile in the cluster overview screen will not have a Grafana icon.

### 4.3.5 Configure Logging

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.3.5.pdf)

Rancher can write logs to

- Elasticsearch
- Splunk 
- Fluentd
- Kafka
- syslog

See [here](https://rancher.com/docs/rancher/v2.x/en/logging/v2.0.x-v2.4.x/cluster-logging/) for more details.

## 4.4 Configuring Namespaces and Namespace Groups (Projects)

### 4.4.1 Namespace Overview

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.4.1.pdf)

Kubernetes describes Namespaces as "virtual clusters within a physical cluster"

Rancher also applies RBAC policies to namespaces, but it includes an additional structure called a *Project*, which is a collection of namespaces.

### 4.4.2 Projects as Namespace Groups

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.4.2.pdf)

[Lab 24](https://academy.rancher.com/assets/courseware/v1/89ba05735d2cf768fec933ff9550c637/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-24-Create-a-New-Project-With-a-Dedicated-Namespace.pdf)

Rancher uses *Projects* to group namespaces and apply a common configuration for RBAC to all of them.

#### Project-Level Resources

- ConfigMaps
- Secrets
- Certificates
- Registry Credentials

#### Namespace-Level Resources

- Workloads
- Load Balancers / Ingress
- Service Discovery records
- Persistent Volume Claims

#### Default Projects

- Default: Users workloads
- System: System workloads (cannot be deleted)

### 4.4.3 Project Security

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.4.3.pdf)

[Lab 25](https://academy.rancher.com/assets/courseware/v1/9642e7f1e8249f7d951c079ec1761245/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-25-Create-a-Non-Privileged-User__1_.pdf)

#### Users Access Level

- Owner - full control
- Member - control the resources, but not the project
- Read Only - can view resources
- Custom - access limited by granted roles

#### Network Isolation

For clusters created with **Canal**, Project Network Isolation available.
You will not be able to see or communicate with resources in any other project.

It does NOT apply to the **System** project or its **namespaces**. Resources that run within this project have access to all resources in other projects to operate correctly.

#### Pod Security Policies (PSP)

Pod Security Policies can be assigned to Projects
> But it is recommended assign the PSPs only to clusters (better management experience and easy troubleshooting)

### 4.4.4 Resource Quotas

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.4.4.pdf)

Resource quotas define the total amount of a particular resource that the project can use.

It is an aggregate of all namespaces in the project.

You set the project limit as well as a default limit for each namespace.

The total of all namespace limits should not exceed the project limit.

### 4.4.5 Resource Limits

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.4.5.pdf)

[Lab 26](https://academy.rancher.com/assets/courseware/v1/ad2926c99ec872782cda86a4695ff5f7/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-26-Set-and-Test-Resource-Quota-and-Limits-on-Projects.pdf)

CPU or memory resource quotas on a project, propagates to all of its namespaces.

Workloads deployed in one of those namespaces will require the corresponding field.

The project can define a default container resource limit for CPU and Memory. Workloads which do not set a limit of their own will inherit this default.

Any namespace that already exists will need to be adjusted manually.

Container default resource limits are an excellent way to make sure no single workload can spin out of control.

## 4.5 Working Inside of a Project

### 4.5.1 Namespace Management

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.5.1.pdf)

[Lab 27](https://academy.rancher.com/assets/courseware/v1/56816b4199f07223ba166017a5b0282f/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-27-Move-a-Namespace-Between-Projects.pdf)

You can move a namespace to a different project from the top-level cluster menu where Projects are defined.
If the destination project does not have a quota, but the origin project does, then the quota that was attached to the namespace is released.
It is not possible to move a namespace into a project that already has a resource quota configured.

### 4.5.2 Project Monitoring

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.5.2.pdf)

[Lab 28](https://academy.rancher.com/assets/courseware/v1/b430e659ebf90d2e5ce2b9b8af8b8eb0/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-28-Activating-Monitoring-For-The-Project.pdf)

Monitoring is available for installation on a project-by-project basis and adheres to the security boundaries of the project and its users.

### 4.5.3 Project Alerts

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.5.3.pdf)

Project alerts use the same notifiers but send alerts for workloads running within the project.

The notifiers are configured at the cluster level.

- Pod alerts - configure alerts for a specific Pod.
- Workload alerts - All Pods within a specific workload
- Workload selector alerts - configure alerts for workloads that match a selector
- Metric expression - Arbitrary PromQL expressions (require that advanced monitoring is active for the project)

### 4.5.4 Logging

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-4.5.4.pdf)

Logging at the project level works exactly like logging at the cluster level.