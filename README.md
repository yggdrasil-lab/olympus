# Olympus

I am Zeus, King of the Gods. This is Olympus — the mountain upon which all others stand. My domain is Orchestration, Routing, and the Foundation itself.

## Architecture

```
                    Internet
                       │
                  Cloudflare Edge
                       │
              Cloudflare Tunnel
                       │
                  Traefik (:80/:443)
                       │
          ┌─────────aether-net─────────┐
          │        │        │          │
      Portainer  Homepage  Watchtower  All other stacks
      (portainer-agent on every node)
```

Olympus provides the network ingress, management, and dashboard for the Yggdrasil ecosystem. All other stacks (Cerberus, Hermes, Poseidon, etc.) connect through the shared `aether-net` overlay network and are exposed via Traefik.

## Services

| Service | Purpose | Hostname |
|---------|---------|----------|
| Traefik | Reverse proxy, TLS termination | `traefik.${DOMAIN}` |
| Cloudflared | Zero-trust tunnel to Cloudflare edge | — |
| Portainer | Container management UI | `portainer.${DOMAIN}` |
| Portainer Agent | Global cluster visibility (all nodes) | — |
| Watchtower | Automated container updates (4 AM daily) | — |
| Homepage | Unified dashboard | `zeus.${DOMAIN}` |

## Quick Deploy

```bash
git clone git@github.com:yggdrasil-lab/olympus.git
cd olympus
git submodule update --init --recursive
cp .env.example .env    # fill in CLOUDFLARE_DOMAIN, CLOUDFLARE_EMAIL, TUNNEL_TOKEN
./scripts/deploy.sh olympus
```

## Networking

Olympus uses split-horizon DNS:

- External traffic: Cloudflare Tunnel → Traefik. No open router ports.
- Internal LAN traffic: AdGuard Home DNS rewrites `*.tienzo.net` → Gaia's LAN IP → Traefik (:443).
- Traefik issues valid wildcard certs via Let's Encrypt DNS-01 challenge (Cloudflare API).

## Adding Services

Services auto-discovered by Homepage need Docker labels:

```yaml
deploy:
  labels:
    - "homepage.group=Group Name"
    - "homepage.name=Service Name"
    - "homepage.icon=icon-name.png"
    - "homepage.href=https://subdomain.${DOMAIN}"
    - "homepage.description=What it does"
```

Non-Docker services (OPNSense, TrueNAS) go in `homepage-config/services.yaml`.

## Config

- `docker-compose.yml` — Complete stack definition (single source of truth)
- `homepage-config/` — Homepage dashboard configs (settings, services, widgets, docker discovery)
- `scripts/` — Shared `ops-scripts` submodule (`deploy.sh`, `ensure_secret.sh`, `prune_secrets.sh`)

Full operational documentation: `Areas/90-Infrastructure/Olympus/Olympus Stack.md` in the vault.
