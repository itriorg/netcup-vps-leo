# VPS-CUPNET / Leo One

## Enterprise Operational Single Source of Truth

**Document status:** Consolidated operational baseline
**Document version:** 3.1
**Last consolidated:** 2026-09-17
**Primary evidence cutoff:** 2026-09-17, with Kasm evidence through 2026-09-16
**Owner:** Leo
**Provider:** netcup / Cupnet
**Classification:** Private internal operations document
**Canonical file:** `VPS_STATE.md`

> This is the only canonical VPS context document for AI clients and operators. Historical source documents remain in the local `_inbox/` folder for audit provenance and are intentionally ignored by Git. Do not create parallel handoff files. Update this file and its Change Record after every material change.

---

## 0. How AI Systems Must Use This File

### 0.1 Authority and evidence rules

Use this file as the current operational context. Facts are classified as follows:

| Label             | Meaning                                                                                          | AI behavior                                                                                    |
| ----------------- | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| `CONFIRMED`       | Directly observed or successfully tested with dated evidence                                     | May be used as current state, subject to its evidence date                                     |
| `OWNER-CONFIRMED` | Directly asserted by the owner as current, but not yet independently evidenced in the source set | Use as current owner input; do not invent policy details and schedule independent verification |
| `RECORDED`        | Supported by a prior authoritative document but not rechecked in the latest session              | Use with the stated date; recommend rechecking before risky action                             |
| `PENDING`         | Required work is known but completion is not demonstrated                                        | Never claim complete                                                                           |
| `DEFERRED`        | Intentionally postponed by design                                                                | Do not implement without a new decision                                                        |
| `HISTORICAL`      | Superseded by later evidence                                                                     | Context only; never use as current state                                                       |
| `UNKNOWN`         | No reliable evidence available                                                                   | Do not infer; request a targeted check                                                         |
| `CONFLICT`        | Sources disagree and no live evidence resolves the difference                                    | Preserve both claims and require verification                                                  |

When sources conflict, prefer this order:

1. Fresh direct live command output from the VPS.
2. The latest dated verified operational document.
3. The latest dated consolidated SSOT.
4. Older handoffs and planning documents.
5. Generic assumptions or vendor defaults are never evidence.

### 0.2 Non-hallucination contract

An AI client must:

- Treat `UNKNOWN`, `PENDING`, `DEFERRED`, and `CONFLICT` as unresolved.
- Never invent a version, port, path, credential, backup result, firewall rule, or service status.
- Distinguish `planned`, `configured`, `running`, `healthy`, `publicly tested`, and `recovery-tested`.
- State the evidence date whenever relying on a recorded fact.
- Use Docker DNS names, not historical container IP addresses.
- Never request, reproduce, or store secrets in chat, Markdown, Git, screenshots, logs, or prompts.
- Propose read-only inspection first for unknown state.
- Provide a rollback path and verification command before any change.
- Ask for explicit confirmation before destructive, production, authentication, firewall, DNS, backup, certificate, or access-control changes.
- Never execute `docker compose pull`, database changes, volume deletion, firewall changes, key rotation, or restore operations blindly.
- Keep sensitive administration, credentials, private data, logs, VPN material, and secret-bearing configuration on the local Ollama route only.

### 0.3 Required response format for operational work

For any proposed VPS action, an AI client should answer in this order:

1. **Current evidence:** what this document says and its date.
2. **Unknowns:** what must be checked first.
3. **Risk:** service impact, security impact, data risk, and rollback risk.
4. **Read-only checks:** exact commands that do not mutate state.
5. **Change plan:** smallest reversible change, scoped to one stack.
6. **Verification:** exact success criteria and commands.
7. **Rollback:** exact recovery action and prerequisites.
8. **Record update:** what must be added to the Change Record and task register.

### 0.4 Secret boundary

Never include or ask the user to paste:

- Passwords, API tokens, OAuth tokens, SMTP credentials, provider keys, or client keys.
- `N8N_ENCRYPTION_KEY`, database passwords, Restic passwords, R2 credentials, or WebSocket bridge secrets.
- Cloudflare Origin CA private key or certificate/key material.
- `/etc/wireguard/wg0.conf`, client VPN profiles, SSH private keys, or TOTP recovery codes.
- Kasm administrator credentials or password-manager contents.
- Secret-bearing `.env` files, shell history, unredacted `docker inspect`, or environment dumps.

The following may still be operationally sensitive and should remain private: public IP, provider identifiers, MAC/machine IDs, internal IPs, VPN peer details, filesystem layout, container names, and logs.

---

## 1. Current State Dashboard

**State interpretation:** This dashboard records the latest documented state, not an assertion that the VPS is live-verified at the moment this file is read.

| Area                  | Current documented state                                                                                            | Evidence date | Status            | Next action                                                 |
| --------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------: | ----------------- | ----------------------------------------------------------- |
| Host identity         | Debian 13 Trixie, Leo One, authoritative hostname recorded                                                          | 2026-09-09/17 | `RECORDED`        | Re-run host baseline                                        |
| Compute/storage       | 8 vCPU, 16 GiB RAM, 512 GiB nominal storage; ~450 GiB available at audit                                            |    2026-09-10 | `RECORDED`        | Check free space and memory                                 |
| Firewall              | UFW deny incoming/default routed deny; 22/80/443 and UDP 51820 documented allowed                                   |    2026-09-17 | `RECORDED`        | Explain 3389/8443/telemetry observations                    |
| Caddy                 | Running reverse proxy and Cloudflare Origin CA TLS                                                                  | 2026-09-16/17 | `CONFIRMED`       | Validate current Caddyfile                                  |
| Nextcloud             | Public route and application previously functional; maintenance status became uncertain after failed backup attempt |    2026-09-17 | `PENDING`         | Check `occ status` first                                    |
| n8n                   | Public route, PostgreSQL backend, internal-only database documented                                                 | 2026-09-09/17 | `RECORDED`        | Verify dump, restore, and encryption-key backup             |
| Kasm                  | Public route and administrator login tested successfully                                                            |    2026-09-16 | `CONFIRMED`       | Add backup/restore coverage                                 |
| Ollama                | Private local Qwen models documented; no host port                                                                  | 2026-09-11/17 | `RECORDED`        | Check current models and volume                             |
| OmniRoute             | Healthy container, private port 20128, no host port; dashboard reconnect issue unresolved                           |    2026-09-17 | `PENDING`         | Internal health and dashboard-path test                     |
| Open WebUI            | Deployed privately; first-run administrator/authentication not accepted as complete                                 |    2026-09-17 | `PENDING`         | Complete setup and route tests                              |
| VS Code Server        | Deployed privately; route tested; application authentication disabled in prior evidence                             |    2026-09-17 | `PENDING`         | Enable and test authentication                              |
| Claude CLI            | Reaches gateway but received provider 401                                                                           |    2026-09-17 | `PENDING`         | Resolve provider credentials safely                         |
| Netdata               | 2.11.0 on loopback 127.0.0.1:19999 via SSH tunnel                                                                   |    2026-09-13 | `RECORDED`        | Add protected alerting design                               |
| WireGuard             | Standard WireGuard IPv4 full tunnel; replacement profiles staged                                                    | 2026-09-07/17 | `PENDING`         | Complete migration, retire old peers                        |
| Backups               | Local/R2 baseline passed before later n8n/AI/Kasm additions                                                         | 2026-09-09/17 | `PENDING`         | Verify current coverage and restore                         |
| Cloudflare Zero Trust | Owner-confirmed protection is enabled for n8n, Nextcloud, and Kasm subdomains                                       |    2026-09-17 | `OWNER-CONFIRMED` | Record application/policy details and test clients/webhooks |
| Image pinning         | Several floating tags remain, including `latest`                                                                    |    2026-09-17 | `PENDING`         | Pin tested digests one stack at a time                      |
| Origin hardening      | Not implemented                                                                                                     |    2026-09-17 | `DEFERRED`        | Only after recovery and backup proof                        |
| SSH hardening         | Not fully reviewed                                                                                                  |    2026-09-17 | `PENDING`         | Review without losing console recovery                      |

---

## 2. Infrastructure Identity and Capacity

### 2.1 Provider and hardware

| Field                         | Value                                             | Status / evidence           |
| ----------------------------- | ------------------------------------------------- | --------------------------- |
| Provider                      | netcup / Cupnet                                   | `CONFIRMED`, source records |
| Product                       | RS 2000 G12, KVM                                  | `CONFIRMED`, 2026-09-04/09  |
| Location                      | Vienna, Austria                                   | `CONFIRMED`, source records |
| Server nickname               | Leo One                                           | `CONFIRMED`                 |
| Provider server ID            | `931750`                                          | `RECORDED`; keep private    |
| Chassis / virtualization      | vm / kvm                                          | `RECORDED`                  |
| Hardware vendor/model         | netcup / KVM Server                               | `RECORDED`                  |
| vCPU                          | 8                                                 | `RECORDED`                  |
| RAM                           | 16 GiB hardware; approximately 15 GiB visible     | `RECORDED`, 2026-09-10      |
| Storage                       | 512 GiB nominal; approximately 503 GiB filesystem | `RECORDED`, 2026-09-10      |
| Storage at audit              | Approximately 33 GiB used / 450 GiB available     | `RECORDED`, 2026-09-10      |
| Swap                          | 4 GiB enabled; 0 used at audit                    | `RECORDED`, 2026-09-10      |
| Exportable provider snapshots | One remaining at 2026-09-04 capture               | `HISTORICAL`; recheck       |

### 2.2 Host identity

| Field                         | Value                                                                               | Status                                  |
| ----------------------------- | ----------------------------------------------------------------------------------- | --------------------------------------- |
| Operating system              | Debian GNU/Linux 13 (Trixie)                                                        | `RECORDED`                              |
| Kernel                        | `6.12.107+deb13-amd64`                                                              | `RECORDED`                              |
| Authoritative static hostname | `v2202609410969512760`                                                              | `CONFIRMED` by direct checks 2026-09-09 |
| Authoritative FQDN            | `v2202609410969512760.powersrv.de`                                                  | `CONFIRMED` by direct checks 2026-09-09 |
| Public IPv4                   | `89.58.63.213`                                                                      | `RECORDED`; keep private                |
| Public interface              | `eth0`                                                                              | `RECORDED`                              |
| IPv6 allocation               | `2a0a:4cc0:1:8ea::/64`                                                              | `RECORDED`; recheck                     |
| Administrator                 | `leo`                                                                               | `CONFIRMED`                             |
| Privilege model               | `leo` belongs to `docker` and `stack-secrets`; Docker membership is root-equivalent | `CONFIRMED`                             |

**Resolved hostname conflict:** `v22026090410969512760.powersrv.de` was a transcription error in older source documents. Do not use it.

### 2.3 Required host baseline checks

Run from the VPS and record date, command, and result without collecting secrets:

```bash
hostnamectl
hostname -f
uname -srmo
cat /etc/os-release
uptime
free -h
df -hT
swapon --show
nproc
```

---

## 3. Network, Public Exposure, and Firewall

### 3.1 Intended public architecture

```text
Internet
  -> Cloudflare DNS/proxy and Full (strict) TLS
  -> Caddy on VPS ports 80/443 and UDP 443
      -> cloud.trisektor.org  -> Nextcloud
      -> n8n.trisektor.org    -> n8n
      -> desktop.trisektor.org -> Kasm through host.docker.internal:8443

WireGuard wg0 -> IPv4 full-tunnel VPN through UDP 51820

Private AI networks:
  ai_egress    -> OmniRoute, Redis, Open WebUI, VS Code Server
  omni_clients -> OmniRoute gateway and controlled AI clients/experiments
  dev_internal -> VS Code Server
```

### 3.2 Docker network inventory

| Network                              | Purpose                                            | State                                              |
| ------------------------------------ | -------------------------------------------------- | -------------------------------------------------- |
| `proxy`                              | Caddy and public application reverse-proxy traffic | `ACTIVE / RECORDED`                                |
| `nextcloud_nextcloud_internal`       | Nextcloud, cron, MariaDB, Redis                    | `ACTIVE / RECORDED`                                |
| `n8n_internal` or `n8n_n8n_internal` | n8n and PostgreSQL                                 | `ACTIVE / RECORDED`; exact name recheck            |
| `ai_egress`                          | Outbound-capable AI bridge network                 | `CONFIRMED created/intended`, 2026-09-17           |
| `omni_clients`                       | Private client-to-OmniRoute network                | `CONFIRMED attachment`, broader membership recheck |
| `dev_internal`                       | VS Code Server private development network         | `RECORDED`                                         |
| `ai_backend`                         | Earlier internal-only AI network without egress    | `HISTORICAL`; do not recreate without design       |
| `ai_clients`                         | Earlier AI network spelling                        | `HISTORICAL`; reverify before use                  |
| `n8n_ai`                             | Proposed n8n-to-Ollama isolation                   | `DEFERRED / PROPOSED`                              |

Rules:

- Use Docker DNS service names, never persistent configuration with container IPs.
- Do not attach PostgreSQL, MariaDB, Nextcloud Redis, or Caddy to AI networks.
- Do not attach OmniRoute to `proxy` or publish port 20128 to the host.
- Do not publish AI services through Caddy, Cloudflare, UFW, or public DNS in the current phase.
- Keep client containers on `omni_clients` only when their access policy has been reviewed.

### 3.3 Firewall and listener discrepancy

Documented UFW policy:

```text
Default incoming: deny
Default outgoing: allow
Default routed: deny
Allowed inbound: TCP 22, TCP 80, TCP 443, UDP 443 (QUIC status requires recheck), UDP 51820
```

Kasm is the documented owner of TCP 8443, but its bind address, direct exposure, and UFW treatment remain unverified. A 2026-09-17 observation also reported TCP 3389 and telemetry ports 4317/8125. These are security-relevant `CONFLICT` items, not harmless details. UDP 443 is documented as a Caddy capability but is missing from the older UFW evidence; verify whether QUIC is intentionally allowed or intentionally blocked.

Required resolution:

```bash
sudo ufw status verbose
sudo ss -lntup
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'
sudo docker ps --format '{{.Names}} {{.Ports}}' | grep -E '3389|8443|4317|8125' || true
sudo docker inspect $(sudo docker ps -q) --format '{{.Name}} {{json .HostConfig.PortBindings}}' 2>/dev/null
sudo ss -lunp | grep ':443' || true
```

Do not close or expose these ports until each listener is mapped to an intended service and a recovery path is confirmed. RDP 3389 is especially high priority if not explicitly required. Docker-published ports can bypass assumptions based only on UFW rules, so verify both Docker bindings and host firewall behavior.

---

## 4. Cloudflare and Caddy

### 4.1 Cloudflare state

| Setting                      | Documented state                                                    | Status                                        |
| ---------------------------- | ------------------------------------------------------------------- | --------------------------------------------- |
| Public application hostnames | `cloud.trisektor.org`, `n8n.trisektor.org`, `desktop.trisektor.org` | `CONFIRMED` by service evidence               |
| A records                    | Application hostnames point to the VPS IPv4 and are proxied         | `RECORDED`; live DNS recheck                  |
| SSL/TLS                      | Full (strict)                                                       | `CONFIRMED / RECORDED`                        |
| Always Use HTTPS             | Enabled                                                             | `RECORDED`                                    |
| HSTS                         | `max-age=15552000`, no includeSubDomains/preload                    | `RECORDED`                                    |
| Origin certificate           | Cloudflare Origin CA for `trisektor.org` and wildcard               | `RECORDED`                                    |
| Origin certificate validity  | 2026-09-05 through 2041-09-01                                       | `RECORDED`; do not treat as renewal guarantee |

### 4.2 Cloudflare Zero Trust access layer

**Current state:** Cloudflare Zero Trust is already implemented, according to the owner, for all three public service subdomains:

| Service         | Protected hostname      | Current state                 | Evidence                   |
| --------------- | ----------------------- | ----------------------------- | -------------------------- |
| n8n             | `n8n.trisektor.org`     | Zero Trust protection enabled | Owner-confirmed 2026-09-17 |
| Nextcloud       | `cloud.trisektor.org`   | Zero Trust protection enabled | Owner-confirmed 2026-09-17 |
| Kasm Workspaces | `desktop.trisektor.org` | Zero Trust protection enabled | Owner-confirmed 2026-09-17 |

This owner confirmation supersedes older source documents that described Cloudflare Access/Zero Trust as deferred or not yet configured. It does not, by itself, prove the exact policy, identity-provider, group, session, bypass, device-posture, service-token, webhook, or non-browser-client settings.

Required documentation and acceptance checks:

- Cloudflare Zero Trust application names and hostnames.
- Policy order, decision, identity provider, groups, service tokens, and emergency bypass rules, without recording secret values.
- Session duration, MFA/device posture requirements, and break-glass recovery path.
- n8n webhook behavior and any intentional public webhook bypass.
- Nextcloud desktop/mobile/WebDAV/CalDAV/CardDAV compatibility through the access layer.
- Kasm browser login and websocket/session behavior through the access layer.
- Audit-log retention and alerting for denied or unusual access.

Do not remove, weaken, bypass, or reorder these policies without explicit approval and a tested recovery path. Do not assume that a public HTTP 200 proves Zero Trust enforcement; test an unauthenticated request and an authorized browser flow separately, without exposing credentials.

Non-negotiable rules:

- Never gray-cloud these hostnames while using the Origin CA certificate model.
- Never change Cloudflare TLS from Full (strict) to Flexible.
- Do not bypass Zero Trust for n8n except for a documented, narrowly scoped webhook requirement.
- Do not assume Nextcloud clients work through Zero Trust until desktop/mobile/WebDAV/CalDAV/CardDAV tests are recorded.

### 4.3 Caddy

| Item            | Value                                            | Status                 |
| --------------- | ------------------------------------------------ | ---------------------- |
| Stack directory | `/srv/stack/caddy/`                              | `RECORDED`             |
| Compose file    | `/srv/stack/caddy/compose.yml`                   | `RECORDED`             |
| Caddyfile       | `/srv/stack/caddy/Caddyfile`                     | `RECORDED`             |
| Container       | `caddy`                                          | `CONFIRMED / RECORDED` |
| Public ports    | Host TCP 80/443 and UDP 443                      | `CONFIRMED`            |
| Internal admin  | 2019/tcp                                         | `RECORDED`             |
| TLS mode        | `auto_https off`; explicit Origin CA certificate | `CONFIRMED`            |

Public routes:

- `cloud.trisektor.org` -> `nextcloud:80`
- `n8n.trisektor.org` -> `n8n:5678`
- `desktop.trisektor.org` -> `https://host.docker.internal:8443`

The Kasm upstream must remain `https://host.docker.internal:8443`, not `localhost:8443`. Caddy's `tls_insecure_skip_verify` is limited to this private Caddy-to-Kasm hop because Kasm's internal endpoint uses a self-signed certificate. Public TLS remains Cloudflare/Caddy protected.

Safe Caddy procedure:

```bash
docker exec caddy caddy validate \
  --config /etc/caddy/Caddyfile \
  --adapter caddyfile

# Only after validation succeeds:
docker exec caddy caddy reload \
  --config /etc/caddy/Caddyfile \
  --adapter caddyfile

docker logs --tail=100 caddy
```

Never reload a configuration that failed validation.

---

## 5. Public and Private Service Inventory

### 5.1 Public routes

| Service   | URL                             | Upstream                            | State                                                    |                  Last evidence |
| --------- | ------------------------------- | ----------------------------------- | -------------------------------------------------------- | -----------------------------: |
| Nextcloud | `https://cloud.trisektor.org`   | Nextcloud Apache                    | Previously functional; current maintenance state unknown | 2026-09-09 / 2026-09-17 review |
| n8n       | `https://n8n.trisektor.org`     | `n8n:5678`                          | Route tested; backup/recovery incomplete                 |                     2026-09-09 |
| Kasm      | `https://desktop.trisektor.org` | `https://host.docker.internal:8443` | Public route and admin login tested                      |                     2026-09-16 |

### 5.2 Private services

| Service         | Container/service       | Internal endpoint             | State                                      |
| --------------- | ----------------------- | ----------------------------- | ------------------------------------------ |
| Ollama          | `ollama`                | Docker-internal; no host port | `RECORDED`                                 |
| OmniRoute       | `omniroute-omniroute-1` | `http://omniroute:20128`      | Healthy container; dashboard issue pending |
| OmniRoute Redis | `omniroute-redis-1`     | Docker-internal Redis         | Healthy in latest evidence                 |
| Open WebUI      | `open-webui`            | Internal port 8080            | Deployed; first-run setup pending          |
| VS Code Server  | `vscode-server`         | Internal port 8443            | Deployed; authentication hardening pending |
| Netdata         | Host service            | `127.0.0.1:19999`             | Private SSH-tunnel access                  |
| WireGuard       | Host `wg0`              | UDP 51820                     | IPv4 full tunnel; migration pending        |

### 5.3 Database and application isolation

- MariaDB and Redis are private to Nextcloud's internal network.
- PostgreSQL is private to n8n's internal network and must never join `proxy`.
- n8n and PostgreSQL have no host-published ports.
- AI services must not receive Docker socket, `stack-secrets` group, unrestricted sudo, WireGuard configuration, or Caddy private-key access.

---

## 6. Nextcloud

### 6.1 Deployment state

| Item                | Value                                             | Status                                             |
| ------------------- | ------------------------------------------------- | -------------------------------------------------- |
| URL                 | `https://cloud.trisektor.org`                     | `CONFIRMED` historical functional test             |
| Project             | `/srv/stack/nextcloud/`                           | `RECORDED`                                         |
| Compose             | `/srv/stack/nextcloud/compose.yml`                | `RECORDED`                                         |
| Application         | `nextcloud:apache`                                | `RECORDED`                                         |
| Database            | `mariadb:11.8`, verified 11.8.9 in prior evidence | `RECORDED`                                         |
| Cache/locking       | `redis:7-alpine`                                  | `RECORDED`                                         |
| Background jobs     | Container cron sidecar                            | `RECORDED`; execution recheck                      |
| Application version | 34.0.3 / 34.0.3.2 across records                  | `CONFLICT` minor patch; live `occ status` required |
| Public ports        | None on application/database/cache                | `RECORDED`                                         |

Known configuration:

- `trusted_proxies[0] = 172.18.0.0/16`
- `overwritehost = cloud.trisektor.org`
- `overwriteprotocol = https`
- `overwrite.cli.url = https://cloud.trisektor.org`
- APCu local cache and Redis transactional locking
- MariaDB `utf8mb4` enabled
- Background jobs set to cron

Historical correction: the initial mutable `mariadb:lts` deployment resolved to incompatible MariaDB 12.3.3. It was replaced while fresh with pinned MariaDB 11.8. Do not use `mariadb:lts` or attempt an in-place downgrade.

### 6.2 Verified prior tests

- Browser login/dashboard loaded.
- Cloudflare Full (strict) path worked.
- HTTP redirected to HTTPS.
- HSTS was present.
- CalDAV and CardDAV `.well-known` routes redirected to `/remote.php/dav/`.

### 6.3 Incident and current uncertainty

A 2026-09-12 backup script entered or attempted maintenance mode and stopped without reliable dump/archive/manifest evidence. Later documents disagreed about whether maintenance, repair, quota, and backup work completed. The latest safe state is therefore:

- Current maintenance mode: `UNKNOWN`.
- Current application health: `PENDING` live check.
- Current backup artifact validity: `UNKNOWN`.
- Do not run repair, quota, SMTP, or 2FA changes until `occ status` is captured.

### 6.4 Conflicting completion claims

| Claim                                           | Earlier source claim                                              | Later controlling evidence                                         | Safe current state                                                                    |
| ----------------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| Maintenance window, repair, and quota completed | Older 2026-09-09/13 SSOT revisions                                | 2026-09-12 backup incident and later uncertainty                   | `CONFLICT`; verify with `occ config:system:get`, repair evidence, and quota read-back |
| Nextcloud backup completed                      | Older handoffs describe backup milestones                         | Failed/incomplete 2026-09-12 script with no trusted artifact chain | `CONFLICT`; require valid dump/archive/manifest and restore evidence                  |
| SMTP usable                                     | Brevo setup recorded; port 2525 succeeded while 587/465 timed out | Account-activation response remained unresolved                    | `PENDING`; delivery test required                                                     |

### 6.5 SMTP configuration evidence

Non-secret operational facts from the source records:

- Provider: Brevo SMTP.
- Usable documented port: `2525`.
- Ports `587` and `465` timed out in the recorded testing.
- IP authorization changed the observed error from `525` to `502 5.7.0` account-activation failure.
- A browser save/type-mismatch issue was reported in the Nextcloud SMTP settings flow; use a supported `occ` configuration path if the UI cannot persist values.

Acceptance requires a delivered test message, password-reset test, and a read-back of non-secret SMTP settings. Never record SMTP credentials.

Immediate check:

```bash
docker exec -u www-data nextcloud php occ status
```

Only if output confirms maintenance mode is enabled:

```bash
docker exec -u www-data nextcloud php occ maintenance:mode --off
docker exec -u www-data nextcloud php occ status
```

### 6.6 Pending Nextcloud work

1. Check and resolve maintenance mode.
2. Confirm cron sidecar runs and Overview reports recent jobs.
3. Complete Brevo activation and deliver a test email.
4. Test password reset email.
5. Enable TOTP only after the factor and recovery codes are saved securely.
6. Set maintenance window to 02:00 UTC.
7. Run `maintenance:repair --include-expensive` in a quiet window.
8. Apply and read back the intended 180 GB quota for `leo`.
9. Test browser, desktop, mobile, WebDAV, CalDAV, and CardDAV workflows.
10. Reconfirm database/cache health and current patch versions.

---

## 7. n8n and PostgreSQL

### 7.1 Current documented state

| Item              | Value                                            | Status                               |
| ----------------- | ------------------------------------------------ | ------------------------------------ |
| URL               | `https://n8n.trisektor.org`                      | `CONFIRMED` route test 2026-09-09    |
| Project directory | `/srv/stack/n8n/`                                | `RECORDED`; recheck                  |
| Compose file      | `/srv/stack/n8n/compose.yml`                     | `RECORDED`; recheck                  |
| n8n image         | `n8nio/n8n:latest` at deployment                 | `PENDING` pinning                    |
| Database          | `postgres:16-alpine`                             | `RECORDED`                           |
| Containers        | `n8n-n8n-1`, `n8n-postgres-1`                    | `RECORDED`                           |
| Host ports        | None; n8n 5678 and PostgreSQL 5432 internal only | `RECORDED`                           |
| Encryption key    | Persistent key configured                        | `RECORDED`; independent copy pending |
| Proxy config      | HTTPS public URLs, `N8N_PROXY_HOPS=1`            | `RECORDED`                           |
| Execution pruning | Configured                                       | `RECORDED`                           |

Compose interpolation incident: PostgreSQL initially failed because Compose-time variables are not sourced from a service `env_file`. `/srv/stack/n8n/.env` was added for interpolation, while `/etc/stack-secrets/n8n.env` remains the runtime secret file. Both are secret-bearing and must remain outside Git.

### 7.2 Conflicting completion claims

| Claim                                   | Earlier source claim                                   | Later controlling evidence                                              | Safe current state                                                     |
| --------------------------------------- | ------------------------------------------------------ | ----------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| n8n owner account exists                | 2026-09-09 progress handoff says owner setup completed | Latest master still lists owner setup and credential storage as pending | `CONFLICT`; verify account state without exposing credentials          |
| n8n backups include current data        | Older handoff says backup snapshots were checked       | Latest evidence says post-n8n backup, dump, and restore are unproven    | `CONFLICT`; require current local/R2 path listing and restore evidence |
| n8n encryption-key recovery is complete | Deployment records say a persistent key exists         | Independent password-manager copy is not evidenced                      | `PENDING`; verify existence out-of-band without reading the key        |

### 7.3 Critical pending work

- Confirm `N8N_ENCRYPTION_KEY` has an independent password-manager copy.
- Verify owner/group/mode for `/etc/stack-secrets/n8n.env` and `/srv/stack/n8n/.env`.
- Create a PostgreSQL custom-format dump.
- Validate it with `pg_restore --list`.
- Schedule it only after manual validation.
- Include the dump, n8n data, secrets path, and recovery instructions in local/R2 backup verification.
- Perform a non-destructive restore drill using the exact retained encryption key.
- Create the n8n owner account and record credentials only in the password manager.
- Create a harmless test workflow.
- Test webhook behavior before changing the existing Cloudflare Zero Trust policy or adding any bypass.
- Replace `latest` with a tested immutable version/digest and record rollback.

Safe status checks:

```bash
cd /srv/stack/n8n
docker compose ps
docker compose logs --tail=100 n8n
docker compose logs --tail=100 postgres
curl -sI https://n8n.trisektor.org
```

Do not print `docker compose config` output if it can expose interpolated secrets.

---

## 8. Kasm Workspaces

### 8.1 Current deployment

| Item              | Value                           | Status                               |
| ----------------- | ------------------------------- | ------------------------------------ |
| Public URL        | `https://desktop.trisektor.org` | `CONFIRMED`                          |
| Public path       | Cloudflare -> Caddy -> Kasm     | `CONFIRMED`                          |
| Kasm endpoint     | Host HTTPS port 8443            | `RECORDED / security review pending` |
| Kasm release line | `1.19.0-rolling` images         | `RECORDED`; pin strategy pending     |
| Admin login       | Confirmed working               | `CONFIRMED`, 2026-09-16              |
| Database          | Kasm PostgreSQL container       | `RECORDED`                           |

Containers:

- `kasm_proxy`
- `kasm_rdp_https_gateway`
- `kasm_rdp_gateway`
- `kasm_agent`
- `kasm_api`
- `kasm_manager`
- `kasm_guac`
- `kasm_db`

### 8.2 Verified topology and tests

```text
Browser
  -> Cloudflare
  -> Caddy TCP 443
  -> https://host.docker.internal:8443
  -> Kasm HTTPS endpoint
  -> Kasm proxy/API/manager/gateways/database
```

Verified on 2026-09-16:

- Caddy resolved `host.docker.internal` to the Docker bridge gateway.
- Caddy reached `https://host.docker.internal:8443/` and received HTTP 200.
- Local public-hostname test through Caddy returned HTTP/2 200.
- Public HTTP redirected to HTTPS.
- Kasm administrator login worked.

### 8.3 Kasm operational rules

- Use only `https://desktop.trisektor.org` in normal browser operation.
- Keep Caddy upstream as `https://host.docker.internal:8443`, not localhost.
- Keep `tls_insecure_skip_verify` limited to the private Caddy-to-Kasm hop.
- Validate Caddy before reload.
- Do not rename or assume a nonexistent `kasm` or `kasm_app` container; target `kasm_api` for API/account investigation.
- Verify Kasm database, persistent volumes, image policy, and restore procedure are included in the backup register.

### 8.4 Kasm recovery register

The Kasm source confirms containers and public functionality but does not identify a completed backup or restore drill. Current recovery state is therefore `UNKNOWN`, not accepted as complete.

Before calling Kasm recoverable, record:

- Exact Kasm persistent volume names and bind mounts.
- Kasm PostgreSQL database dump method and retention.
- Installation/configuration artifacts required to recreate the deployment.
- Whether Kasm administrator recovery is possible without the original installation secret.
- A non-production restore target and a successful login/session acceptance test.
- Tested image tags or digests and rollback images for all Kasm components.

Do not infer volume names from container names. Obtain them with read-only `docker inspect` and record only names/paths, never environment values.

Routine checks:

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' | grep kasm
docker exec caddy sh -c 'wget -qSO- --no-check-certificate https://host.docker.internal:8443/ 2>&1 | head -n 10'
curl -vk --resolve desktop.trisektor.org:443:127.0.0.1 https://desktop.trisektor.org/ -o /dev/null
docker logs --since=10m kasm_proxy
docker logs --since=10m kasm_api
docker logs --since=10m kasm_manager
```

---

## 9. Ollama, OmniRoute, Open WebUI, VS Code, and Claude CLI

### 9.1 AI privacy routing policy

| Data class                                              | Approved route        | Prohibited route              |
| ------------------------------------------------------- | --------------------- | ----------------------------- |
| VPS administration, secrets, keys, passwords, VPN, logs | Local Ollama only     | OmniRoute/cloud providers     |
| Nextcloud content and private business data             | Local Ollama only     | OmniRoute/cloud providers     |
| Private n8n workflows/credentials                       | Local Ollama only     | OmniRoute/cloud providers     |
| Deliberately non-sensitive coding/general tasks         | OmniRoute if approved | No unreviewed sensitive input |

### 9.2 Ollama

| Item         | Value                                              | Status                 |
| ------------ | -------------------------------------------------- | ---------------------- |
| Image        | `ollama/ollama:latest`                             | `PENDING` pinning      |
| Exposure     | No host-published port                             | `RECORDED`             |
| Models       | `qwen3.5:9b`, `qwen3.5:4b`, `qwen3-embedding:0.6b` | `RECORDED`, 2026-09-11 |
| Intended use | Sensitive/private local workloads                  | `CONFIRMED design`     |

Recheck current model list and volume before claiming model availability.

The privacy boundary is currently policy-based, not technically enforced end-to-end. Open WebUI and VS Code are connected to an outbound-capable network, so a user or agent can still select an inappropriate route unless authentication, UI defaults, network policy, and data classification controls are reviewed. Treat the local Ollama-only rule as mandatory operator policy until technical controls prove otherwise.

### 9.3 OmniRoute

| Item               | Value                                                            | Status                                     |
| ------------------ | ---------------------------------------------------------------- | ------------------------------------------ |
| Container          | `omniroute-omniroute-1`                                          | `CONFIRMED` 2026-09-17                     |
| Image              | `diegosouzapw/omniroute:3.8.50`                                  | `CONFIRMED`                                |
| Internal port      | `20128/tcp`                                                      | `CONFIRMED`                                |
| Host port          | None; `PortBindings={}`                                          | `CONFIRMED`                                |
| Health             | Docker health reported healthy                                   | `CONFIRMED`; application health still test |
| Networks           | `ai_egress`, `omni_clients`                                      | `CONFIRMED attachment`                     |
| Redis              | `omniroute-redis-1`, `redis:7-alpine`                            | `CONFIRMED healthy` in latest evidence     |
| Runtime            | Production mode, Redis URL, port 20128, memory settings          | `CONFIRMED` without secret values          |
| Gateway model test | `leo-one-free` returned `claude-sonnet-4.5`                      | `RECORDED`                                 |
| Dashboard          | `Server is unreachable. Reconnecting...` reported                | `PENDING` diagnosis                        |
| Compose path       | Historical `/srv/stack/omniroute/`; not reverified on 2026-09-17 | `UNKNOWN`                                  |

Correct internal health check. This is a disposable container operation, not a purely read-only host check: it may pull an image and changes local Docker state. Obtain approval first, or use an already trusted diagnostic container. If this command is retained operationally, pin `curlimages/curl` by a reviewed digest rather than a mutable tag:

```bash
docker run --rm --network ai_egress curlimages/curl:8.10.1 \
  -fsS --max-time 10 http://omniroute:20128/healthz
```

Do not test `127.0.0.1:20128` on the VPS host because no host port is published. Do not hard-code the historical container IPs `172.22.0.2` or `172.26.0.2`.

Pending OmniRoute work:

1. Locate and verify the actual live Compose file under `/srv`, `/opt`, or another approved path.
2. Run `/healthz` from each intended network.
3. Inspect container logs, restart count, OOM state, and dashboard API/WebSocket path.
4. Verify whether the dashboard expects a browser-accessible tunnel or a different base URL.
5. Review and potentially rotate the WebSocket bridge secret if prior terminal/session exposure is confirmed.
6. Record the exact known-good image digest and rollback image.

### 9.4 Open WebUI

Open WebUI is deployed privately on the outbound-capable AI network and is intended to use OmniRoute at `http://omniroute:20128/v1` for non-sensitive work and explicit Ollama selection for sensitive work.

Status: first-run administrator setup, authentication, and final route tests are `PENDING`. Do not claim an operational AI interface until login and one safe route test succeed.

### 9.5 VS Code Server

VS Code Server (`linuxserver/code-server`) is private and recorded on `dev_internal` and `ai_egress`. Its OmniRoute route was tested, but prior evidence reported authentication disabled and HTTPS disabled.

The source records also describe a narrow `/srv/workspaces` workspace mount; the exact current mount and write permissions require live verification. Status: `PENDING` application authentication, HTTPS/session protection, mount scope, and access-boundary review. Do not expose it publicly or assume container/network privacy replaces application authentication.

### 9.6 Claude CLI

Claude CLI was built and reaches the OmniRoute path, but provider authentication returned:

```text
401 No active credentials for provider: anthropic
```

Status: not operationally accepted. Resolve credentials through the approved secret mechanism; never paste credentials into this document or command history. Run only a harmless test request after resolution.

---

## 10. WireGuard VPN

| Item               | Value                        | Status                     |
| ------------------ | ---------------------------- | -------------------------- |
| Interface          | `wg0`                        | `RECORDED`                 |
| Port               | UDP 51820                    | `RECORDED`                 |
| VPN network        | `10.77.77.0/24`              | `RECORDED`; sensitive      |
| Server VPN address | `10.77.77.1/24`              | `RECORDED`                 |
| Routing            | IPv4 full tunnel `0.0.0.0/0` | `CONFIRMED design`         |
| IPv6 full tunnel   | Not configured               | `DEFERRED`                 |
| DNS                | `1.1.1.1`                    | `RECORDED`                 |
| Keepalive          | 15s                          | `RECORDED`                 |
| Configuration      | `/etc/wireguard/wg0.conf`    | `RECORDED`, secret-bearing |

Standard WireGuard is deployed. AmneziaWG was earlier planning and is superseded.

Replacement profile set created 2026-09-07:

- `leo-one-mac` -> `10.77.77.7/32`
- `leo-one-android` -> `10.77.77.8/32`
- `leo-one-iphone` -> `10.77.77.9/32`
- `leo-one-moto` -> `10.77.77.10/32`
- `leo-one-windows` -> `10.77.77.11/32`

Older profile mapping:

- `android-leo` -> `10.77.77.2/32`, working on mobile data in prior evidence.
- `mac-leo` -> `10.77.77.3/32`, handshake and IPv4 full tunnel verified in prior evidence.
- `windows-leo` -> `10.77.77.4/32`, profile existed; client test was pending in prior evidence.
- `iphone-leo` -> `10.77.77.5/32`, connected in prior evidence.
- `moto-leo` -> `10.77.77.6/32`, connected in prior evidence.

The replacement peers were visible server-side with correct `/32` addresses but had no handshake until imported/activated. Migration was staged with a target of approximately 2026-09-21; completion and old-peer retirement remain `PENDING`.

Migration rules:

- Migrate one device at a time.
- Never run old and replacement full-tunnel profiles concurrently on one device.
- Verify handshake and exit IP `89.58.63.213` after each device.
- Remove old peers only after every replacement device is confirmed.
- Never share private keys, full profiles, or `wg0.conf`.
- Do not add `::/0` until IPv6 forwarding, addressing, and firewall policy are deliberately designed.

Safe peer reload:

```bash
sudo wg-quick strip wg0 | sudo tee /tmp/wg0-stripped.conf >/dev/null
sudo wg syncconf wg0 /tmp/wg0-stripped.conf
sudo rm -f /tmp/wg0-stripped.conf
sudo wg show wg0
```

Backup coverage for `/etc/wireguard/` is not proven and is a critical backup gap.

---

## 11. Monitoring and Observability

### Netdata

| Item                        | Value                                        | Status           |
| --------------------------- | -------------------------------------------- | ---------------- |
| Version                     | 2.11.0                                       | `RECORDED`       |
| Bind address                | `127.0.0.1:19999`                            | `RECORDED`       |
| Access                      | SSH tunnel                                   | `RECORDED`       |
| Database collector warnings | Observed; not confirmed as database failures | `PENDING` review |
| Alerting                    | No protected notification design accepted    | `PENDING`        |

Do not expose Netdata publicly before authentication, TLS, access control, and notification boundaries are reviewed.

### Telemetry listener discrepancy

Ports 4317 and 8125 appeared in a 2026-09-17 host listener observation. Ownership, bind address, firewall treatment, and necessity are `UNKNOWN`. Map them before changing firewall or service configuration.

### Private SSH access runbook

SSH tunnels are the approved access method for private dashboards and services. Do not publish private service ports as a shortcut.

Netdata tunnel pattern from a trusted workstation:

```bash
ssh -N -L 19999:127.0.0.1:19999 leo-one
```

For OmniRoute, discover the current container IP dynamically and never persist it:

```bash
OMNI_IP=$(ssh leo-one "docker inspect omniroute-omniroute-1 --format '{{with index .NetworkSettings.Networks \"ai_egress\"}}{{.IPAddress}}{{end}}'")
test -n "$OMNI_IP"
ssh -N -L "20128:${OMNI_IP}:20128" leo-one
```

Verify a tunnel locally before using it, keep the SSH session visible, and close it when finished. Container IPs are ephemeral. The SSH alias, user, port, key location, and recovery access are intentionally not recorded here.

---

## 12. Backup and Recovery

### 12.1 Documented baseline

Local and Cloudflare R2 Restic backup baseline was completed and restore-tested on 2026-09-09 before later AI/Kasm additions were fully incorporated.

| Backup              | Location                           | Schedule                                   | Status                                      |
| ------------------- | ---------------------------------- | ------------------------------------------ | ------------------------------------------- |
| Local Restic        | `/srv/stack/backups/restic`        | Daily 02:00 UTC                            | Baseline verified; current coverage pending |
| R2 Restic           | Cloudflare R2 bucket `cupnet-leo1` | Monday/Thursday 03:30 UTC                  | Baseline verified; current coverage pending |
| PostgreSQL n8n dump | `/srv/stack/backups/n8n-postgres`  | Proposed 01:30 UTC                         | Not proven complete                         |
| Provider snapshot   | netcup control panel               | One snapshot remained in 2026-09-04 record | Recheck                                     |

Documented backup scope includes `/srv/stack/`, `/etc/stack-secrets/`, and `/home/leo/`, but the following current coverage is not proven:

- `/etc/wireguard/`
- Kasm volumes/database
- Ollama model volume
- OmniRoute data volume and Redis state
- Open WebUI state
- VS Code Server state
- Netdata state
- `/srv/workspaces`
- n8n PostgreSQL dump and exact encryption key recovery path

### 12.2 Backup safety rules

- Never print passwords or secret file contents.
- Never assume a successful backup command means a restorable backup.
- Verify snapshot creation, path inclusion, repository integrity, and an actual restore.
- Keep local and off-site repositories independent.
- Test restoration into a non-production target.
- Do not delete production volumes during backup troubleshooting.
- Treat the Restic password and n8n encryption key as separate critical recovery materials.

### 12.3 Required backup completion chain

1. Verify secret file ownership and modes.
2. Create the n8n logical dump and validate with `pg_restore --list`.
3. Run local backup.
4. Run R2 backup.
5. List latest snapshots without printing secret contents.
6. Confirm current n8n, AI, Kasm, WireGuard, secret, and persistent-volume paths are included.
7. Run `restic check` for both repositories.
8. Restore a harmless representative file from each repository.
9. Perform a controlled application restore drill for n8n and Kasm.
10. Record exact evidence, timestamp, retention result, and rollback assumptions here.

### 12.4 n8n dump runbook

The intended dump location is `/srv/stack/backups/n8n-postgres`, root-only mode 0700. The intended process is:

```bash
sudo install -d -o root -g root -m 0700 /srv/stack/backups/n8n-postgres
sudo /usr/local/sbin/n8n-postgres-backup

latest_dump=$(sudo find /srv/stack/backups/n8n-postgres -maxdepth 1 \
  -type f -name 'n8n-*.dump' -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)

sudo bash -ceu '
  set -o pipefail
  latest_dump=$(find /srv/stack/backups/n8n-postgres -maxdepth 1 \
    -type f -name "n8n-*.dump" -printf "%T@ %p\\n" | sort -n | tail -1 | cut -d" " -f2-)
  test -n "$latest_dump"
  test -r "$latest_dump"
  docker compose --project-directory /srv/stack/n8n \
    -f /srv/stack/n8n/compose.yml exec -T postgres \
    pg_restore --list < "$latest_dump" > /tmp/n8n-pg-restore-list.txt
  test -s /tmp/n8n-pg-restore-list.txt
  sed -n "1,20p" /tmp/n8n-pg-restore-list.txt
  rm -f /tmp/n8n-pg-restore-list.txt
'
```

The entire validation runs with root access because the dump directory is root-only. `pipefail`, non-empty-file checks, and `pg_restore` exit status prevent truncated output from being mistaken for validation. Do not schedule recurring dumps until the manual dump and validation succeed.

---

## 13. Security Posture and Hardening

### Current controls

- UFW default incoming deny is documented.
- Cloudflare proxy and Full (strict) TLS are documented.
- Cloudflare Zero Trust protection is owner-confirmed for n8n, Nextcloud, and Kasm subdomains.
- Origin CA certificate is used explicitly by Caddy.
- Database services are intended to be internal-only.
- AI services are intended to be private and not publicly routed.
- Secrets are stored outside Git in restricted paths.
- WireGuard provides an IPv4 full-tunnel option.

### Security gaps requiring action

1. Explain or close unexpected listeners 3389, 8443, 4317, and 8125.
2. Review SSH keys-only access and root-login policy without losing console/SSH recovery.
3. Verify `leo` group membership and ensure no untrusted agent has Docker/socket/secrets access.
4. Enable VS Code Server application authentication.
5. Review OmniRoute dashboard bridge authentication and possible secret exposure.
6. Pin floating container images to tested immutable digests.
7. Define Kasm upgrade and rollback policy.
8. Design origin protection only after recovery and backups are verified.
9. Document and independently test the already-enabled Cloudflare Zero Trust policies, including n8n webhooks and Nextcloud/Kasm client behavior.
10. Define protected Netdata alerting without leaking infrastructure data.

### Hardening explicitly deferred

- Cloudflare IP allowlisting, Authenticated Origin Pulls, or Cloudflare Tunnel migration.
- Removing, weakening, or bypassing the already-enabled Cloudflare Zero Trust policies.
- IPv6 WireGuard full tunnel.
- Hermes deployment.
- Any AI agent Docker group, Docker socket, unrestricted sudo, secrets group, VPN configuration, or Caddy key access.

---

## 14. Completed Processes and Evidence Ledger

This section records what was done, not only the resulting state.

|       Date | Process                                           | Result                                                                                                   | Evidence status                                                    |
| ---------: | ------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| 2026-09-04 | Provider/hardware baseline captured               | Hardware, IP, hostname candidates, and snapshot count recorded                                           | `RECORDED`                                                         |
| 2026-09-05 | Cloudflare Origin CA planning/certificate setup   | Full (strict) origin model established                                                                   | `RECORDED`                                                         |
| 2026-09-07 | Replacement WireGuard profiles created and staged | Five replacement profiles created                                                                        | `RECORDED`; migration incomplete                                   |
| 2026-09-09 | MariaDB compatibility correction                  | Mutable `mariadb:lts` replaced with MariaDB 11.8 while fresh                                             | `RECORDED`                                                         |
| 2026-09-09 | n8n/PostgreSQL deployment                         | PostgreSQL interpolation issue fixed using Compose `.env`; n8n started                                   | `RECORDED`                                                         |
| 2026-09-09 | Caddy n8n route correction                        | Temporary response replaced with `reverse_proxy n8n:5678`                                                | `CONFIRMED` route test                                             |
| 2026-09-09 | Local Restic baseline                             | Repository initialized, backup and restore tested                                                        | `RECORDED`; scope now stale/incomplete                             |
| 2026-09-09 | Cloudflare R2 Restic baseline                     | R2 repository initialized, upload/check/restore tested                                                   | `RECORDED`; current scope now stale/incomplete                     |
| 2026-09-10 | OmniRoute and Redis deployment                    | AI gateway and Redis deployed                                                                            | `RECORDED`                                                         |
| 2026-09-10 | AI egress diagnosis                               | Internal-only AI network lacked egress; `ai_egress` approach adopted                                     | `RECORDED`                                                         |
| 2026-09-11 | Ollama guardrails/models                          | Qwen models installed/tested for local route                                                             | `RECORDED`                                                         |
| 2026-09-12 | Nextcloud backup attempt                          | Script entered/attempted maintenance and stopped without trusted artifacts                               | `CONFIRMED incident`; resolution pending                           |
| 2026-09-13 | Brevo SMTP setup                                  | IP authorization issue cleared; activation/delivery remained pending                                     | `RECORDED`                                                         |
| 2026-09-13 | Open WebUI and VS Code deployment                 | Private services deployed and routes configured                                                          | `RECORDED`; acceptance incomplete                                  |
| 2026-09-13 | OmniRoute combo/client setup                      | Combo and client-key labels created; route tested                                                        | `RECORDED`; secret values omitted                                  |
| 2026-09-13 | Netdata installation                              | Loopback monitoring with SSH access tested                                                               | `RECORDED`                                                         |
| 2026-09-16 | Kasm route and TLS path                           | Caddy-to-Kasm and public hostname returned 200                                                           | `CONFIRMED`                                                        |
| 2026-09-16 | Kasm administrator login                          | Login confirmed                                                                                          | `CONFIRMED`                                                        |
| 2026-09-17 | OmniRoute live Docker inspection                  | Healthy container, networks, no host port, runtime details recorded                                      | `CONFIRMED`                                                        |
| 2026-09-17 | AI network design documentation                   | `ai_egress` and `omni_clients` roles documented                                                          | `CONFIRMED design`; policy validation pending                      |
| 2026-09-17 | Cloudflare Zero Trust protection                  | Owner confirmed policies protect `n8n.trisektor.org`, `cloud.trisektor.org`, and `desktop.trisektor.org` | `OWNER-CONFIRMED`; exact policies and client/webhook tests pending |

### Process acceptance language

A process is not complete merely because a command was run. Mark it complete only when:

- The expected artifact exists.
- The artifact is validated.
- The service behavior is tested.
- Security boundaries are checked.
- Recovery/rollback is documented.
- Evidence is dated and recorded here.

---

## 15. Chronological Evolution

- **2026-09-04:** Infrastructure capture; provider and hardware baseline created.
- **2026-09-05:** Early planning and Cloudflare/Nextcloud stack work.
- **2026-09-07:** New standard-WireGuard peer profile set created; AmneziaWG planning superseded.
- **2026-09-09:** MariaDB version corrected; n8n/PostgreSQL deployed; Caddy n8n route finalized; local and R2 Restic baseline verified before later service additions.
- **2026-09-10:** OmniRoute/Redis deployed; AI egress issue diagnosed and network architecture changed.
- **2026-09-11:** Local Ollama Qwen models and privacy-routing guardrails recorded.
- **2026-09-12:** Nextcloud backup script incident created current maintenance/backup uncertainty.
- **2026-09-13:** SMTP setup, Open WebUI, VS Code, OmniRoute combo, and Netdata progressed; acceptance remained incomplete in later evidence.
- **2026-09-16:** Kasm public route, private TLS hop, and administrator login verified.
- **2026-09-17:** OmniRoute live inspection confirmed healthy/no host port and documented AI network intent; dashboard and backup/security gaps remained.
- **2026-09-17:** Owner confirmed Cloudflare Zero Trust is already enabled for n8n, Nextcloud, and Kasm at their subdomains; policy details and service-specific compatibility evidence remain to be recorded.

---

## 16. Master Task Register

### Critical: perform before broad upgrades or hardening

- [ ] Check Nextcloud `occ status`; resolve maintenance mode safely.
- [ ] Map unexpected host listeners 3389, 8443, 4317, and 8125 to intended services and UFW rules.
- [ ] Verify n8n encryption key independently stored in the password manager.
- [ ] Verify n8n secret file ownership and modes.
- [ ] Create and validate the n8n PostgreSQL dump.
- [ ] Verify local and R2 backups include n8n, AI, Kasm, WireGuard, secrets, and persistent volumes.
- [ ] Run Restic integrity checks and representative restores.
- [ ] Verify `/etc/wireguard/` backup coverage.
- [ ] Confirm a Kasm database/application restore procedure.

### High: complete next

- [ ] Diagnose OmniRoute dashboard reconnecting banner through internal health/API/WebSocket tests.
- [ ] Locate and record the actual OmniRoute Compose project path.
- [ ] Complete n8n restore drill and owner account setup.
- [ ] Complete Brevo activation and delivered Nextcloud email test.
- [ ] Test password reset, then enable Nextcloud TOTP and secure recovery codes.
- [ ] Verify Nextcloud cron, maintenance window, repair, quota, and client workflows.
- [ ] Enable VS Code Server authentication.
- [ ] Complete Open WebUI administrator setup and one safe OmniRoute/Ollama route test.
- [ ] Resolve Claude CLI provider authentication and run one harmless request.
- [ ] Complete WireGuard replacement migration; remove old peers only after proof.
- [ ] Record and independently test Cloudflare Zero Trust policies for n8n, Nextcloud, and Kasm, including webhooks and non-browser clients.

### Medium: controlled maintenance

- [ ] Pin `latest` and rolling images to tested immutable digests, with rollback records.
- [ ] Document one-stack-at-a-time upgrade procedure.
- [ ] Review Netdata collector warnings without deleting state.
- [ ] Add protected Netdata alerting.
- [ ] Add Kasm, AI volumes, and model storage to the backup register.
- [ ] Review SSH hardening and recovery path.
- [ ] Review Docker group and agent isolation.

### Deferred by design

- [ ] Origin IP protection via Cloudflare ranges, AOP, or Tunnel.
- [ ] Removing or bypassing the existing Cloudflare Zero Trust protection without an approved recovery plan.
- [ ] IPv6 WireGuard full-tunnel routing.
- [ ] OmniRoute public exposure.
- [ ] Hermes agent deployment.
- [ ] Any agent access to Docker socket, Docker group, `stack-secrets`, WireGuard, unrestricted sudo, or Caddy keys.

---

## 17. Maintenance Runbook

### Daily or on every operational session

```bash
hostnamectl
uptime
free -h
df -hT
sudo ufw status verbose
sudo ss -lntup
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
```

Review unexpected changes, unhealthy containers, storage below the 80–100 GiB safety reserve, and newly exposed ports.

Service-specific acceptance checks, when the relevant service is enabled:

```bash
docker exec -u www-data nextcloud php occ status
docker compose -f /srv/stack/n8n/compose.yml ps
docker ps --format '{{.Names}} {{.Status}}' | grep -E 'kasm|ollama|omniroute|open-webui|vscode' || true
sudo wg show wg0
sudo restic --repo /srv/stack/backups/restic \
  --password-file /etc/stack-secrets/restic-password.txt snapshots
```

For private AI checks, use an approved existing diagnostic container or the explicitly approved disposable check in §9.3. For backups, never print password files or environment files. A container being `Up`, an HTTP 200, or a Docker health result does not prove authentication, database integrity, backup recoverability, or user-level acceptance.

### Before any service change

1. Read this file and identify current evidence date.
2. Confirm the affected Compose project and volumes.
3. Check recent backups and restore viability.
4. Capture read-only status and logs.
5. Define rollback and maintenance window.
6. Change one stack at a time.
7. Validate configuration before reload.
8. Test public and private paths.
9. Record versions, digests, result, and rollback in this file.

### After any service change

```bash
docker ps
docker compose ps
docker logs --tail=100 <changed-service>
curl -sI https://cloud.trisektor.org
curl -sI https://n8n.trisektor.org
curl -sI https://desktop.trisektor.org
```

Use service-specific tests instead of assuming HTTP 200 proves database, authentication, backup, or workflow health.

### Upgrade policy

- No blind `docker compose pull && docker compose up -d`.
- Record current image tags/digests and rollback images first.
- Review release notes and compatibility.
- Back up and verify restore path.
- Upgrade one stack at a time.
- Run health checks and user-level tests.
- Keep the previous known-good image available until acceptance is complete.

### Scheduled maintenance areas

The following operational processes are not yet evidenced as complete and must be assigned a cadence and owner before being considered enterprise-ready:

- Host security updates and reboot/kernel maintenance.
- Docker Engine and Compose updates, including daemon configuration backup.
- Time synchronization and clock-drift monitoring.
- SSH key/access review and removal of stale access.
- Secret, certificate, SMTP, provider-key, and WireGuard rotation procedures.
- Certificate-expiry and Cloudflare Origin CA renewal tracking.
- DNS change review and rollback.
- Backup retention review and periodic restore drills.
- Incident response, service outage records, and post-incident review.
- Resource capacity review for CPU, RAM, storage, Docker logs, databases, and model volumes.
- Recovery objectives: RPO/RTO values remain `UNKNOWN` and must be agreed before claiming disaster-recovery readiness.

---

## 18. Recovery Rules

- Never delete Docker named volumes during troubleshooting.
- Never restore against the live production database without a deliberate, confirmed restore plan.
- Stop the affected application before database restore.
- Preserve the exact n8n encryption key for credential decryption.
- Confirm target and destination before any restore.
- Keep console/SSH recovery available before firewall/origin hardening.
- Keep Cloudflare Full (strict) and Origin CA paths aligned.
- Do not rotate keys, certificates, VPN profiles, or secrets without a tested migration/rollback.
- If an AI recommendation conflicts with this file, stop and request live evidence rather than choosing by assumption.

---

## 19. Source Provenance and Supersession

The consolidation reviewed all substantive files in the local `_inbox/` at the time of merge:

- `VPS-CUPNET-SSOT-MASTER-2026-09-17-v2.2.md` — latest general SSOT; primary baseline.
- `VPS-CUPNET-SSOT-MASTER-2026-09-17-v2.1.md` — superseded by v2.2.
- `VPS-CUPNET-SSOT-MASTER-2026-09-13.md` — prior v2.0 master.
- `VPS-CUPNET-SUPER-SINGLE-SOURCE-OF-TRUTH-2026-09-13-v1.6-verified-full.md` — prior verified full successor.
- `VPS-CUPNET-SUPER-SINGLE-SOURCE-OF-TRUTH-2026-09-13-v1.2-full (1).md` — historical full successor.
- `VPS-CUPNET-SUPER-SINGLE-SOURCE-OF-TRUTH-2026-09-13-v1.1-full.md` — historical predecessor.
- `VPS-CUPNET-SUPER-SINGLE-SOURCE-OF-TRUTH-2026-09-12.md` — original exhaustive SSOT.
- `kasm-installation-ssot (1).md` — Kasm-specific authority, last verified 2026-09-16; merged into §8.
- `cupnet-leo1-handoff-claude.md` — 2026-09-09 handoff; historical baseline.
- `cupnet-leo1-handoff-Perplexity.md` — 2026-09-09 handoff; historical baseline.
- `cupnet-leo1-handoff-Perplexity-updated.md` — 2026-09-09 progress update; claims requiring later verification were not blindly accepted.
- `cupnet-leo1-handoff-Perplexity-updated (AI Model Added).md` — 2026-09-09 AI model addendum; historical model evidence.
- `leo-one-cupnet-server-details.md` — 2026-09-04 provider/server-details capture; infrastructure provenance only.

Supersession rules:

- This file supersedes all source handoffs for current state.
- Kasm-specific facts were merged from its dedicated document and are no longer omitted from the general SSOT.
- Older documents remain useful as evidence of completed processes and historical decisions, not as current state.
- The source documents remain local in `_inbox/` and are ignored by Git.

### 19.1 Claim-level conflict register

| Claim                                               | Conflicting or supporting sources                                                     | Controlling evidence                                                             | Current status              | Required AI behavior                                                 |
| --------------------------------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | --------------------------- | -------------------------------------------------------------------- |
| Nextcloud maintenance/repair/quota complete         | Older 2026-09-09/13 masters vs failed 2026-09-12 backup attempt                       | Fresh `occ status`, config read-back, repair output                              | `CONFLICT`                  | Do not repeat or assume completion                                   |
| Nextcloud backup complete                           | Older handoffs vs later missing artifact chain                                        | Snapshot listing, repository check, restore                                      | `CONFLICT`                  | Treat as unverified                                                  |
| n8n owner and backup complete                       | 2026-09-09 progress handoff vs v2.2 pending register                                  | Current account check, dump, snapshot, restore                                   | `CONFLICT`                  | Do not claim operational acceptance                                  |
| Kasm public route works                             | Kasm SSOT dated 2026-09-16                                                            | Caddy-to-Kasm and local hostname HTTP 200 tests                                  | `CONFIRMED`, evidence dated | Preserve upstream and TLS exception                                  |
| TCP 8443 is acceptable exposure                     | Kasm requires host endpoint vs UFW/listener ambiguity                                 | Live bind, Docker mapping, UFW behavior, recovery path                           | `CONFLICT`                  | Do not open/close blindly                                            |
| UDP 443 is allowed                                  | Caddy supports UDP 443 vs older UFW matrix omitted it                                 | Live UFW and UDP listener checks                                                 | `UNKNOWN`                   | Verify QUIC policy                                                   |
| OmniRoute is operational                            | Docker health/model test vs dashboard reconnecting banner                             | Internal `/healthz`, dashboard API/WebSocket test                                | `CONFLICT`                  | Do not equate container health with app acceptance                   |
| Zero Trust is enabled for the three public services | Older source documents marked Access deferred; owner confirmed current implementation | Cloudflare dashboard policy export plus unauthenticated/authorized service tests | `OWNER-CONFIRMED`           | Treat protection as enabled; do not infer policy details or bypasses |
| AI privacy boundary is enforced                     | Policy says local-only sensitive data vs outbound-capable clients                     | Auth, route defaults, network policy, and test evidence                          | `PENDING`                   | Treat as mandatory policy, not technical proof                       |
| WireGuard migration complete                        | Replacement peers staged vs no documented final device handshakes                     | Per-device handshake and exit-IP evidence                                        | `PENDING`                   | Do not remove old peers                                              |
| All persistent services are recoverable             | Pre-AI Restic/R2 tests vs later services                                              | Current path listing and application restore drills                              | `PENDING`                   | Do not claim disaster recovery readiness                             |

For every future conflict, add a row here before changing the dashboard or task register. A conflict is resolved only by fresh evidence, not by choosing the newest prose document.

---

## 20. Change Record

|       Date | Change                                             | Evidence                                                                | Result / follow-up                                             |
| ---------: | -------------------------------------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------------- |
| 2026-09-17 | Consolidated 13 substantive source documents       | Local `_inbox` review; v2.2 primary plus Kasm SSOT                      | This document became canonical v3.0                            |
| 2026-09-17 | Added Kasm to general service topology             | Kasm SSOT, last verified 2026-09-16                                     | Public route and admin login recorded; backup coverage pending |
| 2026-09-17 | Preserved unresolved exposure discrepancy          | v2.2 listener observation vs UFW expected ports                         | Map 3389/8443/4317/8125 before changing firewall               |
| 2026-09-17 | Preserved Nextcloud maintenance/backup uncertainty | Failed 2026-09-12 backup attempt and conflicting later claims           | Check `occ status` before further work                         |
| 2026-09-17 | Preserved OmniRoute dashboard issue                | Live container health vs reconnecting dashboard                         | Run internal health/API/WebSocket diagnosis                    |
| 2026-09-17 | Preserved backup scope gap                         | Baseline predates later n8n/AI/Kasm additions                           | Verify coverage and restore for every persistent service       |
| 2026-09-17 | Established AI anti-hallucination contract         | Consolidation policy                                                    | Use evidence labels and required response format               |
| 2026-09-17 | Updated canonical state to v3.1                    | Owner confirmation of Cloudflare Zero Trust on n8n, Nextcloud, and Kasm | Record policy details; test webhooks and non-browser clients   |

### Future entry format

```markdown
| YYYY-MM-DD | Material change | Command/test/source evidence | Result, residual risk, and rollback |
```

Every future update must also revise the affected dashboard row, task checkbox, evidence date, and source provenance where relevant.

---

## 21. Final Operational Position

The VPS is a functioning multi-service Docker platform with public Cloudflare/Caddy routes for Nextcloud, n8n, and Kasm; private local and gateway-based AI services; WireGuard; and an established but now incomplete backup baseline. The platform must not be treated as enterprise-ready for unattended change until the following are closed:

1. Unexpected host listeners are mapped and intentionally controlled.
2. Nextcloud maintenance mode and application health are live-verified.
3. n8n dumps, encryption-key recovery, and restore are tested.
4. Current backups include n8n, AI, Kasm, WireGuard, secrets, and persistent volumes.
5. OmniRoute dashboard and internal health behavior are diagnosed.
6. VS Code/Open WebUI/Claude authentication acceptance is complete.
7. WireGuard migration is completed safely.
8. Image pinning, rollback, SSH hardening, and monitoring alerting are implemented with recovery paths.

Until then, use this document for informed planning and controlled maintenance, not for autonomous production changes.

**End of canonical SSOT.**
