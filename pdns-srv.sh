#!/usr/bin/env bash

set -e

function usage {
    echo "USAGE: $0"
    echo "  Register service: PDNS_API_URL=<powerdns-api-url> PDNS_API_TOKEN=<powerdns-api-token> [CURL_MAX_TIME=5] pdns-srv register -n <name> -p <port>"
    echo "  Deregister service: PDNS_API_URL=<powerdns-api-url> PDNS_API_TOKEN=<powerdns-api-token> [CURL_MAX_TIME=5] pdns-srv deregister -n <name>"
    exit $1
}

function register {
    if [ -z "$NAME" -o -z "$PORT" ]; then
       usage 1
    fi

    ID="${ENV}_${HOSTNAME}_${NAME}"
    JSON="{\"ID\":\"$ID\",\"Name\":\"$NAME\",\"Address\":\"$ADDRESS\",\"Port\":$PORT,\"Tags\":$TAGS}"
    
    _NAME_=""
    DOMAIN=$(grep -i "^search " /etc/resolv.conf | cut -d " " -f2)
    ADDRESS="${HOSTNAME}.${DOMAIN}"

    DATA="{\"changetype\":\"REPLACE\",\"name\":\"$_NAME_\",\"type\":\"SRV\",\"records\":[\"$ADDRESS\",\"Port\":$PORT]}"

    curl --location --silent --show-error --max-time "${CURL_MAX_TIME:=30}" --header "$_CURL_TOKEN_HEADER_" --request PATCH --data "$DATA" "$PDNS_API_URL/api/v1/servers/localhost/zones/$DOMAIN."
}

function deregister {
    if [ -z "$NAME" ]; then
       usage 1
    fi

    ID="${ENV}_${HOSTNAME}_${NAME}"

    curl --location --silent --show-error --max-time "${CURL_MAX_TIME:=30}" --header "$_CURL_TOKEN_HEADER_" --request PUT "$PDNS_API_URL/v1/agent/service/deregister/$ID"
}

if [ -z "$PDNS_API_URL" -o -z "$PDNS_API_TOKEN" ]; then
    usage 1
fi
PDNS_API_URL=${PDNS_API_URL%/}

if [ ! -z "$PDNS_API_TOKEN" ]; then
    _CURL_TOKEN_HEADER_="X-API-Key: $PDNS_API_TOKEN"
fi

if [ -z $1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
    usage 0
fi

if ! [ $1 = "register" -o $1 = "deregister" ]; then
    usage 1
fi

COMMAND="$1"

shift
while getopts "n:p:" opt; do
  case $opt in
    n) export NAME="$OPTARG" ;;
    p) export PORT="$OPTARG" ;;
  esac
done

$COMMAND
