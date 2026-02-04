. {
    forward . /etc/resolv.conf
    cache 30
    log
}

$UPSTREAM_DOMAINS {
    forward . $DNS1 $DNS2
    cache 30
    log
}