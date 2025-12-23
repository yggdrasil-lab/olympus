# Project: Olympus

## Objective
This project provides a simple and secure way to expose services to the internet using Traefik as a reverse proxy and Cloudflare Tunnel.

## Services
*   **Traefik:** A modern reverse proxy and load balancer.
*   **Cloudflared:** Creates a secure tunnel to the Cloudflare network.
*   **Whoami:** A simple service for testing and debugging.

## Tech Stack
*   **Containerization:** Docker & Docker Compose
*   **Reverse Proxy:** Traefik
*   **Tunneling:** Cloudflare Tunnel

## Initial Setup (Linux)

For Debian/Ubuntu based systems:

**1. Install Docker:**

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

**2. Manage Docker as a non-root user (optional but recommended):**

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

**3. Install Docker Compose (if not already installed with docker-ce-cli):**

The above `docker-ce-cli` installation should include `docker-compose-plugin`, which provides the `docker compose` command. You can verify with:

```bash
docker compose version
```

If `docker compose` is not available, you can install it manually:

```bash
sudo apt update
sudo apt install docker-compose-plugin # This installs 'docker compose' (plugin version)
# Or for the standalone 'docker-compose' (legacy version):
# sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
```

## Usage
1.  Create a `.env` file from the `.env.example` file and fill in the required values.
2.  Run `./start.sh` to create the network and start the services.
3.  Access the Traefik dashboard at `http://localhost:8080`.
4.  Access the whoami service at the domain you configured in your `.env` file.
