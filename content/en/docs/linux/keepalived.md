---
title: "keepalived"
linkTitle: "keepalived"
weight: 180
---

# Install keepalived

```sh
apt-get install keepalived
```

# Configuration

In this example there are two servers (ha1 & ha2) and two floating IP addresses (192.168.11.111 & 192.168.11.112)

## Configuration Server 1 (ha1)

`/etc/keepalived/keepalived.conf`

```sh
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 255
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass thisismysupersecretpassword
    }
    virtual_ipaddress {
        192.168.11.111
    }
}

vrrp_instance VI_2 {
    state BACKUP
    interface eth0
    virtual_router_id 52
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass thisismysupersecretpassword
    }
    virtual_ipaddress {
        192.168.11.112
    }
}
```

## Configuration Server 2 (ha2)

`/etc/keepalived/keepalived.conf`

```sh
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass thisismysupersecretpassword
    }
    virtual_ipaddress {
        192.168.11.111
    }
}

vrrp_instance VI_2 {
    state MASTER
    interface eth0
    virtual_router_id 52
    priority 255
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass thisismysupersecretpassword
    }
    virtual_ipaddress {
        192.168.11.112
    }
}
```

# Enable and start keepalived

systemctl enable keepalived
systemctl start keepalived

# Links

* https://www.vultr.com/docs/high-availability-using-private-networking-on-ubuntu-16-04-with-keepalived
* http://woshub.com/keepalived-high-availability-with-ip-failover/#h2_1
* https://www.linuxtechi.com/setup-highly-available-nginx-keepalived-linux/
