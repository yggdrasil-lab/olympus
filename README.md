# Olympus

> I am Zeus, King of the Gods. This is Olympus—the mountain upon which all others stand. My domain is Orchestration, Routing, and the Foundation itself. Without me, there is only chaos.

## Mission

I provide the bedrock for the Yggdrasil ecosystem. My mission is to establish the secure environment where applications live, managing the flow of traffic (Traefik), the command of containers (Portainer), and the bridge to the outside world (Cloudflare).

## Core Philosophy

*   **The High Ground**: I act as the central platform. All services (Cerberus, Hermes, Poseidon) are deployed upon my slopes.
*   **The Gate**: I control who enters and who leaves via the Reverse Proxy.
*   **The Bridge**: I connect the local realm to the internet securely via encrypted tunnels, while also allowing direct local access via Split-Horizon DNS (e.g., AdGuard Home).

## Networking & Security

Olympus uses a **Split-Horizon DNS** configuration to ensure seamless access both inside and outside your local network:

1.  **External Access**: Traffic from the internet enters via **Cloudflare Tunnel (`cloudflared`)**. This requires no open ports on your router/firewall.
2.  **Internal Access**: Traffic from within your LAN is routed directly to the server's static IP via **AdGuard Home** DNS rewrites (e.g., `*.yourdomain.com` -> `192.168.x.x`). 
3.  **Port Exposure**: Traefik exposes ports `80` and `443` by default to support this direct local access. Ensure your server's host firewall allows inbound traffic on these ports.

---

## Tech Stack

*   **Traefik**: Modern reverse proxy and load balancer.
*   **Cloudflared**: Zero-trust tunnel to the Cloudflare edge.
*   **Portainer**: Container management UI.
*   **Docker Swarm**: The orchestration engine (Production).
*   **Docker Compose**: The service definition (Development).

## Architecture

Olympus operates through the following components:

1.  **Traefik Proxy**: Auto-discovers services via the Docker Swarm Orchestrator (Prod) or Docker Socket (Dev).
2.  **Cloudflare Tunnel**: Exposes the Traefik entrypoint to the internet without port forwarding (Production only).
3.  **Aether-Net**: The shared Docker network that connects Olympus to all other stacks.

## Prerequisites

*   **Linux Host**: Debian/Ubuntu recommended (WSL2 for Development).
*   **Docker Engine**: Installed and initialized in Swarm mode (`docker swarm init`).
*   **Cloudflare Account**: For tunnel token generation.

## Configuration Structure

The stack is split to support distinct environments:

*   **`docker-compose.yml`**: Base service definitions (Traefik, Portainer). Exposes ports `80` & `443` directly to support local access (Split-Horizon DNS).
*   **`docker-compose.dev.yml`**: Development overrides. Adds port `8080` for the insecure Traefik dashboard.
*   **`docker-compose.prod.yml`**: Production overrides. Adds `cloudflared` for secure tunneling.

## Setup Instructions

### 1. Install Docker Engine

*(For Debian/Ubuntu)*
```bash
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Manage as non-root:**
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Repository Initialization

```bash
git clone <your-repository-url> olympus
cd olympus
cp .env.example .env
```

### 3. Configuration

Edit `.env` to configure:
*   `CLOUDFLARE_DOMAIN`: Your root domain (e.g., `dev.yourdomain.com` for dev, `yourdomain.com` for prod).
*   `CLOUDFLARE_EMAIL`: Your Cloudflare account email.
*   `CF_DNS_API_TOKEN`: Your Cloudflare API Token with `Zone:DNS:Edit` permissions.
*   `TUNNEL_TOKEN`: (Production) The tunnel token from your Cloudflare Zero Trust dashboard.

## Execution

### Development (Localhost)
Exposes services on your local ports `80` and `443`.

```bash
./start_dev.sh
```

### Production (Swarm)
Uses Docker Swarm with Cloudflare Tunnel. Pinned to Manager nodes for security.

```bash
# Ensure you have initialized Swarm first:
# docker swarm init

./start.sh
```

**Note**: This uses `docker stack deploy`. Removed services are automatically pruned (`--prune`).

*Note: In production (e.g., via GitHub Actions), the `.env` file is optional if environment variables are injected directly into the shell.*

## Services

*   **Traefik Dashboard**: `https://traefik.${CLOUDFLARE_DOMAIN}` (Protected by Cerberus).
*   **Portainer**: `https://portainer.${CLOUDFLARE_DOMAIN}` (Protected by Cerberus).
