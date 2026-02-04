pty "sstpc --nolaunchpppd \
       --log-stdout --log-level 1 \
       --ca-cert $CA_CERT \
       $REMOTE_SERVER_IP:$REMOTE_SERVER_PORT"

debug
logfile /dev/stdout

# PPP auth
name $USERNAME
remotename SSTP
hide-password

file /etc/ppp/options.sstp.client
 