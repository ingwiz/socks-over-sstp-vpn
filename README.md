# SOCKS5 over SSTP VPN (Docker)

Run an **SSTP VPN client with a SOCKS5 proxy** inside Docker.  
Designed for **Docker Desktop on Windows**.

This setup avoids the limitations of the native Windows SSTP client and provides:
- SOCKS5 access to the VPN

---

## What’s inside

- **SSTP client** (PPP-based)
- **Dante SOCKS5 proxy**

---

## Requirements

- SSTP VPN credentials
- CA certificate for the SSTP server

---

## Setup

1. Copy environment template:

```bash
cp .env.sample .env
```

2. Edit `.env` and set your SSTP credentials. Don't forget check if path `CA_CERT` to your CA certificate is right

### Dante (SOCKS5) configuration

```bash
cp ./dante/danted.conf.sample ./dante/danted.conf
```

⚠️ Important

By default, outbound access is restricted to private networks only:

    10.0.0.0/8

    172.28.0.0/16

All other destinations are explicitly blocked.

This is an intentional security measure to limit access to internal VPN resources.

If necessary, you can adjust this behavior in `danted.conf`.

---

## Run - Start SSTP + SOCKS5

```
docker compose up -d
```

SOCKS5 will be available at: `127.0.0.1:2080`

## SSH over SOCKS5

1. Using **ncat** (useful for `git` operations and tools like Ansible)

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

- Make aliases for the most used command, ex. `ssh` and `curl`

---

## DNS

If your VPN provider does not provide private DNS servers but you need them, you can specify the `dns` option for the `sstp-client` service in `docker-compose.yml`.

DNS servers provided by your VPN provider have the highest priority.

Use the SOCKS5h protocol to route DNS requests through the SOCKS server.

---

## Notes

- SSTP runs in privileged mode to allow PPP networking.

- SOCKS5 service start only after the VPN tunnel is established.

## License

MIT
