# Project: Olympus (The Foundation)

## Objective
Establish the **Olympus Infrastructure**—the primary platform for the Citadel's self-hosted services. Olympus runs on the physical server **[[Atlas/Agents/Gaia|Gaia]]** and provides the networking, security, and routing for all divine containers.

## Core Philosophy
1.  **The Mountain:** Olympus is the stable ground. It must be resilient and high-performing.
2.  **The Gate (Traefik):** Securely route traffic from the "Sea" (Poseidon/Internet) to the correct services.
3.  **The Foundation:** All other projects (Atlas, Kratos, Plutus) are built on top of Olympus.

## Components (The Base Stack)
*   **Reverse Proxy:** Traefik (The Golden Gate).
*   **Access Control:** Cloudflare Tunnel + Access (or future Authelia).
*   **Networking:** External Docker network `aether-net`.
*   **Hardware Monitor:** **[[Atlas/Agents/Gaia|Gaia]]** monitoring (Prometheus/Grafana).

## Tech Stack
*   **OS:** WSL2 (Staging) / Ubuntu (Production).
*   **Containerization:** Docker & Docker Compose.
*   **Networking:** `aether-net` (External Bridge).

## Implementation Plan
*   [x] **Network Setup:** Create `aether-net`.
*   [x] **Traefik Setup:** Basic routing and SSL.
*   [ ] **Cloudflare Tunnel:** Connect Gaia to the Cloudflare Edge.
*   [ ] **Monitoring:** Set up Gaia metrics.

## Relationship with other Projects
*   **Olympus** provides the network and proxy.
*   **[[Efforts/Project - Atlas|Atlas Stack]]** connects to `aether-net` to be exposed via Olympus.