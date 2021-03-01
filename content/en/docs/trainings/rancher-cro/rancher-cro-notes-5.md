---
title: "5. Running Kubernetes Workloads"
linkTitle: "Running Kubernetes Workloads"
weight: 3
---

# 5. Running Kubernetes Workloads

## 5.1 Deploying and Managing Workloads

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.1.pdf)

### 5.1.1 Deploy Workloads

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.1.1.pdf)

#### Basic Options

##### Deployment type

- Deployment
- DaemonSet
- StatefulSet
- CronJob
- Job

##### Image

The full *path* to the image, including the external *registry*. If no registry provided, the image will be pulled from *Docker Hub*.

If no *Tag* provide, Rancher will use *latest*.

###### Caveats Around Using “latest”

When using latest, Rancher sets the `imagePullPolicy` to `Always`.

1. Kubernetes will always try to pull a copy of the image! Even if a copy of the image is present on the node. Kubernetes doesn't know if there is a more recent version. **If the image is currently unavailable, the Pod will not start.**
2. If the Pod restarts, and if Kubernetes pulls a new version. It's possible that you will be running multiple Pods with different versions of the application.
3. The latest build could be a different major or minor version of the application. That can cause your application to fail unexpectedly due to:
    - different configuration options
    - different defaults
    - any number of other things

> To avoid these issues, **always** specify a tag to run. This sets the `imagePullPolicy` to `IfNotPresent`, and the behavior of the workload becomes much more predictable.

##### Adding Ports

- Ports that are added in the deployment form automatically deploy Services of the indicated type.
- The exception to this is with resources that are deployed via `kubectl` or via direct YAML import. Even if the YAML indicates container ports, Rancher won't automatically create the services.

##### Environment Variables

- You can add environment variables directly
- You can paste multiple lines of key=value
- You can also add environment variables from another source:
    - ConfigMap
    - Secret
    - a field from the final Pod manifest
    - a resource from one of the containers in the Pod

When using the field (Pod) or the resource (container) resources, you're using what Kubernetes refers to as the Downward API.

##### Node Scheduling

###### Labels

Node scheduling allows you to define a set of rules that will choose a node according to the labels that match the rules (`nodeSelector`)

- You can require that ***all*** provided labels exist on the node
- That ***any*** of the provided labels exist on the node
- Any of the provided labels ***should*** exist on the node

In the last case, if no node exists with those labels, Kubernetes will pick an available node from any that are present.

###### Taints and Tolerations

An alternative way to configure scheduling is with Taints and Tolerations.

**Taint** a host: Kubernetes will not schedule resources to it unless your workload has a **Toleration** for that Taint.

###### Custom Scheduler

You can also set a custom scheduler and priority for the workload. Kubernetes will use that scheduler to decide where to run the workload.

##### Health Check

- If you don't configure a health check, Kubernetes will restart the container when it fails.
- If your application might fail without crashing the container, configure a health check so that Kubernetes will know when the application needs to be restarted.
- If you only define a single health check, Rancher will use it for both the liveness and the readiness check.
- If you wish to define a separate liveness check, you can do so by following the link on the right.

##### Volumes

One of the best features in the Rancher workload deployment screen is the ease with which you can define and attach volumes to your workloads.

You can add:

- ephemeral volume
- new or persistent volume claim
- bind-mount a directory from the node
- Secret as a volume
- ConfigMap as a volume
- Certificate as a volume

##### Scaling/Upgrade Policy

When upgrading Pods, you can control how Kubernetes performs the rollout.

**Rolling update**: you can control how many Pods it starts at a time, and whether it starts new pods before killing old pods or vice versa.

**Custom rollout**: you can specify `maxSurge` and `maxUnavailable` that define how many Pods start over the desired number and how many Pods can be in an unavailable state during the update process.

#### Advanced Options

These options are available if you select the link in the bottom right corner, beneath the main options.

##### Command

- Override entrypoint/command
- Set working directory
- Set EUID / EGID
- Set console and restart options

Changing the console output affects Rancher's ability to collect stdout/stderr log data from the container.

- stop timeout

If Kubernetes asks the container to stop, and if this much time passes and the container is still running, Kubernetes will kill the container without waiting for a graceful shutdown.

##### Networking

- Set hostname / domain
- Configure hosts entries
- Override DNS configuration
- Use host networking

##### Security and Host Config

- How is the image pulled
- Use privilege mode?
- Use privilege escalation?
- Run as root?
- Mount root fs read-only
- CPU and RAM Limits
- GPU reservations (NVIDIA)
- add and remove capabilities

##### Importing YAML

You can use the **Import YAML** button to load this into Rancher. Rancher will deploy the resources according to the YAML.

You can define the scope:

- Cluster
    - Creates nonexisting Namespaces
    - Namespaces not added to the Project
    - Import non-scoped resources
- Project
    - Non-namespaced resources added to a specified Namespace
    - Nonexisting namespaces created and added to current Project
- Namespace
    - Everything placed into specified namespace
    - Resources for other namespaces will cause import to fail

#### Working With Sidecars

Pods can have more than one container inside of them.

The two patterns for this are an *initContainer* that does environmental setup and runs before the *main container*, and a *standard container* that runs alongside the *primary container*, sharing the same network and storage configuration.

If your pod should have multiple containers, you'll deploy the main container first and then edit it to add a sidecar.

This sidecar inherits many of the Pod definitions from the first container's configuration.

Sidebars can have its own

- command
- health check
- volumes
- command and security
- host configuration

When a pod has sidecars, the containers in each pod are collected together when displayed in the UI. You can interact with them individually.

When you edit a workload with sidecars, the UI presents you with a selection of the containers that are available for you to edit. You can edit the primary container, or you can choose to edit or delete sidecar containers.

### 5.1.2 Upgrading Workloads

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.1.2.pdf)

You can upgrade a workload by:

- editing the YAML
- clicking the Edit button

When you do this, Kubernetes will perform an update according to the update specifications you set in the **current** workload definition.

Changing the scaling and upgrade policy or changing the number of replicas doesn't result in a redeployment of the running workload, so if you change this at the same time that you change other parameters, Rancher effectively applies the scaling and upgrade policy to the current workload and then performs any additional changes necessary.

#### References
Upgrading Workloads - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/workloads/upgrade-workloads/

### 5.1.3 Rolling Back Workloads

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.1.3.pdf)

[Lab 29](https://academy.rancher.com/assets/courseware/v1/9ab359c99ef82918f1127d879d45280d/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-29-Deploy-Upgrade-and-Roll-Back-a-Workload.pdf)

All upgrades performed via the Rancher UI are equivalent to upgrades performed with `kubectl` and `--record=true`

If you select Rollback for your workload, you'll be presented with a list of points to which you can roll back

#### References
Rolling Back Workloads -
https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/workloads/rollback-workloads/

## 5.2 Using Persistent Storage

### 5.2.1 Provisioning Storage

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.2.1.pdf)

Applications that need to retain data will need persistent storage.

- Persistent Volumes (PVs)
- Persistent Volume Claims (PVCs)
- StorageClasses

#### Static Provisioning

If you already have storage provisioned, create a persistent volume (PV) that points to it.

Creating a PV in Rancher doesn't provision the storage for you.

#### Dynamic Provisioning Using Storage Classes

Instead of waiting for someone to provision storage and make it available for your workload, you can request storage dynamically from the cluster when your workload launches.

Cluster admins configure these storage classes with the information on where to acquire storage, and when you make the request, the storage class does the provisioning for you and connects your workload to the storage.

#### References
Volumes and Storage - https://rancher.com/docs/rancher/v2.x/en/cluster-admin/volumes-and-storage/

### 5.2.2 Using Storage

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.2.2.pdf)

[Lab 30](https://academy.rancher.com/assets/courseware/v1/01ebaad4624f42442f94d96b3ad0e29d/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-30-Create-and-Use-a-Storage-Class.pdf)

Volumes are attached to workloads when they're launched.

A workload can create a new PersistentVolumeClaim (PVC) that points to an existing PV or requests a new PV to be created according to a particular storage class.

Once the workload has been created, the PV will be mounted inside the Pod at the designated mountpoint.

#### References
How Persistent Storage Works - https://rancher.com/docs/rancher/v2.x/en/cluster-admin/volumes-and-storage/how-storage-works/

## 5.3 Dynamic Data with ConfigMaps, Secrets, and Certificates

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.3.pdf)

Our applications are likely going to have depnedencies on small bits of code that we want to reuse across the pods in our environment.

Kubernetes has:

- ConfigMaps
- Secrets
- Certificates

### 5.3.1 ConfigMaps

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.3.1.pdf)

ConfigMap is simply a set of key/value pairs

With the Rancher UI

- Create a new
- Edit
- When assigned, it show which workloads are using it

- pasting in multiple lines of key=value from the clipboard
- loading key=value pairs from an external file

> ConfigMaps can only be assigned to a namespace. They cannot be assigned to a project.

#### References
- ConfigMaps in Rancher - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/configmaps/
- ConfigMap Configuration and Use - https://kubernetes.io/docs/concepts/configuration/configmap/

### 5.3.2 Secrets

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.3.2.pdf)

[Lab 31](https://academy.rancher.com/assets/courseware/v1/e1e5a738e0eced50cf12e5cec1d10a1e/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-31-Create-and-Use-a-ConfigMap-and-a-Secret-with-a-Workload.pdf)

- Secrets store arbitrary key/value pairs
- Sensitive data like passwords or API keys
- Base64-encoded
- Can be assigned to a namespace or to a project

Kubernetes does not encrypt secrets by default. Doing so requires additional configuration of the kube-apiserver component. See the [Rancher Hardening Guide](https://rancher.com/docs/rancher/v2.x/en/security/).

#### References
- Secrets in Rancher - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/secrets/
- Secret Configuration and Usage - https://kubernetes.io/docs/concepts/configuration/secret/
- Rancher Hardening Guide - https://rancher.com/docs/rancher/v2.x/en/security/

### 5.3.3 Certificates

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.3.3.pdf)

[Lab 32](https://academy.rancher.com/assets/courseware/v1/70f61036151a286298e60ee07ea83642/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-32-Import-and-Use-a-Certificate.pdf)

Kubernetes secures internal communication with TLS certificates, but you can also upload certificates and use them to secure Ingress traffic.

#### Static Certificates

- Rancher doesn't require that certificates be signed by a recognized certificate authority
- If your certificate requires a chain of certificates that lead back to a recognized CA, include those with the certificate when adding it to Rancher.

- When editing a certificate entry, you will not be shown the private key.

#### Dynamic Certificates

**Cert Manager** from **JetStack** is a controller that runs in the cluster and dynamically generates certificates on demand

Certificates can come from

- internal CA
- internal service like Hashicorp Vault
- LetsEncrypt

You can request that Cert Manager create a certificate when you create the Ingress that uses it, or you can create Certificate resources that request a certificate from a particular issuer.

Certificates created by Cert Manager are automatically renewed before they expire.

#### References
- Securing Traffic with HTTPS - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/certificates/
- Adding Ingresses to Your Project - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/load- balancers-and-ingress/ingress/
- JetStack - https://jetstack.io
- Cert Manager - https://github.com/jetstack/cert-manager
- Hashicorp Vault - https://www.vaultproject.io
- Let’s Encrypt - https://letsencrypt.org

- OpenSSL Essentials - https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs
- Creating a Self-Signed SSL Certificate - https://devcenter.heroku.com/articles/ssl-certificate-self

### 5.3.4 Registry Credentials

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.3.4.pdf)

[Lab 33](https://academy.rancher.com/assets/courseware/v1/63a9bbd84ab5be5628a2384b02c4eada/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-33-Configure-and-Use-a-Private-Registry.pdf)

A Docker Registry as a private registry that holds Docker container images.

A Kubernetes registry is the set of credentials needed to access a particular Docker Registry.

Workloads use the Kubernetes registry to access the Docker registry, pull an image from it, and deploy it.

If you deploy workloads with kubectl, you need to specify the secret with the `imagePullSecrets` key on the Pod spec.

#### References
Kubernetes Registry and Docker Registry - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/registries/

### 5.3.5 Resource Naming

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.3.5.pdf)

Kubernetes treats Secrets, Certificates, and Registry Credentials as Secrets, and therefore each of these resources must have a unique name within a namespace.

If you try to create any of these resources with a name that already exists in any other resource, Kubernetes will return an error.

## 5.4 Understanding Service Discovery and Load Balancing

### 5.4.1 Services in Rancher

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.4.1.pdf)

[Lab 34](https://academy.rancher.com/assets/courseware/v1/80139ae3f0b451b3b8fdd653b3b7d787/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-34-Use-An-Alias-To-Cross-a-Namespace-Boundary.pdf)

> Pods are ephemeral. Although they have IP addresses, there is no guarantee that a Pod will exist at that IP in the future. Pods might fail health checks and be recreated, nodes can fail, or any number of things can befall them.

A Service, which gives a stable IP and DNS name to a group of Pods.

Services are automatically created for Workloads that expose a port.

In the Workload deployment screen, you can choose what kind of service to deploy:

- ClusterIP
- NodePort
- LoadBalancer

These can also be created from the Service Discovery tab of the Workloads screen, and this page offers additional options for service discovery.

An ExternalName service can point to a specific IP address or hostname. This acts like an A record or a CNAME.

An Alias service acts like an internal CNAME to another DNS record in the cluster. This can point to a workload in the same namespace or a different one.

#### References

- Service Discovery - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/service-discovery/
- Service Resource - https://kubernetes.io/docs/concepts/services-networking/service/

### 5.4.2 Layer 4 Versus Layer 7

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.4.2.pdf)

#### Layer 4 load balancer

- receives traffic on a port and sends it to a backend on another port
- doesn't look at the traffic
- doesn't care what that traffic is
- Layer 4 load balancers are great for encrypted traffic and non-HTTP TCP traffic
- LoadBalancer Services are Layer 4 load balancers

"dumb load balancer" it doesn't make decisions based on the traffic.

#### Layer 7 load balancer

- receives traffic on a port
- analyzes it
- and directs it according to a set of rules in its configuration

Often used for HTTP traffic and route based on:

- host
- path
- headers
- cookies
- or other information in the data stream

"intelligent load balancers" because they make decisions about where to send the traffic.

Ingresses are served by the Ingress Controller, which is a Layer 7 load balancer.

#### References
- HAProxy Load Balancing FAQ - https://www.haproxy.com/blog/loadbalancing-faq/
- Service Resource - https://kubernetes.io/docs/concepts/services-networking/service/
- What is Layer 4 Load Balancing? - https://www.nginx.com/resources/glossary/layer-4-load-balancing/

### 5.4.3 LoadBalancer Service

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.4.3.pdf)

#### Cloud Providers

- Kubernetes deploys an instance of the provider's load balancer and configures it to route traffic to the cluster.

For AWS, GCE, and Azure. Other needed to be configured with the Custom Option

#### vSphere and Openstack

See documentation for [vSphere](https://rancher.com/docs/rke/latest/en/config-options/cloud-providers/vsphere/) and [Openstack](https://rancher.com/docs/rke/latest/en/config-options/cloud-providers/openstack/)

#### On-premises

[MetalLB](https://metallb.org)

#### References
- Services in Rancher - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/workloads/#services
- Cloud Provider Configuration - https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke- clusters/cloud-providers/
- vSphere Provider Configuration - https://rancher.com/docs/rke/latest/en/config-options/cloud-providers/vsphere/

### 5.4.4 Ingress

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.4.4.pdf)

[Lab 35](https://academy.rancher.com/assets/courseware/v1/f8fdc28b8788ac96b932a0f274aab8b2/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-35-Deploy-an-Ingress.pdf)

The default Ingress Controller is the Nginx ingress controller. It can be disabled (and others can be used like Traefik or HAProxy).

#### xip.io

Rancher can generate an **xip.io** hostname, which is useful for development or demonstration purposes.

Worker nodes running in an environment like AWS don't know their external address by default, so if you plan to use the xip.io feature of the Ingress resources in Rancher, launch your clusters with a configuration that tells Kubernetes the internal and external addresses of the nodes.
This configuration appears as a label on the node of `rke.cattle.io/external-ip` and `rke.cattle.io/internal-ip`. The xip.io configuration will take the external-ip address if present, and the node address if it is not.

#### Specify hostname and default backend

You can also specify a hostname directly, or if the ingress controller supports it, you can designate an Ingress to be the default backend for the ingress controller.
Traffic that arrives on a host and doesn't match any destination will go to the default backend. (Usually this returns a 404 page, but with a custom backend you can present users with a different experience.)

#### Use a service or send traffic to workload

When creating an ingress, you have the option to *use a Service entry* or to *send traffic directly to a Workload*.
The latter exists to route traffic to workloads that don't expose ports via a Service entry. Rancher labels the workload and creates a service that uses the label as a selector. The ingress sends traffic to that service.

> Future versions of Rancher will only use Services, so we recommend that you expose your workloads with Service entries and use those with the Ingress configuration.

#### TLS Certificates

If you've added certificates (static or dynamic), they will be made available by the system for you to attach to Ingresses.
If you've installed Cert Manager, you can annotate your Ingress to request a certificate from the issuer when you deploy the Ingress.

> This is not integrated into the UI and requires that you edit the YAML directly after creating the Ingress.

#### DNS Considerations

You can put every node in DNS, **but round-robin DNS will fail if one node goes down**.

> The answer is that you still need an external load balancer of some kind.

(The drawback to this is that you won't have information about the client)



#### Example

```sh
kubectl get ingress -n namespace54
NAME   HOSTS                                    ADDRESS                                                                      PORTS   AGE
demo   demo.namespace54.192.168.11.111.xip.io   192.168.11.111,192.168.11.112,192.168.11.113,192.168.11.115,192.168.11.116   80      2m44s
```

```sh
kubectl get ingress -n namespace54 demo -o yaml
```
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    field.cattle.io/creatorId: user-9mqv5
    field.cattle.io/ingressState: '{"ZGVtby9uYW1lc3BhY2U1NC94aXAuaW8vLy84MDgw":""}'
    field.cattle.io/publicEndpoints: '[{"addresses":["192.168.11.111"],"port":80,"protocol":"HTTP","serviceName":"namespace54:demo","ingressName":"namespace54:demo","hostname":"demo.namespace54.192.168.11.111.xip.io","path":"/","allNodes":true}]'
  creationTimestamp: "2021-02-26T08:11:16Z"
  generation: 2
  labels:
    cattle.io/creator: norman
  name: demo
  namespace: namespace54
  resourceVersion: "3446698"
  selfLink: /apis/extensions/v1beta1/namespaces/namespace54/ingresses/demo
  uid: e6074d98-1079-43ce-a50d-9e9fbad378d5
spec:
  rules:
  - host: demo.namespace54.192.168.11.111.xip.io
    http:
      paths:
      - backend:
          serviceName: demo
          servicePort: 8080
        path: /
status:
  loadBalancer:
    ingress:
    - ip: 192.168.11.111
    - ip: 192.168.11.112
    - ip: 192.168.11.113
    - ip: 192.168.11.115
    - ip: 192.168.11.116
```

#### References

- Configuring Ingresses - https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/load-balancers-and-ingress/
- Traefik - https://containo.us/traefik/
- HAProxy - https://haproxy.org
- Nginx Ingress Controller - https://kubernetes.github.io/ingress-nginx/deploy/
- Ingress (Kubernetes Docs) - https://kubernetes.io/docs/concepts/services-networking/ingress/
- Wildcard DNS for Everyone - http://xip.io/

## 5.5 Discovering the Rancher Application Catalog

### 5.5.1 How It Works

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.5.1.pdf)

The Application Catalog integrates *Helm* and *Rancher Apps*.

When a user requests to launch an app, Rancher launches an ephemeral instance of a Helm service account with the permissions of the requesting user (Security)

#### References
- Catalog, Helm Charts, and Apps - https://rancher.com/docs/rancher/v2.x/en/catalog/
- Helm Documentation - https://helm.sh/

### 5.5.2 Catalog Scope

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.5.2.pdf)

Catalogs are scoped at

- Global levels (available to all clusters and all projects)
- Cluster levels (available to all Projects)
- Project levels (only visible to that Project)

#### References

- Catalog Scope - https://rancher.com/docs/rancher/v2.x/en/catalog/#catalog-scopes

### 5.5.3 Included Global Catalogs

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.5.3.pdf)

- Library - is a curated list of apps
- Helm Stable
- Helm Incubator

#### References

- Built-in Global Catalogs - https://rancher.com/docs/rancher/v2.x/en/catalog/#built-in-global-catalogs
- Enabling and Disabling Global Catalogs - https://rancher.com/docs/rancher/v2.x/en/catalog/built-in/

### 5.5.4 Adding Custom Catalogs

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.5.4.pdf)

[Lab 36](https://academy.rancher.com/assets/courseware/v1/4def04bd785ee43bf4dc2f42ffcedd79/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-36-Add-Custom-Catalogs.pdf)

#### Catalogs can either be (available over HTTP or HTTPS)

- a Git repository 
- a Helm repository

#### private catalog repos

- trough username and password (for HTTP repos)
- OAuth tokens (for Git repos)

#### References

- Adding Catalogs - https://rancher.com/docs/rancher/v2.x/en/catalog/adding-catalogs/

### 5.5.5 Using Catalog Apps

[Handout](https://academy.rancher.com/asset-v1:RANCHER+K101+2019+type@asset+block@Handout-5.5.5.pdf)

[Lab 37](https://academy.rancher.com/assets/courseware/v1/e8b8320a92ac989a64a0065c12efa028/asset-v1:RANCHER+K101+2019+type@asset+block/Lab-37-Use-the-App-Catalog.pdf)

#### Deploying

- Helm app
    - you can view the instructions
    - manually enter the key/value pairs to configure the app
- Rancher app
    - a form contains sane defaults for the application and allows you to make adjustments visually

#### Cloning

- The same application can run multiple times in any project.
- Each version will run it its own namespace.
- Rancher names the namespace dynamically by appending five characters
- Cloning it will populate the form or Helm values with the values from the app you're cloning.

#### Upgrading

- When newer versions of application are available Rancher detects this and changes the icon
- You're presented with the values you set when you first deployed the app
- You can change these values, add new ones
- "Delete and recreate resources if needed" for Apps that will not allow to changer certain fields (This is not without risk)

#### Rolling Back

- Any application can be rolled back to a previous version

#### Deleting

When you delete a catalog app, Rancher does not automatically delete the namespace into which the app was installed.

#### References

- Launching Catalog Apps - https://rancher.com/docs/rancher/v2.x/en/catalog/launching-apps/
- Managing Catalog Apps - https://rancher.com/docs/rancher/v2.x/en/catalog/managing-apps/



  Final Assessment
Final Exam  This content is graded
  5.6 - Conclusion and Next Steps
Course Tools
 Bookmarks
 Updates
Important Course Dates
Today is Feb 25, 2021 13:47 CET
