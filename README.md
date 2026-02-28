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

*   **Traefik**: Modern reverse proxy and load balancer (The Gate).
*   **Cloudflared**: Zero-trust tunnel to the Cloudflare edge.
*   **Homepage**: The unified dashboard for the Yggdrasil ecosystem (The Map).
*   **Portainer**: Container management UI (The Throne) + **Agents** (The Eyes).
*   **Watchtower**: Automated container updates (The Guardian).
*   **Docker Swarm**: The orchestration engine (Production).
*   **Docker Compose**: The service definition (Development).

## Architecture

Olympus operates through the following components:

1.  **Traefik Proxy**: Auto-discovers services via the Docker Swarm Orchestrator.
2.  **Portainer Stack**:
    *   **Manager**: Centralized dashboard on the Leader node.
    *   **Agent**: Global deployment on all nodes for cluster-wide visibility.
3.  **Watchtower**: Automated daily updates for all containers (Managers & Workers).
4.  **Cloudflare Tunnel**: Exposes the Traefik entrypoint to the internet without port forwarding.
5.  **Aether-Net**: The shared Docker network that connects Olympus to all other stacks.

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
*   **Homepage Dashboard**: `https://zeus.${CLOUDFLARE_DOMAIN}` (Entrypoint to the Forge).

## Homepage Configuration

Homepage is configured to automatically discover containers in the Docker Swarm environment by polling the Docker Socket. Modifying `services.yaml` is generally not needed for internal apps.

### Adding Docker Services (Swarm Mode)
To add a new service to Homepage, attach the following **Docker Labels** to the service's `deploy.labels` block in its respective `docker-compose.yml` file:

```yaml
deploy:
  labels:
    # Essential Homepage Labels
    - "homepage.group=Group Name" # e.g. Apollo, Cerberus, Management
    - "homepage.name=Service Name" # e.g. Portainer
    - "homepage.icon=icon-name.png" # Built-in homepage icon
    - "homepage.href=https://subdomain.${DOMAIN_NAME}"
    - "homepage.description=A brief description of the app"
```

### Adding API Widgets (e.g. Sonarr, Radarr, Proxmox)
Homepage supports live data API widgets (e.g., showing missing episodes from Sonarr). Add the widget variables directly below the standard labels in the compose file:

```yaml
deploy:
  labels:
    # Existing labels...
    - "homepage.widget.type=sonarr"
    - "homepage.widget.url=http://sonarr:8989" # Internal DNS via Swarm Network
    - "homepage.widget.key=$SONARR_API_KEY"
```

*Note: For API keys, define them in the stack's `.env` file or Swarm secrets to prevent hardcoding them in the repository.*

### Adding External Services (Wait, TrueNAS, Routers)
To add hardware or services that are **not** running within the Docker Swarm (like your physical TrueNAS array or OPNSense router), you must define them manually in the Swarm configuration file.
Modify `homepage-config/services.yaml` in this repository:

```yaml
---
- Apollo: []
- Cerberus: []
- Management:
    - OPNSense:
        icon: opnsense.png
        href: https://192.168.1.1
        description: Primary Router
```

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
