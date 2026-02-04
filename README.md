# SOCKS5 over SSTP VPN (Docker)

Run an **SSTP VPN client with a SOCKS5 proxy** inside Docker.  
Designed for **Docker Desktop on Windows**.

This setup avoids the limitations of the native Windows SSTP client and provides:
- SOCKS5 access to the VPN
- Optional DNS forwarding via CoreDNS

---

## What’s inside

- **SSTP client** (PPP-based)
- **Dante SOCKS5 proxy**
- **CoreDNS** (optional)

---

## Requirements

- Docker Desktop
- SSTP VPN credentials
- CA certificate for the SSTP server

---

## Setup

1. Place your CA certificate: `./.ca_cert.crt`

1. Copy environment template:

```bash
cp .env.sample .env
```

3. Edit `.env` and set your SSTP credentials.

### Dante (SOCKS5) configuration

By default, `dante/danted.conf` **restricts outbound access** to private networks only:

- `10.0.0.0/8`
- `172.28.0.0/16`

All other destinations are explicitly blocked.

This is done intentionally to limit access to internal VPN resources.

---

#### Allow access to all destinations

If you want to allow SOCKS5 access to **any IP address**, update `danted.conf` as follows:

1. Replace all existing `socks pass` rules with:

```conf
socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    command: bind connect udpassociate
    log: error
}
```

2. Remove the final socks block rule completely.

After these changes, Dante will allow connections to any destination through the VPN.

## Run

### Start SSTP + SOCKS5

```
docker compose up -d
```

SOCKS5 will be available at: `127.0.0.1:2080`

## SSH over SOCKS5

1. Using **ncat**

`~/.ssh/config`:
```
Host 10.*
  ProxyCommand ncat --proxy-type socks5 --proxy 127.0.0.1:2080 %h %p
```

2. Using **proxychains4**

```
proxychains4 ssh user@host
```

`~/.proxychains/proxychains.conf`:

```
strict_chain
proxy_dns

[ProxyList]
socks5 127.0.0.1 2080
```

---

## DNS (Optional)

Enable CoreDNS if you need private or conditional DNS resolution over the VPN.

### Start with DNS support

Set `UPSTREAM_DOMAINS` in `.env`, then run:

```
docker compose --profile dns up -d
```

CoreDNS listens on: 127.0.0.1:2053/udp

### Stop DNS

```
docker compose --profile dns down
```

## Ports

| Service | Address        |
| ------- | -------------- |
| SOCKS5  | 127.0.0.1:2080 |
| DNS     | 127.0.0.1:2053 |

---

## Notes

- SSTP runs in privileged mode to allow PPP networking.

- SOCKS5 and CoreDNS share the VPN network namespace.

- Services start only after the VPN tunnel is established.

## License

MIT