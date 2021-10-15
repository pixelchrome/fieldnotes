---
linkTitle: "NMAP"
weight: 30
---
# NMAP

Enumerate Ciphers (currently TLS 1.3 is not in the actual nmap version included)

```sh
nmap --script ssl-enum-ciphers -p 443 <IP>
```

```sh
nmap --script ssl-enum-ciphers -p 443 pixelchrome.org
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-13 09:05 CEST
Nmap scan report for pixelchrome.org (136.243.23.72)
Host is up (0.044s latency).
Other addresses for pixelchrome.org (not scanned): 2a01:4f8:211:1447::2
rDNS record for 136.243.23.72: mail.23mail.de

PORT    STATE SERVICE
443/tcp open  https
| ssl-enum-ciphers: 
|   TLSv1.2: 
|     ciphers: 
|       TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 (ecdh_x25519) - A
|       TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384 (ecdh_x25519) - A
|       TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 (dh 4096) - A
|       TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 (dh 4096) - A
|       TLS_DHE_RSA_WITH_AES_128_CBC_SHA (dh 4096) - A
|       TLS_DHE_RSA_WITH_AES_256_CBC_SHA (dh 4096) - A
|       TLS_DHE_RSA_WITH_AES_128_CBC_SHA256 (dh 4096) - A
|       TLS_DHE_RSA_WITH_AES_256_CBC_SHA256 (dh 4096) - A
|     compressors: 
|       NULL
|     cipher preference: server
|_  least strength: A
```

### Sources

* https://nmap.org/nsedoc/scripts/ssl-enum-ciphers.html
