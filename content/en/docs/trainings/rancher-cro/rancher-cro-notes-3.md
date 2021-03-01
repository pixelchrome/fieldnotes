---
title: "3. Deploying Kubernetes with Rancher"
linkTitle: "Deploying Kubernetes with Rancher"
weight: 3
---

# 3. Deploying Kubernetes with Rancher

## 3.1 Designing and provisioning clusters

### 3.1.1 Where will mycluster live?

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.1.1.pdf)

#### Cluster Types

##### Hosted Provider

- GKE / EKS / AKS / Others
- Managed control plane
- Rich Rancher experience on top

##### Infrastructure Provider

- Rancher deploys systems
- Rancher deploys Kubernetes
- Full lifecycle management

##### For all other provisioners use `Custom``

- Hosts only need Docker
- Custom command is unique per cluster
- Can be added to provisioners

##### Existing clusters

- can be imported
- Uses `kubectl`to install agent
- Works with any certified K8s distro

### 3.1.2 Limitations with certain cluster types

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.1.2.pdf)

Rancher provides workload management on all cluster types.

#### Infrastructure and Custom clusters

- both run RKE
- all features are available within Rancher

#### Hosted provider clusters

- include lifecycle management
- no backups or restores (Rancher is unable to access to the data plane or control plane)

#### Imported clusters

- no lifecycle management
- no backups or restores

When working with a non-RKE cluster, you will need to use the provider's tools or other tools to provide business continuity for the clusters.

### 3.1.3 Node Resource Requirements

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.1.3.pdf)

[K8s Best Practices](https://kubernetes.io/docs/setup/best-practices/cluster-large/)

#### Recommendations

- Different Node Pools for
    - control plane
    - data plane
    - worker nodes
- Deploy workloads with CPU and memory reservations and limits

Make sure that you have enough CPU and RAM!

### 3.1.4 Networking and Port Requirements

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.1.4.pdf)

[Rancher Ports](https://rancher.com/docs/rke/latest/en/os/#ports)

#### Recommendations

- Be mindful of locking down the network
- Check Logfiles
- Test that nodes in each role are able to communicate with nodes in other roles
- Verify that cross-host networking
    - by testing that Pods on one host are able to communicate with Pods on other hosts

### 3.1.5 Cluster Roles

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.1.5.pdf)

#### Cluster Owners

- Cluster Owners have full control over everything in the cluster
- Including user access.

#### Cluster Members

- Can view most cluster-level resources 
- Create new projects

#### Custom Controls

- Pick the right roles for the user

## 3.2 Deploying a Kubernetes Cluster

### 3.2.1 RKE Configuration Options

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.2.1.pdf)

[Documentation](https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/options/)

![Add Cluster](img/add_cluster.png)

![Add Cluster Custom](img/add_cluster_custom.png)

## 3.2.2 RKE Templates

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.2.2.pdf)

[Lab 12](https://studio.academy.rancher.com/assets/courseware/v1/946b9282995644a8a1742e7c05ef7e24/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-12-Create-an-RKE-Template.pdf)

![RKE Template](img/rke_template.png)

### 3.2.3 Node Templates and Cloud Credentials

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.2.3.pdf)

[Lab 13](https://studio.academy.rancher.com/assets/courseware/v1/871c904f1c83ec795703e2a89f38f7d3/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-13-Create-a-Node-Template.pdf)

### 3.2.4 Cloud Providers

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.2.4.pdf)

[See here](https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/cloud-providers/) the details on how to setup a cloud provider

Infrastructure and Custom clusters allow you to set a cloud provider. This makes changes to how the cluster operates. For example, if you choose the Amazon cloud provider, deployment of a LoadBalancer Service into the cluster will create an Amazon ELB.

### 3.2.5 Deploying a cluster

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.2.5.pdf)

[Lab 14](https://academy.rancher.com/assets/courseware/v1/42a40989c4ebdd354c4f17f3820bdd06/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-14-Deploy-an-RKE-Cluster.pdf)

- Hosted Provider
    - Providing your authentication credentials needed
- Infrastructure Provider
    - Clusters deployed in an infrastructure provider utilize node templates and can also use RKE templates.
- Custom Clusters
    - Rancher builds an RKE cluster
    - Requirement is a supported version of Docker
    - **Windows Clusters**
        - *Linux control* plane and *one Linux worker* (act as the ingress controller)
        - \+ the required *Windows Worker Nodes*
        - Flannel CNI only
- Imported Clusters
    - Manage an existing cluster with Rancher
    - `kubectl apply` to pull information from the Rancher server and install the agents

## 3.3 Performance Basic Troubleshooting

### 3.3.1 What Could Possibly Go Wrong?

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.3.1.pdf)

Troubleshooting a failed system can be frustrating, but there are some things to remember.
1. Every problem has a solution.
2. A second set of eyes.
3. “What changed?” Review those changes and see if rolling them back resolves the issue.
4. Change one thing at a time and then test.
5. No problem goes away on its own. If the problem vanishes as mysteriously as it arrived, know that it can return just as mysteriously.
6. Take a break.

### 3.3.2 Rancher's API Server

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.3.2.pdf)

[Lab 15](https://academy.rancher.com/assets/courseware/v1/e0e663a84b6f261dd553d18204173f94/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-15-Check-API-Server-Logs.pdf)

#### Check the API Server is running

```sh
kubectl get pods -n cattle-system -l app=rancher -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP           NODE                 NOMINATED NODE   READINESS GATES
rancher-6988647785-4whp6   1/1     Running   0          3d17h   10.42.0.15   rancher.47.dmdy.de   <none>           <none>
rancher-6988647785-dzsh2   1/1     Running   0          3d17h   10.42.0.16   rancher.47.dmdy.de   <none>           <none>
rancher-6988647785-wwg5s   1/1     Running   0          3d17h   10.42.0.14   rancher.47.dmdy.de   <none>           <none>
```

#### Check the logs

```sh
kubectl logs -n cattle-system -l app=rancher


2021/02/12 11:28:31 [INFO] Shutting down ClusterRoleController controller
2021/02/12 11:28:31 [INFO] Shutting down RoleBindingController controller
2021/02/12 11:28:31 [INFO] Shutting down ClusterRoleBindingController controller
...

2021/02/12 11:32:25 [INFO] error in remotedialer server [400]: websocket: close 1006 (abnormal closure): unexpected EOF
2021/02/12 11:43:11 [ERROR] ClusterTemplateController cattle-global-data/ct-kmtmf [cluster-template-rbac-controller] failed with : member {    read-only} doesn't have any name fields set
2021/02/12 11:43:12 [ERROR] ClusterTemplateRevisionController cattle-global-data/ctr-7ln4d [cluster-template-rev-rbac-controller] failed with : member {    read-only} doesn't have any name fields set
...
2021/02/12 11:32:25 [INFO] error in remotedialer server [400]: websocket: close 1006 (abnormal closure): unexpected EOF
```

### 3.3.3 Docker / Container Runtime

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.3.3.pdf)


```sh
ssh ubuntu@192.168.11.111 \
sudo systemctl status docker.service | head -n 14
```

```sh
ssh ubuntu@192.168.11.111 \
sudo journalctl -u docker.service | less
```

### 3.3.4 Node Conditions

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.3.4.pdf)

**kubelet** maintains a set of sensors about the state of every node.

- network availability
- disk pressure
- memory pressure
- PID pressure
- general "ready"

#### Show the conditions - with `kubectl describe`

You will see a **TRUE** for *NetworkUnavailable*, and the **Pressure* Conditions.

```sh
kubectl describe node rancher.47.dmdy.de | less

...

Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 08 Feb 2021 18:15:43 +0100   Mon, 08 Feb 2021 18:15:43 +0100   FlannelIsUp                  Flannel is running on this node
  MemoryPressure       False   Fri, 12 Feb 2021 14:30:32 +0100   Mon, 08 Feb 2021 18:14:59 +0100   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Fri, 12 Feb 2021 14:30:32 +0100   Mon, 08 Feb 2021 18:14:59 +0100   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Fri, 12 Feb 2021 14:30:32 +0100   Mon, 08 Feb 2021 18:14:59 +0100   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Fri, 12 Feb 2021 14:30:32 +0100   Mon, 08 Feb 2021 18:15:20 +0100   KubeletReady                 kubelet is posting ready status

...
```

#### List the node conditions

```sh
kubectl get nodes -o go-template='{{range .items}}{{$node := .}}{{range .status.conditions}}{{$node.metadata.name}}{{": "}}{{.type}}{{":"}}{{.status}}{{"\n"}}{{end}}{{end}}'

rancher.47.dmdy.de: NetworkUnavailable:False
rancher.47.dmdy.de: MemoryPressure:False
rancher.47.dmdy.de: DiskPressure:False
rancher.47.dmdy.de: PIDPressure:False
rancher.47.dmdy.de: Ready:True
```

#### List the active node conditions (no output is good)

```sh
kubectl get nodes -o go-template='{{range .items}}{{$node := .}}{{range .status.conditions}}{{if ne .type "Ready"}}{{if eq .status "True"}}{{$node.metadata.name}}{{": "}}{{.type}}{{":"}}{{.status}}{{"\n"}}{{end}}{{else}}{{if ne .status "True"}}{{$node.metadata.name}}{{": "}}{{.type}}{{": "}}{{.status}}{{"\n"}}{{end}}{{end}}{{end}}{{end}}'
```

### 3.3.5 Kubelet / Worker Node

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.3.5.pdf)

[Lab 16](https://academy.rancher.com/assets/courseware/v1/e62045b02c1fb7ab76cb9f46fcdf3615/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-16-Troubleshooting-Worker-Nodes.pdf)

The kubelet is responsible for invoking containers on the nodes

#### Check if `kubelet` and `kube-proxy` are running

- If the `kubelet` isn't running, API changes will NOT be reflected in the worker
- If the `kube-proxy` isn't running, the Pods might have network issues

```sh
ssh ubuntu@rancher.47.dmdy.de docker ps -a -f name=kubelet
ssh ubuntu@rancher.47.dmdy.de docker ps -a -f name=kube-proxy
```

#### Get the logs

```sh
ssh ubuntu@rancher.47.dmdy.de docker logs kubelet
ssh ubuntu@rancher.47.dmdy.de docker logs kube-proxy
```

## 3.4 Performing Advanced Troubleshooting

### 3.4.1 etcd

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.4.1.pdf)

[Lab 17](https://academy.rancher.com/assets/courseware/v1/2fa51db4be6309a2748ed8140649b563/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-17-Troubleshooting-Etcd-Nodes.pdf)

*etcd* stores the state for Kubernetes and the Rancher application. Look for

- Is etcd constantly electing new leaders? This might indicate that there's something causing leaders to fail.
- Are all the etcd nodes members of the same cluster? If there's been a node partition, they may be trying to connect to each other but are finding that their cluster IDs are different
- Are there any active alarms in etcd that might prevent the cluster from receiving write data?

#### Check *ectd* logs

```sh
ssh ubuntu@rancher.47.dmdy.de docker logs etcd
```

#### Check the *etcd* alarms

```sh
ssh ubuntu@rancher.47.dmdy.de docker exec etcd etcdctl alarm list
```

#### *etcd* needs also a sufficient disk performance!

### 3.4.2 Control Plane

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.4.2.pdf)

[Lab 18](https://academy.rancher.com/assets/courseware/v1/be256b67d12a93389ea4eb4d20ae4817/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-18-Troubleshooting-Control-Plane-Issues.pdf)

#### Which is the Controller Manager Leader (see `holderIdentity`)

```sh
kubectl -n kube-system get endpoints kube-controller-manager -o jsonpath='{.metadata.annotations.control-plane\.alpha\.kubernetes\.io/leader}'
{"holderIdentity":"rancher_a3fb3027-9637-4c56-a81b-b54b43e141b8","leaseDurationSeconds":15,"acquireTime":"2021-02-12T01:28:24Z","renewTime":"2021-02-12T14:17:36Z","leaderTransitions":14}%  
```

##### Check the logs of the Controller Manager

```sh
ssh ubuntu@rancher.47.dmdy.de docker logs kube-controller-manager
```

#### Which one is the Scheduler Leader?

```sh
kubectl -n kube-system get endpoints kube-scheduler -o jsonpath='{.metadata.annotations.control-plane\.alpha\.kubernetes\.io/leader}'
```

##### Check the logs of the Scheduler

```sh
ssh ubuntu@rancher.47.dmdy.de docker logs kube-scheduler
```

### 3.4.3 nginx-proxy

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.4.3.pdf)

#### Is the *nginx-proxy* running? 

```sh
ssh ubuntu@rancher.47.dmdy.de docker ps -a -f name=nginx-proxy
```

#### Check the config

Are all servers under `upstream kube_apiserver` --> `server <IP>:6443;`

```sh
ssh ubuntu@rancher.47.dmdy.de docker exec nginx-proxy cat /etc/nginx/nginx.conf
```

#### Check the logs

```sh
ssh ubuntu@rancher.47.dmdy.de docker logs nginx-proxy
```

### 3.4.4 Container Network / CNI

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-3.4.4.pdf)

[Lab 19](https://academy.rancher.com/assets/courseware/v1/5503818b9b8e5c3edc4290c2ceaf0fa5/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-19-Troubleshooting-the-Network-Overlay.pdf)

When troubleshooting network or CNI issues, it helps to first validate that the transport layer between all hosts is working correctly. If any firewalls or proxies are blocking those connections, the CNI will fail.

The Rancher documentation has [instructions that show how to deploy a DaemonSet](https://rancher.com/docs/rancher/v2.x/en/troubleshooting/networking/) on all nodes in the cluster and then use those Pods to perform a ping test across the network fabric.

This shows also how to use the [swiss-army-knife](https://github.com/leodotcloud/swiss-army-knife).