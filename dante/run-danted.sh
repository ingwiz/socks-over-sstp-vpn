#!/bin/sh

set -ue

DNS_LIST=( $(cat /dns-upstream/nameservers) )

if [ ${#DNS_LIST[@]} -ge 1 ]; then
    RESOLV_BAK=/etc/resolv.conf~
    [ -f $RESOLV_BAK ] || cp /etc/resolv.conf $RESOLV_BAK
    printf "nameserver %s\n" ${DNS_LIST[@]} > /etc/resolv.conf
    echo options ndots:0 >> /etc/resolv.conf
fi

exec /usr/sbin/danted -f /etc/danted.conf
