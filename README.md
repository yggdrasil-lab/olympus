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
*   **Docker Engine**: Installed and initialized (see `Forge/yggdrasil-os`).
*   **Cloudflare Account**: For tunnel token generation.

## Configuration Structure

The stack is consolidated into a single Source of Truth:
*   **`docker-compose.yml`**: Defines the complete Olympus stack (Traefik, Portainer, Cloudflared).
    *   **External Access:** Via `cloudflared` (Tunnel).
    *   **Internal Access:** Via Traefik ports `80` & `443` (Split-Horizon DNS).

## Setup Instructions

### 1. Install Docker Engine
Refer to **[[Project - Yggdrasil OS]]** or run the centralized installer:

```bash
# From Yggdrasil OS repository
sudo ./docker/install_docker.sh
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

### Deployment (Standard)
Deployments are handled via the unified `ops-scripts` workflow.

```bash
# Initialize submodules first
git submodule update --init --recursive

# Deploy stack
./scripts/deploy.sh olympus
```

**Note**: This uses `docker stack deploy` under the hood. It automatically handles secret generation (`ensure_secret.sh`) for sensitive variables.



*Note: In production (e.g., via GitHub Actions), the `.env` file is optional if environment variables are injected directly into the shell.*

## Services

*   **Traefik Dashboard**: `https://traefik.${CLOUDFLARE_DOMAIN}` (Protected by Cerberus).
*   **Portainer**: `https://portainer.${CLOUDFLARE_DOMAIN}` (Protected by Cerberus).

## OIDC Configuration (Portainer)

To enable Single Sign-On via Authelia:

1.  **Authentication:** Go to Settings -> Authentication -> OAuth.
2.  **Use SSO:** Toggle `ON`.
3.  **Hide Internal Authentication:** Toggle `ON` (Optional, once tested).
4.  **Automatic User Provisioning:** Toggle `ON` (Required for new users).
5.  **Configuration:**
    *   **Client ID:** `portainer`
    *   **Client Secret:** (Retrieve from Vaultwarden)
    *   **Authorization URL:** `https://auth.example.com/api/oidc/authorization`
    *   **Access Token URL:** `https://auth.example.com/api/oidc/token`
    *   **Resource URL:** `https://auth.example.com/api/oidc/userinfo`
    *   **Redirect URL:** `https://portainer.example.com/` (Must match Authelia config exactly)
    *   **User Identifier:** `preferred_username` or `email`
    *   **Scopes:** `openid profile email groups`
