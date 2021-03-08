---
linkTitle: "Storj"
weight: 1
---
# Host

I am using a container (described below), but the identity needs to be created via CLI. 

# Setup Process

## Firewall and Dynamic DNS

See https://documentation.storj.io/dependencies/port-forwarding regarding Firewall Port Forwarding and a Dynamic DNS Service

## Identity

This process takes a very long time! On my Mac Mini M1 around 2h!

### Get the `identity` executable

```sh
curl -L https://github.com/storj/storj/releases/latest/download/identity_darwin_amd64.zip -o identity_darwin_amd64.zip
unzip -o identity_darwin_amd64.zip
```

### Create the identity

```sh
./identity create storagenode
Generating key with a minimum a difficulty of 36...
Generated 1800 keys; best difficulty so far: 18debug2: channel 0: window 999391 sent adjust 49185
...
Generated 812034326 keys; best difficulty so far: 37
Found a key with difficulty 37!
Generated 812034400 keys; best difficulty so far: 37Unsigned identity is located in "/Users/<user>/Library/Application Support/Storj/Identity/storagenode"
Please *move* CA key to secure storage - it is only needed for identity management and isn't needed to run a storage node!
	/Users/<user>/Library/Application Support/Storj/Identity/storagenode/ca.key
```

Copy the `ca.key` to a safe place!

### Authorize the identity

```sh
./identity authorize storagenode <email:characterstring>
Identity successfully authorized using single use authorization token.
Please back-up "/Users/<user>/Library/Application Support/Storj/Identity/storagenode" to a safe location.
```

Please back-up `/Users/<user>/Library/Application Support/Storj/Identity/storagenode` to a safe location!

### Confirm the identity

```sh
grep -c BEGIN ~/Library/Application\ Support/Storj/identity/storagenode/ca.cert
2
grep -c BEGIN ~/Library/Application\ Support/Storj/identity/storagenode/identity.cert
3
```

The first command should return 2, and the second command should return 3

### Copy the identity files 

```sh
scp ~/Library/Application\ Support/Storj/identity/storagenode/* <dockeruser>@<dockerhost>:<identity-dir>
```

## Setup the docker storage node

```sh
docker run --rm -e SETUP="true" \
    --mount type=bind,source="<identity-dir>",destination=/app/identity \
    --mount type=bind,source="<config-dir>",destination=/app/config \
    --name storagenode storjlabs/storagenode:latest
```

# Run the docker storage node

```sh
docker run -d --restart unless-stopped --stop-timeout 300 \
    -p 28967:28967 \
    -p 14002:14002 \
    -e WALLET="0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
    -e EMAIL="user@example.com" \
    -e ADDRESS="domain.ddns.net:28967" \
    -e STORAGE="2TB" \
    --mount type=bind,source="<identity-dir>",destination=/app/identity \
    --mount type=bind,source="<storage-dir>",destination=/app/config \
    --name storagenode storjlabs/storagenode:latest
```

## Check the logs

```sh
docker logs -f storagenode
```

## Check the dashboard

http://dockerhost:14002

![Dashboard](/notes/images/storjnodedashboard.png)

# Shutdown the storage node

```sh
docker stop -t 300 storagenode
```