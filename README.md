# Olympus

> I am Zeus, King of the Gods. This is Olympus—the mountain upon which all others stand. My domain is Orchestration, Routing, and the Foundation itself. Without me, there is only chaos.

## Mission

I provide the bedrock for the Yggdrasil ecosystem. My mission is to establish the secure environment where applications live, managing the flow of traffic (Traefik), the command of containers (Portainer), and the bridge to the outside world (Cloudflare).

## Core Philosophy

*   **The High Ground**: I act as the central platform. All services (Cerberus, Hermes, Poseidon) are deployed upon my slopes.
*   **The Gate**: I control who enters and who leaves via the Reverse Proxy.
*   **The Bridge**: I connect the local realm to the internet securely via encrypted tunnels, requiring no open ports in the firewall.

---

## Tech Stack

*   **Traefik**: Modern reverse proxy and load balancer.
*   **Cloudflared**: Zero-trust tunnel to the Cloudflare edge.
*   **Portainer**: Container management UI.
*   **Docker Compose**: The orchestration engine.

## Architecture

Olympus operates through the following components:

1.  **Traefik Proxy**: Auto-discovers Docker containers and routes traffic based on labels.
2.  **Cloudflare Tunnel**: Exposes the Traefik entrypoint to the internet without port forwarding.
3.  **Aether-Net**: The shared Docker network that connects Olympus to all other stacks.

## Prerequisites

*   **Linux Host**: Debian/Ubuntu recommended.
*   **Docker & Docker Compose**: Installed and configured for non-root user.
*   **Cloudflare Account**: For tunnel token generation.

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
*   `TUNNEL_TOKEN`: The tunnel token from your Cloudflare Zero Trust dashboard.
*   `CLOUDFLARE_EMAIL`: Your Cloudflare account email.
*   `CF_DNS_API_TOKEN`: Your Cloudflare API Token with `Zone:DNS:Edit` permissions.
*   `CLOUDFLARE_DOMAIN`: Your root domain (e.g., `yourdomain.com`).

## Execution

1.  **Create the Network:**
    ```bash
    docker network create aether-net
    ```

2.  **Start the Stack:**
    ```bash
    docker compose up -d
    ```

## Services

*   **Traefik Dashboard**: `https://traefik.yourdomain.com` (Protected by Cerberus).
*   **Portainer**: `https://portainer.yourdomain.com` (Protected by Cerberus).