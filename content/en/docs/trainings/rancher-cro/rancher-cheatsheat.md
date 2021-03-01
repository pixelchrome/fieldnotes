---
title: "Cheatsheet"
linkTitle: "Cheatsheet"
weight: 6
---

# Kubernetes

| Command | Info |
|---------|------|
| `export KUBECONFIG=$(pwd)/kube_config.yml` | Set the enviroment variable for `kubectl` | 

## Ingress

| Command | Info |
|---------|------|
| `kubectl get ingress -n <namespace>` | Get the Ingress |
| `kubectl get ingress -n <namespace> <name> -o yaml` | Get the status field with the IP address |


# Rancher

## Rancher CLI

| Command | Info |
|---------|------|
| `rancher login https://rancher.<domain>/v3 --token token-9dvw4:zmz86xqtw8njlszvzdprgq6x4zffzcllrxb7mgm42xpmn8jkvd9j7z` | Authenticate |
| `rancher context switch` | Switch the context (Project, Cluster) - This shows also the available contexts |
| `rancher nodes` | Show the nodes |
| `rancher kubectl <subcommand>` | Use `kubectl` via the Rancher ProAPIxy |

## Rancher Troubleshooting

### Rancher API Server

| Command | Info |
|---------|------|
| `kubectl get pods -n cattle-system -l app=rancher -o wide` | API Server running? |
| `kubectl logs -n cattle-system -l app=rancher`| Get the logs of the API Server |

### Container Runtime

| Command | Info |
|---------|------|
| `ssh ubuntu@192.168.11.111 \` <br> `sudo systemctl status docker.service \| head -n 14` | Check the docker service |
| `ssh ubuntu@192.168.11.111 \` <br> `sudo journalctl -u docker.service \| less`| Check the logs of the docker service |

### Node Conditions

 Command | Info |
|---------|------|
| `kubectl describe node rancher.47.dmdy.de` | Show the conditions - with `kubectl describe` |
| `kubectl get nodes -o go-template='{{range .items}}{{$node := .}}{{range .status.conditions}}{{$node.metadata.name}}{{": "}}{{.type}}{{":"}}{{.status}}{{"\n"}}{{end}}{{end}}'` | List the node conditions | 
| `kubectl get nodes -o go-template='{{range .items}}{{$node := .}}{{range .status.conditions}}{{if ne .type "Ready"}}{{if eq .status "True"}}{{$node.metadata.name}}{{": "}}{{.type}}{{":"}}{{.status}}{{"\n"}}{{end}}{{else}}{{if ne .status "True"}}{{$node.metadata.name}}{{": "}}{{.type}}{{": "}}{{.status}}{{"\n"}}{{end}}{{end}}{{end}}{{end}}'` | List the active node conditions (no output is good) |

### Worker Nodes and *kubelet*

| Command | Info |
|---------|------|
| `ssh ubuntu@rancher.47.dmdy.de docker ps -a -f name=kubelet` |  check *kubelet* |
| `ssh ubuntu@rancher.47.dmdy.de docker ps -a -f name=kube-proxy` | check *kube-proxy* |
| `ssh ubuntu@rancher.47.dmdy.de docker logs kubelet` | logs *kubelet* |
| `ssh ubuntu@rancher.47.dmdy.de docker logs kube-proxy` | logs *kube-proxy*|

### Control Plane

| Command | Info |
|---------|------|
| `kubectl -n kube-system get endpoints kube-controller-manager -o jsonpath='{.metadata.annotations.control-plane\.alpha\.kubernetes\.io/leader}'` |  check who is the *controller leader* |
| `ssh ubuntu@rancher.47.dmdy.de docker logs kube-controller-manager` | check the logs  *controller leader* |
| `kubectl -n kube-system get endpoints kube-scheduler -o jsonpath='{.metadata.annotations.control-plane\.alpha\.kubernetes\.io/leader}'` | check who is the *scheduler leader* |
| `ssh ubuntu@rancher.47.dmdy.de docker logs kube-scheduler` | checke the logs *scheduler leader*|

### nginx-proxy

| Command | Info |
|---------|------|
| `ssh ubuntu@rancher.47.dmdy.de docker ps -a -f name=nginx-proxy` |  Is nginx running? |
| `ssh ubuntu@rancher.47.dmdy.de docker exec nginx-proxy cat /etc/nginx/nginx.conf` | Are all servers under `upstream kube_apiserver` --> `server <IP>:6443;` |
| `ssh ubuntu@rancher.47.dmdy.de docker logs nginx-proxy` | check the logs |
