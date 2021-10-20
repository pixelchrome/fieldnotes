---
linkTitle: "netcat"
weight: 30
---
# netcat

The 'new' version is NMAP NCAT

## open temporarly a network port

(to test a firewall configuration)

Open a TCP port with `netcat -l <port>` on the server. On the client you can write a message with `netcat <IP> <port>` - enter a message and hit ENTER. 

### Example

On the Server

```sh
netcat -l 35000
```

On the Client

```
netcat <Server-IP> 35000
<enter here a message and hit ENTER>
```

You should see the message on the server


### Sources

* https://www.digitalocean.com/community/tutorials/how-to-use-netcat-to-establish-and-test-tcp-and-udp-connections
