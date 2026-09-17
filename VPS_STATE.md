# netcup VPS Leo: Single Source of Truth

> Canonical, portable state for the netcup VPS named `leo`.
> Generated or refreshed by `scripts/update-vps-state.sh`.
> Do not store passwords, private keys, tokens, full environment dumps, or application secrets here.

## Document Metadata

- **State file:** `VPS_STATE.md`
- **Last refreshed:** `PENDING_FIRST_SNAPSHOT`
- **Refresh source:** `PENDING_SSH_TARGET`
- **State confidence:** Template only; live facts have not been collected yet
- **Update policy:** Refresh after infrastructure changes and before asking an AI client for operational advice

## AI Operating Contract

Treat this document as the authoritative description of the VPS unless the user explicitly supplies newer evidence. Do not invent missing values. Mark unknown or stale facts as `UNKNOWN` and request a targeted command or snapshot. Never expose or request secrets from this file.

Before proposing a change:

1. Identify the affected service, dependency, and rollback path.
2. Check the current state and timestamp below.
3. Prefer reversible, least-privilege, maintenance-window-safe actions.
4. Provide exact commands and a verification command.
5. Do not execute destructive, financial, authentication, firewall, DNS, or production changes without explicit confirmation.

## Identity and Access

- **Provider:** netcup
- **Server name:** leo
- **Public hostname:** UNKNOWN
- **Public IPv4:** OMITTED_BY_DESIGN
- **Public IPv6:** OMITTED_BY_DESIGN
- **SSH target alias:** UNKNOWN
- **SSH user:** UNKNOWN
- **SSH port:** UNKNOWN
- **SSH authentication:** Existing local SSH configuration; never record private key paths or key contents
- **Privilege model:** UNKNOWN

## Host

- **Operating system:** UNKNOWN
- **OS release:** UNKNOWN
- **Kernel:** UNKNOWN
- **Architecture:** UNKNOWN
- **Timezone:** UNKNOWN
- **Hostname:** UNKNOWN
- **Uptime:** UNKNOWN
- **Last reboot:** UNKNOWN

## Capacity and Health

- **CPU:** UNKNOWN
- **Memory:** UNKNOWN
- **Swap:** UNKNOWN
- **Root filesystem:** UNKNOWN
- **Other filesystems:** UNKNOWN
- **Load average:** UNKNOWN
- **Health warnings:** UNKNOWN

## Network and Exposure

- **Listening sockets:** UNKNOWN
- **Firewall:** UNKNOWN
- **Reverse proxy:** UNKNOWN
- **DNS records:** UNKNOWN
- **TLS certificates and renewal:** UNKNOWN
- **Externally exposed services:** UNKNOWN

## Runtime Inventory

- **Docker:** UNKNOWN
- **Docker Compose:** UNKNOWN
- **Node.js:** UNKNOWN
- **Python:** UNKNOWN
- **Go:** UNKNOWN
- **Rust:** UNKNOWN
- **Package manager updates pending:** UNKNOWN

## Services

| Service | Manager | Status | Port or socket | Data location | Backup | Notes |
|---|---|---|---|---|---|---|
| UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Replace with verified inventory |

## Containers

| Container | Image | Status | Published ports | Volumes | Restart policy | Notes |
|---|---|---|---|---|---|---|
| UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | UNKNOWN | Replace with verified inventory |

## Storage and Backups

- **Backup provider or method:** UNKNOWN
- **Backup schedule:** UNKNOWN
- **Last successful backup:** UNKNOWN
- **Restore test:** UNKNOWN
- **Retention policy:** UNKNOWN
- **Important data paths:** UNKNOWN

## Security Posture

- **OS security updates:** UNKNOWN
- **Automatic updates:** UNKNOWN
- **SSH hardening:** UNKNOWN
- **Root login policy:** UNKNOWN
- **Password authentication policy:** UNKNOWN
- **Fail2ban or equivalent:** UNKNOWN
- **Secrets management:** UNKNOWN
- **Recent security events:** UNKNOWN

## Change Log

| Date | Change | Evidence or command | Result | Rollback |
|---|---|---|---|---|
| PENDING | Initial state file created | Local repository setup | Live snapshot pending | Remove repository |

## AI Handoff Notes

Use the facts above as context. If a fact is `UNKNOWN`, do not infer it from a generic netcup setup. Ask for a fresh snapshot or a precise command result. Keep proposed changes in the response until the user explicitly approves execution.
