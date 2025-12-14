# Homelab Staging Environment

## Objective
Establish a **Staging Homelab** environment on the current Windows machine using WSL2 and Docker. This will serve as a sandbox to containerize and test services before deploying them to the production Mini PC.

## Current Status
A fully functional Docker Compose environment with Cloudflare Tunnel integration:
*   **Orchestration:** Docker Compose (v2)
*   **Reverse Proxy/Load Balancer:** Traefik (v2.10) with automatic HTTPS via Let's Encrypt (Cloudflare DNS-01 Challenge).
*   **Secure Tunnel:** Cloudflare Tunnel (`cloudflared`) for secure public exposure.
*   **Test Service:** Whoami (Traefik's simple test service).

## Local Access:

*   **Traefik Dashboard:** Access the Traefik dashboard at `http://localhost:9000`
*   **Whoami Test Service:** Access the Whoami service locally via HTTPS at `https://whoami.localhost`
    *   *(Note: The first time you visit `https://whoami.localhost`, your browser will show a "Not secure" warning. This is expected for local self-signed certificates; you can safely proceed.)*

## Public Access:

*   **Whoami Public Service:** Accessible globally via HTTPS at `https://YOUR_SUBDOMAIN.YOUR_CLOUDFLARE_DOMAIN` (e.g., `https://whoami.example.com`). This connection is fully secure with a trusted Let's Encrypt certificate.

## Usage:

To start the environment:
```bash
docker compose up -d
```

To stop the environment:
```bash
docker compose down
```

### Important: `.env` Configuration

Ensure your `.env` file in the project root is configured correctly:

*   `TUNNEL_TOKEN`: Your Cloudflare Tunnel token.
*   `CLOUDFLARE_DOMAIN`: Your root domain (e.g., `example.com`).
*   `SUBDOMAIN`: The subdomain used for services (e.g., `whoami`).
*   `CLOUDFLARE_EMAIL`: Your Cloudflare account email.
*   `CLOUDFLARE_API_KEY`: Your Cloudflare Global API Key (for Let's Encrypt).

## Next Steps:
The foundation is complete. You can now begin deploying other services (e.g., Portainer, Homepage, your Workout App API) into this secure and accessible environment.