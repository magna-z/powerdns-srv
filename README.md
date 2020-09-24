powerdns-srv
---

Bash script for register/deregister service in PowerDNS as SRV over [HTTP API](https://doc.powerdns.com/authoritative/http-api/index.html).

### Requirements
- Bash
- cURL

## Installation
```bash
export BIN_PATH="/opt/bin"
mkdir --parents "$BIN_PATH"
curl --silent --show-error --location --output "$BIN_PATH/pdns-srv" "https://raw.githubusercontent.com/magna-z/powerdns-srv/master/pdns-srv.sh"
chmod +x "$BIN_PATH/pdns-srv"
```

## Usage
### Register service as SRV record in PowerDNS:
```
PDNS_API_URL=<powerdns-api-url> PDNS_API_TOKEN=<powerdns-api-token> [CURL_MAX_TIME=5] pdns-srv register -n <name> -p <port>
```

### Deregister service in PowerDNS:
```
PDNS_API_URL=<powerdns-api-url> PDNS_API_TOKEN=<powerdns-api-token> [CURL_MAX_TIME=5] pdns-srv deregister -n <name>
```
