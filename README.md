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

## Usage
1.  Create a `.env` file from the `.env.example` file and fill in the required values.
2.  Run `./start.sh` to create the network and start the services.
3.  Access the Traefik dashboard at `http://localhost:8080`.
4.  Access the whoami service at the domain you configured in your `.env` file.
