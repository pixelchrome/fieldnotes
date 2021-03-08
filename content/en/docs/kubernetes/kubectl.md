---
linkTitle: "kubectl"
weight: 1
---

# Install `kubectl`

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