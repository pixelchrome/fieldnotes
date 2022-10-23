---
linkTitle: "Wireguard"
weight: 200
---
# Wireguard

## Portforwarding via VPS Wireguard Server

(this is from the 'anleitung_+_mango_setup.pdf')

In this example TCP Port 44158

### 1. Install VPS

* Install Debian 11
* Install `wireguard`

```sh
apt get update
apt get upgrade
apt install iptables
apt install wireguard
```

### 2. Setup Wireguard

```sh
cd /etc/wireguard
wg genkey | tee privatekey | wg pubkey > publickey
cat privatekey
cat publickey
wg genkey | tee client-privatekey | wg pubkey > client-publickey
cat client-privatekey
cat client-publickey
```

### 3. create `wg.conf`

```
[Interface]
ListenPort = 51820
PrivateKey = <privatekey>
Address = 10.0.1.1/2
MTU = 1420
PostUp = iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1240
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostUp = iptables -A FORWARD -i eth0 -o wg0 -p tcp --syn --dport 44158 -m conntrack --ctstate NEW -j ACCEPT
PostUp = iptables -A FORWARD -i eth0 -o wg0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
PostUp = iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 44158 -j DNAT --to-destination 10.0.1.2
PostDown = iptables -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1240
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i eth0 -o wg0 -p tcp --syn --dport 44158 -m conntrack --ctstate NEW -j ACCEPT PostDown = iptables -D FORWARD -i eth0 -o wg0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
PostDown = iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 44158 -j DNAT --to-destination 10.0.1.2
[Peer]
PublicKey = <client-publickey>
AllowedIPs = 10.0.1.2/32
Endpoint = 0.0.0.0:51820
```

### 4. Enable Port Forwarding

```sh
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sysctl -p
```

### 5. Start the Wireguard Server

```sh
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
systemctl status wg-quick@wg0
```

### 6. Confgigure the client

- Interface
    - IP Address: `10.0.1.2/32`
    - Private Key: <the `client-privatekey` from step 2.>
    - Listen Port: `51820`
    - DNS:
    - MTU: `1420`
- Peer
    - Public Key: <the `publickey` from step 2.>
    - Endpoint Host: <the IP of your VPS:51820 -> e.g. `w.x.y.z:51820`>
    - Allowed IPs: `0.0.0.0/0,::/0`
    - Keep Alive: `25``
    - PresharedKey:

### Configuring a linux client

```sh
cd /etc/wireguard
wg genkey | tee <hostname>.privatekey | wg pubkey > <hostname>.publickey
```

create wg0.conf

```conf
[Interface]
Address = 10.0.1.4/32 # <- private VPN Addess local
ListenPort = 47281
PrivateKey = +NQzCBoAgAIUqBsgBXsziNbWergGfi4iWsH66bI4sWo=

[Peer]
PublicKey = tAlJ2YP56PmYqfsnPdCsA85QSusDmiNsoXA20U+FjDc=
AllowedIPs = 10.0.1.1/32 # <- private VPN Addess local
Endpoint = 49.12.193.94:51820
```


### 7. Check open Port

with https://www.yougetsignal.com/tools/open-ports/

### Troubleshooting

#### Get logs on the server

```sh
modprobe wireguard 
echo module wireguard +p > /sys/kernel/debug/dynamic_debug/control
dmesg -wH
```

