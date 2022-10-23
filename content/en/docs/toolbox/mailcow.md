
---
linkTitle: "Mailcow"
weight: 30
---

# Mailcow

## Migration

### Change hostname

```sh
docker-compose down
# Hostnamen in mailcow.conf ändern
docker-compose up -d
```

#### Link -> https://community.mailcow.email/d/149-mailcow-hostname-andern

### Force Renewal of TLS certs

```sh
cd /opt/mailcow-dockerized
touch data/assets/ssl/force_renew
docker-compose restart acme-mailcow
# Now check the logs for a renewal
docker-compose logs --tail=200 -f acme-mailcow
```

#### Link -> https://mailcow.github.io/mailcow-dockerized-docs/firststeps-ssl/#additional-domain-names


