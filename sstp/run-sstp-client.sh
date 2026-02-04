#!/bin/sh

set -ue

rm -f ./dns-upstream/Corefile /tmp/upstream_domains

: ${REMOTE_SERVER_IP?Please specify parameter}
: ${REMOTE_SERVER_PORT=443}
: ${USERNAME?Please specify parameter}
: ${PASSWORD?Please specify parameter}

set -x

export CA_CERT=/ca_cert.crt
if ! [ -f $CA_CERT ]; then
    echo $CA_CERT not found
    exit 1
fi

export REMOTE_SERVER_IP
export REMOTE_SERVER_PORT
export USERNAME
export PASSWORD

echo $UPSTREAM_DOMAINS | tee /tmp/upstream_domains

envsubst '$REMOTE_SERVER_IP $REMOTE_SERVER_PORT $USERNAME $CA_CERT' \
    < ./peer-sstp.tpl \
    > /etc/ppp/peers/sstp

envsubst '$USERNAME $PASSWORD' \
    < ./chap-secrets.tpl \
    > /etc/ppp/chap-secrets

cp ip-up options.sstp.client /etc/ppp/
cp 99-dns-upstream /etc/ppp/ip-up.d/

rm -f /etc/ppp/ip-up.d/0000usepeerdns

GW=$(ip route | awk '/^default/ {print $3}')
ip route add $REMOTE_SERVER_IP via $GW

exec pppd call sstp nodetach
# pon sstp nodetach

# echo Finished ...