---
linkTitle: "NGINX"
weight: 30
---
# NGINX Configuration

# ACHTUNG - ZERTIFIKATE VON STARTSSL WURDEN FÜR ALLE REVOKED - STARTSSL WURDE AM 1. JANUAR 2018 GESCHLOSSEN!

## SSL
```
[admin@23it /usr/local/etc/nginx/ssl] sudo openssl req -new -newkey rsa:2048 -nodes -keyout 23it.key -out 23it.csr
Generating a 2048 bit RSA private key
............................................................+++
..................................+++
writing new private key to '23it.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:DE
State or Province Name (full name) [Some-State]:Bavaria
Locality Name (eg, city) []:Moehrendorf
Organization Name (eg, company) [Internet Widgits Pty Ltd]:23it
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:23it.de
Email Address []:admin@23it.de

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
[admin@23it /usr/local/etc/nginx/ssl] ls -l
total 1
-rw-r--r--  1 root  wheel  1021 Dec 27 14:03 23it.csr
-rw-r--r--  1 root  wheel  1704 Dec 27 14:03 23it.key
```

```
fetch https://www.startssl.com/certs/class1/sha2/pem/sub.class1.server.sha2.ca.pem
cat 23it.crt sub.class1.server.sha2.ca.pem > 23it.pem
```

Bzw das neue

Besser

```
openssl req -new -nodes -sha256 -out dataintense.com.csr -key dataintense.com.key
```

```
openssl genrsa -rand /var/log/messages 4096 -out 23mail.key
```

### Zertifikat erneuern

#### Alte Infos sichern

```
sudo cp pixelchrome.csr pixelchrome.csr.pre_22042016
sudo cp pixelchrome.crt pixelchrome.crt.pre_22042016
sudo cp pixelchrome.pem pixelchrome.pem.pre_22042016
sudo cp pixelchrome.key pixelchrome.key.pre_22042016
```

#### Neuen CSR erstellen

```
sudo openssl req -new -nodes -sha256 -out pixelchrome.csr -key pixelchrome.key
```

#### CSR bei StartSSL hochladen

#### PEM herunterladen

#### CA-Chain

* Von https://startssl.com/root das 'Class 1 DV SSL certificate' herunterladen (StartCom Class 1 DV Server CA(pem)(SHA-2), `sca.server1.crt`).
* Anmerkung: `pixelchrome.org.pem` ist die Originaldatei von StartSSL
* `sudo sh -c 'cat pixelchrome.org.pem sca.server1.crt > pixelchrome.pem'`

#### NGINX neu starten



### Alt, mit SHA1 signiert
```
fetch http://www.startssl.com/certs/sub.class1.server.ca.pem
```

```
cat 23it.crt sub.class1.server.ca.pem > 23it.pem
```

```
[admin@23it /usr/local/etc/nginx/ssl] ls -l
total 23
-rw-r--r--  1 root  wheel  2236 Dec 27 14:13 23it.crt
-rw-r--r--  1 root  wheel  1021 Dec 27 14:03 23it.csr
-rw-r--r--  1 root  wheel  1704 Dec 27 14:03 23it.key
-rw-r--r--  1 root  wheel  4448 Dec 27 14:18 23it.pem
-rw-r--r--  1 root  wheel  2212 Apr 18  2010 sub.class1.server.ca.pem
```

### Hardening EDH and EDCH

```
root@23it:/usr/local/etc/nginx/ssl # openssl dhparam -out dh4096.pem -outform PEM -2 4096
Generating DH parameters, 4096 bit long safe prime, generator 2
This is going to take a long time
..........................
...........................................................++*++*
```

Add to nginx.conf
```
ssl_dhparam /usr/local/etc/nginx/ssl/dh4096.pem;
```

# Sources

* https://t37.net/a-poodle-proof-bulletproof-nginx-ssl-configuration.html

# PHP

Add to nginx.conf

```

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
            root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
            include        fastcgi_params;
        }
```


### Sources

* https://rtcamp.com/tutorials/mail/server/postfix-dovecot-ubuntu/#change-master-config-file
* http://www.cyberciti.biz/faq/freebsd-nginx-namebased-virtual-hosting-configuration/
* https://www.digicert.com/csr-creation-nginx.htm
* http://www.westphahl.net/blog/2012/01/03/setting-up-https-with-nginx-and-startssl/
* https://pyd.io/freebsd-nginx-php-fpm/
* https://t37.net/a-poodle-proof-bulletproof-nginx-ssl-configuration.html
