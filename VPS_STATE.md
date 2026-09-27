# VPS-CUPNET / Leo One

## Enterprise Operational Single Source of Truth

**Document status:** Updated reconciliation baseline  
**Document version:** 3.12-agent-reference
**Last updated:** 2026-09-27
**Primary evidence cutoff:** 2026-09-27 04:22 UTC, including the latest host/container/network inventory, Kasm TCP 3389 removal, OpenClaw runtime mapping, and Hermes deployment evidence through 2026-09-26
**Reconciliation inputs:** Local source notes `_inbox/VPS-Key-Baseline-Information (5).md` (inventory through 2026-09-27 ~04:22 UTC) and `_inbox/hermes_ssot_progress.md` (Hermes through 2026-09-26), plus the versioned tunnel runbook `_inbox/leo-one-tunnels-recreation.md`. The first two notes are Git-ignored and may be absent in another clone; their reconciled facts are recorded below.
**Owner:** Leo  
**Provider:** netcup / Cupnet  
**Classification:** Private internal operations document  
**Canonical file:** `VPS_STATE.md`

> This document consolidates prior verified evidence and the 2026-09-27 live baseline. It is the operational authority for AI clients and operators. Do not create parallel handoff files. Update this file and its Change Record after every material change.

### 0.0 Agent navigation map

Use this routing order when answering operational questions:

1. Current facts and service status: **Sections 1-6** and the **single-file verification tracker** in Section 0.5.
2. Service-specific evidence and safe commands: **Sections 7-13**; OpenClaw is in **Section 9.6**.
3. Cross-service risks and unresolved claims: **Sections 14-15**.
4. Pending work: **Section 16**, which is the task register.
5. Material changes and evidence lineage: **Section 17**, the Change Record.
6. Recovery constraints: **Section 18**; final qualified position: **Section 19**.

Generated inventory snapshots are inputs, not replacements for this curated SSOT; see Section 0.6. The dashboard is a summary, not proof. For any risky action, follow the authority order below and inspect the service-specific evidence, conflict register, and task register before proposing a change.

---

## 0. AI operating contract

### 0.1 Evidence labels

| Label | Meaning | AI behavior |
|---|---|---|
| `CONFIRMED` | Directly observed or successfully tested with dated evidence | May be used as current state, subject to evidence date |
| `OWNER-CONFIRMED` | Directly asserted by the owner as current but not independently exported or fully tested | Use as owner input; do not invent policy details; schedule independent verification |
| `RECORDED` | Supported by an authoritative document but not rechecked in the latest session | Use with the stated date; recommend rechecking before risky action |
| `PENDING` | Required work is known but completion is not demonstrated | Never claim complete |
| `DEFERRED` | Intentionally postponed by design | Do not implement without a new decision |
| `HISTORICAL` | Superseded by later evidence | Context only; never use as current state |
| `UNKNOWN` | No reliable evidence available | Do not infer; request a targeted check |
| `CONFLICT` | Sources disagree and no live evidence resolves the disagreement | Preserve both claims and require verification |
| `FAILED` | Evidence shows a control or acceptance requirement is not satisfied | Record remediation and do not claim acceptance |

### 0.2 Authority order

When sources conflict, use this order:

1. Fresh direct live command output from the VPS.
2. Latest dated verified operational evidence.
3. Latest dated consolidated SSOT.
4. Older handoffs and planning documents.
5. Generic assumptions or vendor defaults are never evidence.

### 0.3 Non-hallucination and safety rules

- Treat `UNKNOWN`, `PENDING`, `DEFERRED`, `CONFLICT`, and `FAILED` as unresolved or unsafe until corrected.
- Never invent a version, port, path, credential, backup result, firewall rule, or service state.
- Distinguish `planned`, `configured`, `running`, `healthy`, `publicly tested`, and `recovery-tested`.
- State the evidence date whenever relying on a recorded fact.
- Do not ask the owner to repeat facts already documented here. Cite their evidence date; if freshness matters, perform one targeted read-only check and ask only for the missing approval or input.
- Raw `_inbox` notes may be unavailable in another clone. Use reconciled facts and evidence dates in this SSOT; ask for a missing source only when a concrete unresolved decision depends on it.
- Treat this file as dated evidence, not live observation. Do not describe a recorded state as current unless the task does not require freshness or it has been rechecked.
- Use Docker DNS service names, never historical container IP addresses, in persistent configuration.
- Propose read-only inspection first for unknown state.
- Treat `VPS_STATE.snapshot.md` as bounded generated evidence; never replace the canonical service runbooks or task register with it.
- Provide rollback and verification commands before every change.
- Require explicit approval before destructive, production, authentication, firewall, DNS, backup, certificate, or access-control changes.
- Never run blind `docker compose pull`, database changes, volume deletion, firewall changes, key rotation, or restore operations.
- Treat every OmniRoute request as provider-bound unless the selected provider and data transfer have been explicitly approved.
- Never send secrets, credentials, VPN material, private keys, secret-bearing configuration, or unapproved private data to AI providers.
- Never publish or retain Kasm tokens, Cloudflare tokens, Access cookies, Restic credentials, R2 credentials, n8n encryption keys, SMTP credentials, WireGuard private keys, or secret-bearing `.env` files.

### 0.4 Required response structure for operational work

1. Current evidence and date.
2. Unknowns and conflicts.
3. Service, security, data, and rollback risk.
4. Read-only checks.
5. Smallest reversible change.
6. Exact verification criteria.
7. Rollback procedure.
8. SSOT, Change Record, conflict-register, and task-register update.

### 0.5 Single-file verification tracker

This section is the only verification tracker. Do not maintain a separate Markdown checklist.

Status labels:
- `LV` = Live-verified
- `OC` = Owner-confirmed
- `P` = Pending

| Area | Status | Source type | Notes |
|---|---|---|---|
| Host identity / hostname | `LV` | Live inventory | Host, OS, Docker, capacity recorded 2026-09-27 04:02 UTC |
| Container inventory count | `LV` | Owner-supplied live command output | 22 running at 2026-09-27 04:02:24 UTC: 8 Kasm + 14 other; not executed directly by this assistant |
| UFW / listener ownership | `P` | Mixed dated evidence | 3389 host publication removed; fresh UFW and external 8443 reachability not checked |
| Caddy / Cloudflare TLS | `LV` | Dated live evidence | Runtime current to 2026-09-27 04:02; route/TLS evidence from 2026-09-19 |
| Nextcloud runtime | `LV` | Dated live evidence | Application status/repair from 2026-09-19; container inventory from 2026-09-27 04:02 |
| Nextcloud backups / restore | `P` | N/A | Restore not proven |
| n8n runtime | `LV` | Dated live inventory | Containers recorded running 2026-09-27 04:02; dump/restore still pending |
| n8n encryption key / dump path | `P` | N/A | Recovery not yet proven |
| Kasm route / admin login | `LV` | Dated evidence | Route/login were confirmed before the 2026-09-27 gateway change; post-change browser/session acceptance is pending |
| Kasm TCP 3389 host publication | `LV` | Live follow-up | Removed; no host listener at ~04:22 UTC; outside-in audit and browser acceptance pending |
| Kasm backup / restore | `P` | N/A | Not yet proven |
| OmniRoute runtime | `LV` | Dated live inventory | Healthy container recorded 2026-09-27 04:02; application acceptance pending |
| Open WebUI runtime / observed networks | `LV` | Live inventory | Running/healthy; `ai_clients`, `ai_egress`, and `proxy` membership recorded 2026-09-27 04:02; authentication and route acceptance pending |
| VS Code Server runtime / observed networks | `LV` | Live inventory | Running; `dev_internal` and `ai_egress` membership recorded 2026-09-27 04:02; authentication acceptance pending |
| Claude CLI provider acceptance | `P` | Historical test | Anthropic provider returned 401; do not expose or request credentials |
| OpenClaw runtime and OmniRoute model-list path | `LV` | Live inventory + deployment evidence | Healthy; host-published only at 127.0.0.1:18789; model-list success recorded 2026-09-21 |
| OpenClaw backup / restore / sandbox / inference | `P` | N/A | Not proven by deployment evidence |
| Hermes runtime / loopback dashboard | `LV` | Live inventory | Running; 127.0.0.1:9119; image pinned; chat/model acceptance pending |
| Hermes backup / restore / inference / isolation | `P` | N/A | Source inclusion is not restore proof; see Section 9.7 |
| OmniRoute dashboard / API / WebSocket | `P` | N/A | Acceptance incomplete |
| WireGuard migration | `P` | N/A | Old peers must not be removed yet |
| Vaultwarden route / service | `LV` | Dated live evidence | Container health 2026-09-27 04:02; route and `/srv/stack` snapshot evidence 2026-09-19 |
| Vaultwarden onboarding / 2FA / lockdown | `P` | N/A | Not complete |
| Backup repository / restore drill | `P` | N/A | Snapshot exists, restore not proven |
| Cloudflare Zero Trust | `OC` | Owner-confirmed | Policy details and client tests still pending |

Update rule:
- Directly checked live: `LV`
- Confirmed by Leo but not independently rechecked: `OC`
- Uncertain or unproven: `P`

These labels describe evidence type, not freshness. `LV` means directly checked at the date shown; it does not mean the fact was checked in the current session. Use the date in the row or service section when describing state.

### 0.6 Inventory refresh workflow

Use the repository helper only when the configured SSH target is reachable:

```bash
VPS_SSH_TARGET=leo ./scripts/update-vps-state.sh
```

The script performs bounded read-only collection on the VPS and writes `VPS_STATE.snapshot.md` beside itself. It does not modify the VPS or update this canonical file. The default output is Git-ignored. An optional `VPS_STATE_FILE` must name a separate snapshot path; the helper refuses to overwrite `VPS_STATE.md`.

After a refresh, compare the generated evidence to the relevant sections here. Reconcile only verified changes, preserve prior operational detail not collected by the script, update the verification tracker and task register, and add a dated Change Record entry. A successful snapshot command is not proof that omitted services, application behavior, backup recovery, firewall policy, or external reachability were checked.

---

## 1. Executive current position

The VPS is a functioning multi-service Docker platform with Cloudflare/Caddy public routes, private AI services through OmniRoute, WireGuard, Nextcloud, n8n, Kasm, Vaultwarden, OpenClaw, and Hermes.

The 2026-09-27 inventory and follow-up evidence supersede several older state claims:

- Leo's owner-supplied `docker ps` output and targeted Docker inspection at 2026-09-27 04:02:24 UTC enumerate 22 running containers: 8 Kasm and 14 non-Kasm. The earlier 21 total was an arithmetic error in the baseline prose, not a missing container or missing live check. This is a dated count, not a claim about later runtime state. Project/network/volume details are in Sections 2-5.
- The Kasm RDP gateway's host-side TCP `3389` publication was removed and absence of the host listener was confirmed at approximately 04:22 UTC on 2026-09-27. Post-change browser/session acceptance remains pending.
- OpenClaw is host-published only on loopback TCP `18789`; Hermes is host-published only on loopback TCP `9119`. Neither is publicly bound by these mappings.
- Hermes has authenticated Remote gateway dashboard connectivity reported, but end-to-end chat, model routing, provider fallback, and restore are not proven.
- The older R2 snapshot `fdbdc472` includes `/srv/stack`; current service/volume coverage and restore readiness remain unproven.

The following remain unresolved or require controlled remediation:

- Kasm host TCP `3389` publication is absent in the latest supplied evidence; outside-in firewall/NAT audit and post-change browser/session acceptance remain incomplete. This is not an outstanding decision to remove the mapping; that change is already recorded as completed.
- Kasm token-bearing logs were uploaded and must be treated as exposed; affected token material requires rotation.
- Current all-service backup coverage, repository integrity, and application restore drills are not fully proven.
- n8n owner account, dump, independent encryption-key recovery, and isolated restore are not fully proven.
- WireGuard replacement peers have no documented handshakes; old peers must not be removed.
- OmniRoute application-level dashboard/API/WebSocket acceptance remains incomplete despite container health and n8n model execution.
- OpenClaw and Hermes are deployed; backup/restore, sandbox/isolation, and inference acceptance remain incomplete for both.
- AI network membership and privacy-boundary enforcement require verification.
- Open WebUI, VS Code Server, and Claude CLI acceptance remains incomplete.
- Vaultwarden onboarding, 2FA, registration lock-down, and restore remain incomplete.
- Floating image tags remain in use.
- SSH hardening, Docker/agent isolation, monitoring alerting, and disaster-recovery drills remain incomplete.

---

## 2. Current state dashboard

| Area | Current documented state | Evidence date | Status | Next action |
|---|---|---:|---|---|
| Host identity | Debian 13.7 Trixie; hostname `v2202609410969512760`; FQDN `v2202609410969512760.powersrv.de`; x86_64 | 2026-09-27 04:02 | `RECORDED` live inventory | Recheck only when the task requires fresher evidence |
| Compute/storage | 8 vCPU; 15 GiB visible RAM (about 10 GiB available at snapshot); 503G ext4 filesystem (75G used, 408G available, 16%); 4 GiB swap unused | 2026-09-27 04:02 | `RECORDED` point-in-time | Continue capacity monitoring |
| Docker | Engine 29.8.1; Compose v5.5.1 | 2026-09-27 04:02 | `RECORDED` live inventory | Recheck before runtime-specific changes |
| UFW | Older evidence: active, incoming/routed deny, TCP 22/80/443 and UDP 51820 allowed. Fresh `sudo ufw` output unavailable; no inference about current rules | 2026-09-19; limitation 2026-09-27 | `RECORDED/PENDING` | Obtain fresh UFW and Docker NAT review before exposure changes |
| Caddy | Container running; host TCP 80/443; Cloudflare Origin CA and public reverse-proxy routes documented | Runtime 2026-09-27 04:02; route/TLS evidence 2026-09-19 | `RECORDED` mixed evidence | Validate configuration before changes; recheck route/TLS only when task requires fresher evidence |
| Nextcloud | App 34.0.3.2; maintenance off; repair complete; no DB upgrade pending; `leo` quota 180 GB; recent jobs; database/Redis containers running | App checks 2026-09-19; container inventory 2026-09-27 04:02 | `CONFIRMED` as-of app evidence; current application acceptance unrefreshed | Verify backup/restore and authenticated clients |
| n8n | Running with PostgreSQL; public route documented; no host ports | Runtime 2026-09-27 04:02; app/route evidence 2026-09-19 | `RECORDED` runtime; account/webhook/recovery pending | Verify owner, dump, key recovery, restore, and webhook behavior |
| Kasm | Runtime components healthy; TCP 8443 remains wildcard-published; RDP gateway TCP 3389 host publication removed and gateway healthy | 2026-09-27 ~04:22 | `RECORDED`; browser/session after change `PENDING` | Test browser login/session; token rotation and restore remain pending |
| TCP 8443 | `kasm_proxy` publishes host 8443 to internal Kasm HTTPS 443 | 2026-09-27 ~04:21 | `RECORDED` mapping; outside-in reachability pending | Preserve Caddy upstream and test rollback before changing |
| TCP 3389 | No host publication/listener after Kasm gateway-only recreation; internal container port remains | 2026-09-27 ~04:22 | `RECORDED`; outside-in audit not done | Preserve browser-only decision; validate Kasm login and session after change |
| Telemetry 4317/8125/19999 | Loopback listeners; owner for 4317 not established in supplied output | 2026-09-27 04:02 | `RECORDED` loopback mapping | Do not expose; verify ownership only if relevant to a change |
| Ollama | Removed; no approved local model route | 2026-09-17 | `CONFIRMED` | Do not recreate without architecture decision |
| OmniRoute | Healthy container; `omni_clients` and `ai_egress`; no host port; n8n model execution previously succeeded | Runtime 2026-09-27 04:02; n8n execution 2026-09-19 | `RECORDED` runtime; `PENDING` app acceptance | Test `/healthz`, dashboard API, WebSocket, and privacy boundary |
| OpenClaw | See Section 9.6. Image `openclaw:local`; healthy; host loopback mapping `127.0.0.1:18789`; attached to `openclaw_internal` and `ai_egress`; default `omniroute/leo-one-free` | 2026-09-27 inventory (model-list test 2026-09-21) | `RECORDED`; recovery/security acceptance `PENDING` | Verify backup inclusion, restore, sandbox/isolation, and approved inference test |
| Hermes | See Section 9.7. Pinned amd64 image digest; running; host loopback mapping `127.0.0.1:9119`; attached to `omni_clients` and `hermes_egress` | 2026-09-27 inventory; dashboard evidence through 2026-09-26 | `RECORDED`; chat/model/recovery acceptance `PENDING` | Complete controlled chat/model test and restore plan |
| Open WebUI | Running/healthy; observed members `ai_clients`, `ai_egress`, and `proxy`; authentication and OmniRoute route acceptance not fully evidenced | Runtime/network 2026-09-27 04:02; app acceptance pending | `RECORDED` runtime/membership; `PENDING` application state | Verify authentication and intended OmniRoute route; do not re-check known membership unless it changed |
| VS Code Server | Running; observed members `dev_internal` and `ai_egress`; image uses floating `latest`; authentication acceptance incomplete | Runtime/network 2026-09-27 04:02; auth acceptance pending | `RECORDED` runtime/membership; `PENDING` application state | Enable/test authentication and verify network/mount boundary |
| Claude CLI | Gateway path recorded; provider authentication previously returned 401 | 2026-09-17 | `PENDING` | Resolve credentials through approved secret mechanism and harmless test |
| WireGuard | Standard IPv4 full tunnel; ten peers configured; old `.2` and `.6` had recent handshakes; replacements `.7`–`.11` had zero | 2026-09-19 | `PENDING` migration | Migrate one device at a time; verify handshake and exit IP |
| Backups | R2 repository opened after credential rotation; snapshot `fdbdc472` at 2026-09-19 08:47:28 included `/srv/stack`; full current coverage and restore not proven | 2026-09-19 | `CONFIRMED` fresh snapshot; `PENDING` recovery | Run repository checks, coverage verification, representative restores, and application drills |
| Cloudflare Zero Trust | Owner confirms protection for n8n, Nextcloud, and Kasm; Nextcloud unauthenticated redirect confirmed | 2026-09-19 | `OWNER-CONFIRMED/CONFIRMED` | Export policy structure and test authorized flows without bypasses |
| Vaultwarden | Version 1.37.3 container healthy; public route, `/alive`, redirect, and `/srv/stack` snapshot inclusion previously confirmed; signup state is dated | Runtime 2026-09-27 04:02; route/backup 2026-09-19 | `RECORDED` runtime; onboarding and restore pending | Onboard users, test clients, enable 2FA, disable signup, test restore |
| Image pinning | Several services use `latest` or rolling tags; local digests observed but Compose immutability not proven | 2026-09-27 inventory | `PENDING` | Pin one stack at a time with rollback digests |
| SSH/Docker isolation | Docker membership is root-equivalent; Kasm agent mounts Docker socket; SSH and AI-agent boundary not fully reviewed | Docker group 2026-09-19; mounts 2026-09-27 | `PENDING` | Review without losing console/SSH recovery |
| Monitoring | Netdata loopback access confirmed; alert destinations/test not established | Listener 2026-09-27 04:02; alerting unknown | `PENDING` | Add protected alerting and review collector warnings |
| Disaster recovery | Baseline restore history predates later AI/Kasm/Vaultwarden additions | 2026-09-19 | `PENDING` | Complete current-service restore drills; do not claim readiness |

### 2.1 Current Compose ownership and runtime inventory

The following is the latest owner-supplied `docker ps`-based inventory at `2026-09-27 04:02:24 UTC`, followed by targeted Docker inspection. It enumerates 22 running containers: eight Kasm and fourteen non-Kasm. The earlier statement of 21 was an arithmetic/documentation error; no additional check is needed to reconcile this snapshot. A new check is needed only when a later current count is required. The Kasm RDP gateway was recreated afterward and separately confirmed running/healthy at approximately 04:22 UTC. `No healthcheck` means Docker had no health status configured, not that the service failed. Container image references and point-in-time status are not a substitute for registry digest validation or application acceptance. The assistant did not directly execute the VPS commands.

| Compose project | Active Compose file | Containers/services |
|---|---|---|
| Kasm (`docker`) | `/opt/kasm/1.19.0/docker/docker-compose.yaml` | `kasm_proxy`, `kasm_rdp_https_gateway`, `kasm_rdp_gateway`, `kasm_agent`, `kasm_api`, `kasm_manager`, `kasm_guac`, `kasm_db` |
| Hermes | `/srv/stack/hermes/compose.yaml` | `hermes-agent` / `hermes` |
| OpenClaw | `/srv/openclaw/compose.yml` | `openclaw-openclaw-gateway-1` / `openclaw-gateway` |
| Vaultwarden | `/srv/stack/vaultwarden/compose.yml` | `vaultwarden-vaultwarden-1` / `vaultwarden` |
| n8n | `/srv/stack/n8n/compose.yml` | `n8n-n8n-1` / `n8n`; `n8n-postgres-1` / `postgres` |
| OmniRoute | `/srv/stack/omniroute/compose.yml` | `omniroute-omniroute-1` / `omniroute`; `omniroute-redis-1` / `redis` |
| Caddy | `/srv/stack/caddy/compose.yml` | `caddy` |
| VS Code Server | `/srv/stack/vscode-server/docker-compose.yml` | `vscode-server` |
| Open WebUI | `/srv/stack/open-webui/docker-compose.yml` | `open-webui` |
| Nextcloud | `/srv/stack/nextcloud/compose.yml` | `nextcloud-cron`, `nextcloud`, `redis-nextcloud`, `nextcloud-db` |

`/srv/openclaw/source/docker-compose.yml` exists but is not the active file labeled on the running OpenClaw container; do not run it by mistake. Kasm's systemd service starts/stops the Kasm scripts; its Compose operations require `KASM_UID=1001` and `KASM_GID=1001`.

| Container | Image reference in inventory | Health/status | Host-published ports |
|---|---|---|---|
| `kasm_proxy` | `kasmweb/proxy:1.19.0-rolling` | No healthcheck | `0.0.0.0:8443` and `[::]:8443` -> 443 |
| `kasm_rdp_https_gateway` | `kasmweb/rdp-https-gateway:1.19.0-rolling` | Healthy | None |
| `kasm_rdp_gateway` | `kasmweb/rdp-gateway:1.19.0-rolling` | Healthy after 04:22 recreation | None; internal `3389/tcp` |
| `kasm_agent` | `kasmweb/agent:1.19.0-rolling` | Healthy | None |
| `kasm_api` | `kasmweb/api:1.19.0-rolling` | Healthy | None |
| `kasm_manager` | `kasmweb/manager:1.19.0-rolling` | Healthy | None |
| `kasm_guac` | `kasmweb/kasm-guac:1.19.0-rolling` | Healthy | None |
| `kasm_db` | `kasmweb/postgres:1.19.0-rolling` | Healthy | None |
| `hermes-agent` | `nousresearch/hermes-agent:v2026.9.24@sha256:2fd023efbb8d3d2b0ce1a73d028b07370cff34f567cfe0e999553e8c327ea283` | Running; no healthcheck | `127.0.0.1:9119` -> 9119 |
| `openclaw-openclaw-gateway-1` | `openclaw:local` | Healthy | `127.0.0.1:18789` -> 18789 |
| `vaultwarden-vaultwarden-1` | `vaultwarden/server@sha256:1587c45feaa479f1f5e8af3b00eded36bff77bcf1880cf8dbf0541706dd470e0` | Healthy | None |
| `n8n-n8n-1` | `n8nio/n8n:latest` | Running; no healthcheck | None |
| `omniroute-omniroute-1` | `diegosouzapw/omniroute:3.8.50` | Healthy | None |
| `caddy` | `caddy:2.10.2-alpine` | Running; no healthcheck | TCP 80/443 on IPv4/IPv6 wildcard |
| `vscode-server` | `linuxserver/code-server:latest` | Running; no healthcheck | None |
| `open-webui` | `ghcr.io/open-webui/open-webui:latest` | Healthy | None |
| `omniroute-redis-1` | `redis:7-alpine` | Healthy | None |
| `n8n-postgres-1` | `postgres:16-alpine` | Healthy | None |
| `nextcloud-cron` | `nextcloud:apache` | Running; no healthcheck | None |
| `nextcloud` | `nextcloud:apache` | Running; no healthcheck | None |
| `redis-nextcloud` | `redis:7-alpine` | Running; no healthcheck | None |
| `nextcloud-db` | `mariadb:11.8` | Healthy | None |

Kasm `rolling`, n8n/code-server/Open WebUI `latest`, and Nextcloud `apache` are mutable references. A local image ID/digest is not proof that Compose is pinned to an immutable registry manifest. The exact Hermes and Vaultwarden digests above are recorded for those running images.

### 2.2 Persistent data and backup boundary

Live mount inspection in the 2026-09-27 baseline recorded these important paths. A mount being persistent does not prove that a backup job includes it or that it can be restored.

| Service/state | Host source or Docker volume | Container destination | Backup/recovery note |
|---|---|---|---|
| Hermes | `/srv/stack/hermes/data` | `/opt/data` (RW) | Under `/srv/stack`; current backup and restore acceptance still unproven |
| OpenClaw | `/srv/openclaw/config`, `/srv/openclaw/data`, `/srv/openclaw/workspace` | `/home/node/.openclaw`, `/home/node/.config/openclaw`, `/home/node/.openclaw/workspace` (RW) | Outside `/srv/stack`; do not assume stack backup covers it |
| Vaultwarden | `/srv/stack/vaultwarden/data` | `/data` (RW) | Stack path; owner-deferred restore test |
| n8n | `n8n_n8n_data`; `n8n_postgres_data` | `/home/node/.n8n`; PostgreSQL data directory | Separate app/database recovery; dump and restore pending |
| OmniRoute | `omniroute_omniroute-data`; `omniroute_redis-data` | `/app/data`; `/data` | Docker-volume coverage and Redis recovery policy unknown |
| Caddy | `caddy_caddy_config`; `caddy_caddy_data`; Caddyfile bind; private origin-certs bind | `/config`; `/data`; `/etc/caddy/Caddyfile`; cert path RO | Certificate source path redacted; backup coverage unknown |
| VS Code Server | `vscode-server_vscode-config`; `/srv/workspaces` | `/config`; `/workspaces` (RW) | Workspaces are outside `/srv/stack`; coverage unknown |
| Open WebUI | `open-webui_open-webui-data` | `/app/data` | Docker-volume backup coverage unknown |
| Nextcloud | `nextcloud_nextcloud_html`; `nextcloud_nextcloud_db`; anonymous Redis volume | `/var/www/html`; MariaDB data; `/data` | App-consistent backup and separate DB recovery required; anonymous volume policy unknown |
| Kasm | `kasm_db_1.19.0`; bind mounts under `/opt/kasm/1.19.0` | PostgreSQL and Kasm config/cert/log/tmp paths | Critical DB/config; backup coverage and restore remain unproven |
| Kasm agent | `/var/run/docker.sock`; `/opt/kasm/1.19.0` mounts | Docker socket and Kasm paths | Docker-daemon-equivalent control; do not grant this access to Hermes/OpenClaw |

The latest baseline found backup job files and scripts but did not establish current source lists, successful job results, full named-volume coverage, or recovery. The older R2 snapshot `fdbdc472` included `/srv/stack`; this does not cover `/srv/openclaw`, `/srv/workspaces`, Docker named volumes, Kasm data, or `/etc/wireguard` unless separately demonstrated.

---

## 3. Infrastructure identity and capacity

| Field | Value | Status |
|---|---|---|
| Provider | netcup / Cupnet | `CONFIRMED` |
| Product | RS 2000 G12, KVM | `CONFIRMED` |
| Location | Vienna, Austria | `CONFIRMED` |
| Server nickname | Leo One | `CONFIRMED` |
| Provider server ID | `931750` | `RECORDED — private` |
| vCPU | 8 | `RECORDED` |
| RAM | 15 GiB visible; 10 GiB available at 2026-09-27 04:02 snapshot | `RECORDED — point-in-time` |
| Swap | 4 GiB `/swapfile`; 0 used at 2026-09-27 04:02 snapshot | `RECORDED — point-in-time` |
| Storage | `/dev/vda4` ext4; 503G total, 75G used, 408G available (16%); `/`, `/srv`, and `/srv/stack` share this filesystem | `RECORDED — point-in-time` |
| Authoritative hostname | `v2202609410969512760` | `CONFIRMED` |
| Authoritative FQDN | `v2202609410969512760.powersrv.de` | `CONFIRMED` |
| Public IPv4 | `89.58.63.213` | `RECORDED — private` |
| Interface | `eth0` | `RECORDED` |
| Administrator | `leo` | `CONFIRMED` |
| Privilege model | `leo` belongs to `docker` and `stack-secrets`; Docker membership is root-equivalent | `CONFIRMED` |
| OS | Debian GNU/Linux 13 Trixie | `RECORDED` |
| Docker Engine | 29.8.1 | `RECORDED — live 2026-09-27 04:02 inventory` |
| Docker Compose | v5.5.1 | `RECORDED — live 2026-09-27 04:02 inventory` |

Do not paste or record private provider identifiers, secret-bearing configuration, or unrestricted environment output.

---

## 4. Network, firewall, and public exposure

### 4.1 Intended public architecture

```text
Internet
  -> Cloudflare DNS/proxy and Full (strict) TLS
  -> Caddy on host TCP 80/443; UDP 443 is container-only and not host-published in the latest inventory
      -> cloud.trisektor.org  -> Nextcloud
      -> n8n.trisektor.org    -> n8n
      -> desktop.trisektor.org -> https://host.docker.internal:8443 -> Kasm
      -> vault.trisektor.org  -> Vaultwarden

WireGuard wg0 -> IPv4 full tunnel through UDP 51820

    SSH local forwards (Mac alias `leo-one`) -> private Open WebUI, VS Code, OmniRoute,
    Netdata, OpenClaw, and Hermes listeners; see Section 9.8

Private AI:
  omni_clients -> OmniRoute gateway
  ai_egress    -> OmniRoute and Redis provider-egress path
```

### 4.2 UFW evidence

The latest supplied baseline did not obtain fresh UFW output because non-interactive `sudo -n` was unavailable. Older evidence from approximately `2026-09-19 15:28:13 UTC` recorded:

```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
Allowed TCP: 22, 80, 443
Allowed UDP: 51820
IPv6 equivalents: 22, 80, 443 TCP and 51820 UDP
```

The 2026-09-27 state of those rules is `UNKNOWN`. Do not present the older rules as a fresh check. Docker port publishing and host firewall/NAT behavior must be considered together; no outside-in IPv4/IPv6 audit was supplied.

### 4.3 Latest supplied listener mapping

The 2026-09-27 04:02 host inventory, with the Kasm gateway-only follow-up at approximately 04:22 UTC, recorded:

| Listener | Owner | Binding | Status |
|---|---|---|---|
| TCP 22 | sshd | `0.0.0.0` and `[::]` | Wildcard listener |
| TCP 80/443 | Docker-published Caddy | `0.0.0.0` and `[::]` | Public web entrypoints |
| TCP 8443 | `kasm_proxy` -> container 443 | `0.0.0.0` and `[::]` | Wildcard published; outside-in reachability unverified |
| TCP 3389 | Kasm RDP gateway | No host publication/listener at ~04:22 UTC | Internal container port only; outside-in audit not a substitute for this host check |
| UDP 51820 | WireGuard | `0.0.0.0` and `[::]` | Wildcard listener |
| TCP 9119 | `hermes-agent` -> 9119 | `127.0.0.1` | Hermes dashboard, loopback-only |
| TCP 18789 | OpenClaw Gateway -> 18789 | `127.0.0.1` | Loopback-only |
| TCP 19999 | Netdata | `127.0.0.1` | Loopback-only dashboard |
| TCP 4317 | Telemetry; owner not established in supplied output | `127.0.0.1` | Loopback-only |
| TCP/UDP 8125 | Telemetry / Netdata | `127.0.0.1`, `[::1]` | Loopback-only |
| TCP 20128 | OmniRoute container | No host mapping/listener | Container network only |
| TCP 8642 | Hermes API | No host mapping/listener recorded | Container network only |
| UDP 443 | Caddy container port only | Not host-published in Docker mapping | Do not claim a host QUIC listener |

### 4.4 Kasm access architecture

The owner confirms Kasm is mapped to `desktop.trisektor.org` and protected with Cloudflare Zero Trust. The documented and intended user path is:

```text
Browser
  -> https://desktop.trisektor.org
  -> Cloudflare proxy and Zero Trust
  -> Caddy TCP 443
  -> https://host.docker.internal:8443
  -> kasm_proxy
  -> Kasm services
```

The previously published direct TCP 3389 path was removed on 2026-09-27:

```text
Kasm container TCP 3389
  -> remains internal to Kasm Docker networking; no host publication observed
```

The latest supplied evidence at approximately 04:22 UTC showed `kasm_rdp_gateway` with `3389/tcp:null`, no `docker port` mapping, and no host TCP 3389 listener. This confirms Docker host-publication removal, not a complete outside-in IPv4/IPv6 audit. The documented browser route remains `desktop.trisektor.org` through Cloudflare/Caddy.

Current status:

```text
TCP 3389 internal ownership: CONFIRMED — Kasm RDP gateway
TCP 3389 host publication: ABSENT in 2026-09-27 04:22 evidence
Kasm browser/session acceptance after change: PENDING
```

The owner confirmed browser-only Kasm and no direct/native RDP-client requirement. The change removed only the host-side mapping (`ports: []`); the rollback copy is `/opt/kasm/1.19.0/docker/docker-compose.yaml.before-remove-3389.20260927T041823Z`. Do not restore it without explicit approval because that would reopen host TCP 3389. Browser login, session launch, and WebSocket behavior after the change still require testing.

### 4.5 Security rules

- Keep Kasm upstream as `https://host.docker.internal:8443`, not localhost.
- Keep Caddy `tls_insecure_skip_verify` limited to the private Caddy-to-Kasm hop.
- Do not expose private dashboards as a shortcut.
- Do not close or expose ports without mapping service ownership and recovery.
- Treat direct Docker-published ports as exposure candidates even if UFW does not list an allow rule.
- Do not alter Cloudflare TLS from Full (strict) to Flexible.
- Do not gray-cloud Origin CA hostnames.

---

## 5. Docker networks

Observed Docker network inventory and memberships at 2026-09-27 04:02 UTC:

| Network | Subnet | Type/status | Intended role |
|---|---|---|---|
| `bridge` | `172.17.0.0/16` | bridge, `internal=false` | No members in snapshot |
| `proxy` | `172.18.0.0/16` | bridge, `internal=false` | Caddy, n8n, Nextcloud, Open WebUI, Vaultwarden |
| `nextcloud_nextcloud_internal` | `172.19.0.0/16` | bridge, `internal=true` | Nextcloud, cron, database, Redis |
| `n8n_n8n_internal` | `172.20.0.0/16` | bridge, `internal=false` | n8n, PostgreSQL |
| `ai_clients` | `172.21.0.0/16` | bridge, `internal=false` | Open WebUI |
| `ai_egress` | `172.22.0.0/16` | bridge, `internal=false` | OmniRoute, OmniRoute Redis, Open WebUI, OpenClaw, VS Code |
| `dev_internal` | `172.23.0.0/16` | bridge, `internal=false` | VS Code Server |
| `kasm_default_network` | `172.24.0.0/16` | bridge, `internal=false` | Kasm services; membership after gateway recreation not re-inspected |
| `kasm_sidecar_network` | `172.25.0.0/16` | Kasm sidecar driver, `internal=false` | Kasm proxy |
| `omni_clients` | `172.26.0.0/16` | bridge, `internal=true` | Hermes, n8n, OmniRoute |
| `vaultwarden_default` | `172.27.0.0/16` | bridge, `internal=false` | Vaultwarden |
| `openclaw_internal` | `172.28.0.0/16` | bridge, `internal=false` | OpenClaw Gateway; name does not imply isolation |
| `hermes_egress` | `172.29.0.0/16` | bridge, `internal=false` | Hermes; general egress, not a strict allowlist |
| `host`, `none` | Standard Docker networks | Standard | No members in snapshot |

The 2026-09-27 membership snapshot confirms `ai_clients` is used by Open WebUI; `ai_egress` includes OmniRoute, its Redis, Open WebUI, OpenClaw, and VS Code; and Hermes joins `omni_clients` plus `hermes_egress`. `omni_clients` is Docker-internal; the names `openclaw_internal` and `n8n_n8n_internal` do not mean those networks are Docker-internal. Actual membership does not prove a privacy boundary, provider policy, or egress allowlist. Do not detach or delete networks without task-specific checks and approval.

For a fresh redacted membership check before changing network membership, use:

```bash
for network in proxy nextcloud_nextcloud_internal n8n_n8n_internal ai_clients ai_egress dev_internal kasm_default_network kasm_sidecar_network omni_clients vaultwarden_default openclaw_internal hermes_egress; do
  printf '\n=== %s ===\n' "$network"
  docker network inspect "$network" \
    --format '{{range $id, $c := .Containers}}{{println $c.Name}}{{end}}' \
    || exit 1
done
```

Policy:

- OmniRoute currently uses `omni_clients` and `ai_egress`.
- OmniRoute Redis currently uses `ai_egress`.
- Hermes currently uses `omni_clients` and `hermes_egress`; Hermes egress is a general bridge, not a strict allowlist.
- OpenClaw currently uses `openclaw_internal` and `ai_egress`.
- Open WebUI currently uses `ai_clients`, `ai_egress`, and `proxy`; VS Code currently uses `dev_internal` and `ai_egress`.
- Databases, Caddy, and unrelated services must not join AI networks.
- AI host mappings must remain loopback-only unless an explicit approved design says otherwise. OpenClaw `18789` and Hermes `9119` are loopback-only; OmniRoute has no host mapping.
- Use `omniroute:20128`, not historical container IP addresses.

---

## 6. Caddy and Cloudflare

### 6.1 Caddy

| Item | Value | Status |
|---|---|---|
| Directory | `/srv/stack/caddy/` | `RECORDED` |
| Compose | `/srv/stack/caddy/compose.yml` | `RECORDED` |
| Caddyfile | `/srv/stack/caddy/Caddyfile` | `RECORDED` |
| Container | `caddy` | `CONFIRMED` |
| Host ports | TCP 80/443 | `CONFIRMED` |
| UDP 443 | Caddy container port; not host-published in latest Docker mapping | `RECORDED — no host QUIC listener established` |
| Admin | TCP 2019 internal | `RECORDED` |
| TLS | Explicit Cloudflare Origin CA; `auto_https off` | `CONFIRMED` |

Required change procedure:

```bash
docker exec caddy caddy validate \
  --config /etc/caddy/Caddyfile \
  --adapter caddyfile

# Only after validation succeeds:
docker exec caddy caddy reload \
  --config /etc/caddy/Caddyfile \
  --adapter caddyfile
```

### 6.2 Cloudflare Zero Trust

Owner-confirmed protected hostnames:

- `n8n.trisektor.org`.
- `cloud.trisektor.org`.
- `desktop.trisektor.org`.

Live Nextcloud testing at approximately `2026-09-19 15:21:06 UTC` returned HTTP 302 to the Cloudflare Access login endpoint for both `/` and `/status.php`. This confirms unauthenticated protection for the Nextcloud route.

The exact policy export remains undocumented. Record only non-secret policy structure:

- Application name and hostname.
- Policy order.
- Action: Allow, Block, Bypass, or Service Auth.
- Identity provider, group/domain selectors, and device/MFA requirements.
- Session duration and break-glass recovery path.
- Intended webhook exceptions, if any.
- Audit-log retention and alerting.

Do not record service tokens, cookies, private keys, or credentials. Do not bypass or weaken policy to obtain a simple HTTP 200.

---

## 7. Nextcloud

### 7.1 Confirmed application state

Fresh live evidence captured at `2026-09-19 15:18:27 UTC`:

```text
installed: true
version: 34.0.3.2
versionstring: 34.0.3
maintenance: false
needsDbUpgrade: false
productname: Nextcloud
extendedSupport: false
```

The status was repeated after repair at approximately `15:23 UTC` with the same result.

### 7.2 Repair

The following completed successfully at approximately `2026-09-19 15:22 UTC`:

```bash
docker exec -u www-data nextcloud php occ maintenance:repair \
  --include-expensive
```

The output completed without a reported error and included collation checks, OAuth schema migration, cache clearing, DAV/share repair, calendar updates, MIME/tag repair, background-job registration, token cleanup, metadata initialization, workflow structure population, and other maintenance steps.

Post-repair status confirmed:

```text
maintenance: false
needsDbUpgrade: false
```

Status: `CONFIRMED`.

### 7.3 Quota and user

Fresh `occ user:info leo` output:

```text
user_id: leo
enabled: true
groups:
  - admin
quota: 180 GB
free: 193208594070
used: 64934250
total: 193273528320
relative: 0.03
```

Status: `CONFIRMED`.

### 7.4 Background jobs

Recent background jobs were observed through `2026-09-19T15:15:00+00:00`, including file scanning, cleanup, DAV, activity notification, calendar, token, log rotation, Text, Webhook, and other jobs.

Status: `CONFIRMED — recent execution observed`.

### 7.5 Supporting services

Live Docker state at approximately `2026-09-19 15:21 UTC`:

- `nextcloud`: up 3 days.
- `nextcloud-cron`: up 3 days.
- `nextcloud-db`: MariaDB 11.8, healthy.
- `redis-nextcloud`: up 3 days.

Status: `CONFIRMED — container/service level`.

### 7.6 Nextcloud backup and client acceptance

Still pending:

- Fresh local/R2 snapshot listing.
- Repository checks.
- Current path coverage.
- Representative restore.
- Isolated application restore.
- Authenticated browser/client tests through Cloudflare Access.
- WebDAV, CalDAV, CardDAV, desktop, and mobile tests where used.

Do not claim Nextcloud disaster recovery readiness from application health or repair output.

---

## 8. n8n and PostgreSQL

### 8.1 Current live state

Live inventory at approximately `2026-09-19 15:28:13 UTC`:

```text
n8n-n8n-1       n8nio/n8n:latest     Up 2 days
n8n-postgres-1  postgres:16-alpine   Up 3 days (healthy)
```

n8n and PostgreSQL have no host-published ports.

### 8.2 Unresolved claims

| Claim | Status | Required evidence |
|---|---|---|
| n8n owner account exists | `CONFLICT/PENDING` | Current account check without exposing credentials |
| n8n PostgreSQL dump exists | `PENDING` | Fresh dump listing and non-empty file check |
| Dump is valid | `PENDING` | `pg_restore --list` succeeds |
| Encryption-key recovery is complete | `PENDING` | Independent password-manager copy verified out-of-band |
| Backup includes current n8n data | `PENDING` | Snapshot coverage and restore evidence |
| n8n isolated restore works | `PENDING` | Non-production restore with matching encryption key |
| n8n owner/workflow acceptance | `PENDING` | Harmless workflow and controlled webhook tests |
| Image immutable | `PENDING` | Replace `latest` with tested digest and rollback record |

Safe dump validation:

```bash
latest_dump=$(sudo find /srv/stack/backups/n8n-postgres -maxdepth 1 \
  -type f -name 'n8n-*.dump' -printf '%T@ %p\n' \
  | sort -n | tail -1 | cut -d' ' -f2-)

test -n "$latest_dump"
test -s "$latest_dump"

cd /srv/stack/n8n
docker compose exec -T postgres pg_restore --list < "$latest_dump" \
  > /tmp/n8n-pg-restore-list.txt

test -s /tmp/n8n-pg-restore-list.txt
rm -f /tmp/n8n-pg-restore-list.txt
```

Never print n8n `.env`, secret files, database passwords, or `N8N_ENCRYPTION_KEY`.

---

## 9. Kasm Workspaces

### 9.1 Runtime and route

Live inventory confirmed:

- `kasm_proxy`: `kasmweb/proxy:1.19.0-rolling`, host TCP 8443 to container 443.
- `kasm_rdp_https_gateway`: healthy.
- `kasm_rdp_gateway`: healthy after 2026-09-27 recreation; container TCP 3389 remains internal with no host mapping.
- `kasm_agent`: healthy.
- `kasm_api`: healthy.
- `kasm_manager`: healthy.
- `kasm_guac`: healthy.
- `kasm_db`: healthy.

The active Compose project is `/opt/kasm/1.19.0/docker/docker-compose.yaml`, managed by `/etc/systemd/system/kasm.service`. Kasm Compose must run with `KASM_UID=1001` and `KASM_GID=1001`; do not restart the entire Kasm systemd service for a single-service port change. The gateway-only change preserved host TCP 8443 on `kasm_proxy`.

The uploaded Kasm terminal evidence also shows repeated API and RDP gateway health checks returning HTTP 200, manager/agent heartbeat activity, and authenticated administrator API activity.

Status:

```text
Kasm runtime: CONFIRMED
Kasm API health: CONFIRMED
Kasm RDP gateway health: CONFIRMED
Kasm public browser route/admin login: CONFIRMED before the 2026-09-27 gateway-only change
Kasm browser/session acceptance after TCP 3389 removal: PENDING
```

### 9.2 Intended access path

The owner confirms Kasm is mapped to `desktop.trisektor.org` and secured with Cloudflare Zero Trust. Use only this browser endpoint for normal operation:

```text
https://desktop.trisektor.org
```

Do not instruct users to connect directly to TCP 3389.

### 9.3 TCP 3389

TCP 3389 remains the Kasm RDP gateway's internal container port. The owner confirmed browser-only access and no direct/native RDP client requirement. On 2026-09-27, only the host publication was removed from the `rdp_gateway` service by setting `ports: []` in the active Compose file. Compose validation succeeded; only the gateway was recreated with `--no-deps --no-build --pull never --force-recreate` and the required Kasm UID/GID.

Current status:

```text
Internal ownership: CONFIRMED
Host mapping: ABSENT; docker inspect reported 3389/tcp:null and docker port was empty
Host TCP listener: ABSENT in ss at approximately 04:22 UTC
Gateway: running and healthy after recreation
Browser login/session/WebSocket after change: PENDING
Outside-in IPv4/IPv6 and Docker NAT audit: PENDING
```

Rollback copy: `/opt/kasm/1.19.0/docker/docker-compose.yaml.before-remove-3389.20260927T041823Z`. Restoring it would reopen host TCP 3389 and requires explicit approval. Verify browser login and session launch at `https://desktop.trisektor.org` before treating this change as accepted.

### 9.4 Kasm token exposure incident

The uploaded `kasem-update-terminal.txt` contains token-bearing Kasm log entries, including registration/host/manager/session token material. This violates the SSOT secret boundary.

Status:

```text
Kasm token/log hygiene: FAILED — remediation required
```

Required response:

- Do not copy token values into any document.
- Remove the artifact from shared/synchronized locations.
- Rotate or re-register affected Kasm token material through the supported Kasm procedure.
- Verify Kasm API, RDP gateway, public browser route, session, and administrator login afterward.
- Record only the fact, timestamp, affected components, and test result.

Do not manually edit logs or perform ad hoc database token changes.

### 9.5 Kasm recovery

Still pending:

- Exact persistent volumes and bind mounts.
- Kasm PostgreSQL dump method and retention.
- Installation/configuration artifacts.
- Administrator recovery procedure.
- Non-production restore target.
- Successful login/session test after restore.
- Tested image digests and rollback images.

Do not claim Kasm recoverability from healthy containers or HTTP 200 health checks.

### 9.6 OpenClaw

OpenClaw deployment evidence is recorded from the final deployment SSOT dated `2026-09-21`. The deployment is operationally running, but backup/restore, sandbox, isolation, and inference acceptance are not yet proven.

#### Deployment identity and layout

| Item | Value | Status |
|---|---|---|
| Project directory | `/srv/openclaw` | `RECORDED` |
| Compose file | `/srv/openclaw/compose.yml` | `RECORDED` |
| Source checkout | `/srv/openclaw/source` | `RECORDED` |
| Source repository | `https://github.com/openclaw/openclaw.git` | `RECORDED` |
| Source tag | `v2026.9.5` | `RECORDED` |
| Source commit | `ec9c1a13db8938e5a3eaa51fca2e981cde2395a9` | `RECORDED` |
| Image | `openclaw:local` | `RECORDED` |
| Image ID | `sha256:4b29d0c9c4c00cab15024799b9d3a08f514b883c94cdfb58e3df7c7535ea2fa0` | `RECORDED` |
| Compose service | `openclaw-gateway` | `RECORDED` |
| Running container | `openclaw-openclaw-gateway-1` | `RECORDED` |
| Gateway version | `2026.9.5` | `RECORDED` |
| Internal listener | TCP `18789` | `RECORDED` |
| Host-published ports | `127.0.0.1:18789 -> 18789/tcp`; no wildcard/public host bind in latest inventory | `RECORDED` |
| Project networks | `openclaw_internal` (`172.28.0.0/16`, Docker `internal=false`) and external `ai_egress` | `RECORDED` |
| Time zone | `Asia/Karachi` | `RECORDED` |
| Gateway authentication | Token configured in protected environment file; value not recorded | `RECORDED` |

The project state directories are `/srv/openclaw/config`, `/srv/openclaw/workspace`, `/srv/openclaw/data`, `/srv/openclaw/logs`, and `/srv/openclaw/backups`. The recorded source and configuration files also include `/srv/openclaw/.env`, `config/openclaw.json`, its `.bak` files, `config/state/openclaw.sqlite`, and the generated workspace files. The `.env` file is recorded as mode `0600`, owned by `leo:leo`; never copy or print its values.

#### Compose and runtime controls

Recorded Compose controls:

- Build context is `/srv/openclaw/source`; the image build succeeded.
- `openclaw_internal` is a project bridge (`172.28.0.0/16`, Docker `internal=false` in the latest inventory); the name does not imply an egress-isolated network.
- `ai_egress` is an existing external Docker network used to reach OmniRoute.
- Latest live inventory records only loopback host publication `127.0.0.1:18789:18789`; no host mappings for Gateway ports `18790` or `3978` were recorded. This supersedes the 2026-09-21 deployment note that reported no host ports.
- `NET_RAW` and `NET_ADMIN` are dropped.
- `no-new-privileges:true` is enabled.
- Restart policy is `unless-stopped`.
- A Gateway healthcheck is configured.
- No Docker socket mount, broad host filesystem mount, persistent CLI service, messaging channel, browser automation, Caddy route, Cloudflare route, or OpenClaw-specific UFW rule is recorded.
- Systemd installation was skipped because systemd user services were unavailable inside the container.
- Onboarding used one agent named `main`, initial access posture `Ask first`, manual AI access discovery, telemetry declined, and model/provider setup skipped initially before OmniRoute was added.

The Gateway was running and healthy in the 2026-09-27 inventory. Earlier deployment evidence recorded `[gateway] ready`, `[heartbeat] started`, and a healthy internal WebSocket probe. The latest authoritative host mapping is loopback-only `127.0.0.1:18789`; it is reachable from the Mac through the documented SSH tunnel, not directly from other hosts through this Docker mapping.

#### OmniRoute integration

OpenClaw uses the existing private OmniRoute path:

```text
Provider: omniroute
Adapter: openai-completions
Endpoint: http://omniroute:20128/v1
Model: leo-one-free
Default route: omniroute/leo-one-free
```

The provider key is environment-backed through the configured provider field and is redacted in status output. No key value or redacted fragment belongs in this document. Private-network access is configured at the accepted nested path:

```text
models.providers.omniroute.request.allowPrivateNetwork=true
```

The recorded test from inside the Gateway returned a successful model-list response, confirming Docker reachability, endpoint response, and acceptance of the environment-backed key for that request. It does not prove successful inference, every model, or approval for sensitive data. Treat all OmniRoute requests as provider-bound and apply the existing privacy rules.

#### Operational checks

Run from the VPS without printing secrets:

```bash
cd /srv/openclaw
docker compose -f compose.yml config --quiet
docker compose -f compose.yml ps
docker compose -f compose.yml exec openclaw-gateway \
  node dist/index.js gateway health
docker compose -f compose.yml exec openclaw-gateway \
  node dist/index.js models status
docker port openclaw-openclaw-gateway-1
```

Expected recorded results are a healthy Gateway, `Gateway Health / OK`, default model `omniroute/leo-one-free`, and a loopback-only `127.0.0.1:18789` mapping. Review logs only after checking for tokens, keys, cookies, prompts, private paths, and provider secrets.

For a current network observation, use Docker network names rather than persisting container IPs:

```bash
docker inspect openclaw-openclaw-gateway-1 \
  --format '{{range $name, $network := .NetworkSettings.Networks}}{{println $name $network.IPAddress}}{{end}}'
```

#### Recovery and pending acceptance

To stop OpenClaw while retaining state, run `docker compose -f /srv/openclaw/compose.yml down`; never use `down -v` or delete `/srv/openclaw`. Restart only the Gateway after a validated change, then rerun Compose status, Gateway health, and model status. Configuration backups are `/srv/openclaw/config/openclaw.json.bak`, `.bak.1`, and `.bak.2`; preserve the current file and validate the intended backup before any rollback.

The deployment evidence does not prove that `/srv/openclaw` is included in the approved R2 backup or that a restore succeeds. It also does not prove sandbox policy, agent/Docker isolation, model generation, or model-specific behavior. Add these to the recovery and security work queue before claiming full acceptance. The Docker-group membership of `leo` remains root-equivalent and is not agent isolation; `allowPrivateNetwork=true` expands network access and requires review if tools or channels are added.

### 9.7 Hermes

Hermes deployment and dashboard evidence is summarized from the Hermes deployment SSOT through 2026-09-26 and the live inventory at 2026-09-27 04:02 UTC. The service is running, but model routing, end-to-end chat, isolation, and recovery are not fully accepted.

#### Deployment identity and runtime

| Item | Value | Status |
|---|---|---|
| Project directory | `/srv/stack/hermes` | `RECORDED` |
| Compose file | `/srv/stack/hermes/compose.yaml` | `RECORDED` |
| Compose service / container | `hermes` / `hermes-agent` | `RECORDED` |
| Image | `nousresearch/hermes-agent:v2026.9.24@sha256:2fd023efbb8d3d2b0ce1a73d028b07370cff34f567cfe0e999553e8c327ea283` (`linux/amd64`) | `RECORDED` pinned child-manifest digest |
| Multi-architecture index digest | `sha256:fca358f12efd65bfaaca05884166f15c0e2788375ca30d77061ac1ebc96452b7` | `RECORDED` |
| Persistent bind mount | `/srv/stack/hermes/data` -> `/opt/data` RW | `RECORDED` |
| Restart policy | `unless-stopped` | `RECORDED` |
| Host dashboard mapping | `127.0.0.1:9119 -> 9119/tcp` only | `RECORDED` |
| Networks | `omni_clients` and `hermes_egress` (`172.29.0.0/16`, `internal=false`) | `RECORDED` |
| Other published ports | No host mapping for Hermes API TCP 8642 recorded | `RECORDED` |
| Effective process UID | Not measured; image config declares `root` | `UNKNOWN` |

The reviewed Compose design runs the official entrypoint with `gateway run`, mounts only Hermes data at `/opt/data`, and does not use host networking, privileged mode, Docker socket, broad host mounts, or OpenClaw-specific networks/secrets. `hermes_egress` is a normal bridge and must not be described as a strict egress allowlist. The dashboard must remain loopback-only unless a separately reviewed access design is approved.

#### Remote dashboard access

Hermes Desktop Remote gateway mode was reported authenticated through an SSH local forward:

```text
Mac 127.0.0.1:19119 -> SSH alias leo-one -> VPS 127.0.0.1:9119 -> Hermes dashboard
```

The Mac endpoint is `http://127.0.0.1:19119`. Dashboard connection to Hermes 0.21.5 was reported successful through 2026-09-26. This demonstrates dashboard-level remote access, not end-to-end chat, WebSocket/session acceptance, or inference.

#### OmniRoute and acceptance

Hermes is attached to `omni_clients`, and Docker DNS reachability to `http://omniroute:20128/v1/models` was demonstrated by a disposable probe returning HTTP 401 without a key. That proves a reachable authenticated endpoint, not Hermes credential setup or successful model access. No successful Hermes model-list or generation test is recorded. Configure only a Hermes-specific protected key after explicit approval; do not reuse OpenClaw secrets or permit unintended public-provider fallback.

Pending acceptance:

- Record a harmless remote chat response, for example `Reply with exactly: HERMES_REMOTE_OK`.
- Configure an approved Hermes-specific OmniRoute provider and verify the exact allowed model list and a harmless generation.
- Verify requests do not fall back to an unintended provider.
- Review effective process UID, mounted state permissions, and actual auth requirements without printing secrets.
- Confirm Hermes state is in a current backup, then perform a representative isolated restore. Source inclusion alone is not restore proof.
- Decide whether SSH local forwarding remains the access model; do not create a public Caddy/Cloudflare route without a separate review.

Safe read-only checks from the VPS:

```bash
cd /srv/stack/hermes
docker compose -f compose.yaml config --quiet
docker compose -f compose.yaml ps
docker inspect hermes-agent --format '{{.Config.Image}} {{json .NetworkSettings.Ports}}'
docker inspect hermes-agent --format '{{range $name, $network := .NetworkSettings.Networks}}{{println $name}}{{end}}'
```

Do not print Hermes `.env`, mounted configuration containing keys, provider credentials, or secret-bearing logs.

### 9.8 Mac SSH tunnel recreation

The Mac-side recreation instructions are in [`_inbox/leo-one-tunnels-recreation.md`](_inbox/leo-one-tunnels-recreation.md). The documented script path is `~/bin/leo-one-tunnels.sh` and SSH alias is `leo-one`; this repository does not contain the live Mac script, so its current contents/process state are not verified here. The recreation guide now specifies six forwards and resolves container IPs on each run, rather than persisting Docker IPs.

| Mac listener (loopback) | VPS/container destination | Service and resolution |
|---:|---|---|
| `127.0.0.1:3000` | Open WebUI container `172.22.*:8080` | Resolve `open-webui` at runtime |
| `127.0.0.1:8080` | VS Code container `172.23.*:8443` | Resolve `vscode-server` at runtime |
| `127.0.0.1:20128` | OmniRoute container `172.22.*:20128` | Resolve the Compose service from `/srv/stack/omniroute` |
| `127.0.0.1:19999` | VPS `127.0.0.1:19999` | Netdata |
| `127.0.0.1:18789` | VPS `127.0.0.1:18789` | OpenClaw Gateway |
| `127.0.0.1:19119` | VPS `127.0.0.1:9119` | Hermes dashboard; Remote gateway connection was reported successful on 2026-09-26 |

Important distinction: Hermes Remote gateway connectivity was reported successful through the sixth local-forward path above. The recreation guide now includes all six forwards, but whether the installed Mac script matches that guide is `UNKNOWN`. Do not claim the live Mac script automates all six until it is inspected.

The reviewed recreation script uses `ssh -fN`, `BatchMode=yes`, `ConnectTimeout=10`, `StrictHostKeyChecking=yes`, `ClearAllForwardings=yes`, `ExitOnForwardFailure=yes`, `ServerAliveInterval=30`, and `ServerAliveCountMax=3`; all Mac listeners bind to `127.0.0.1`. It resolves and validates the three container IPs before cleanup, inspects all managed local port owners, and stops only processes matching the expected local bind, destination/remote port, and SSH alias. Unexpected listeners cause a fail-closed abort. If startup fails, newly started listeners from that run are stopped; previously running managed tunnels are not automatically restored. It does not change VPS services, Docker, firewall, DNS, Caddy, or Cloudflare. Prerequisites are a working non-interactive `leo-one` SSH alias, a pre-verified host key, and Docker access for user `leo`; OpenClaw/Hermes fixed forwards also require their loopback host publications to remain as recorded. The installed Mac script has not been inspected, so these are runbook properties, not verified properties of the live Mac copy.

For the complete script and backup/recovery procedure, use the linked recreation guide. Run these commands on the Mac after placing that script:

```bash
mkdir -p "$HOME/bin"
chmod +x "$HOME/bin/leo-one-tunnels.sh"
"$HOME/bin/leo-one-tunnels.sh"
```

Local URLs: Open WebUI `http://127.0.0.1:3000`; VS Code Server `https://127.0.0.1:8080`; OmniRoute `http://127.0.0.1:20128`; Netdata `http://127.0.0.1:19999`; OpenClaw `http://127.0.0.1:18789`; Hermes Desktop Remote gateway `http://127.0.0.1:19119`. These are local Mac endpoints, not public VPS URLs. The source recreation guide's backup-and-restore commands preserve a timestamped copy before replacing the script; inspect any backup before restoring it.

---

## 10. OmniRoute, Open WebUI, VS Code, and Claude CLI

### 10.1 AI privacy boundary

Ollama was removed on 2026-09-17. Current OmniRoute requests are provider-bound. Secrets, credentials, VPN material, private keys, secret-bearing logs, and unapproved private business/personal/financial/medical data must not be sent through the provider path.

Recorded intended architecture:

```text
Approved clients -> omni_clients -> omniroute:20128 -> selected provider
OmniRoute and provider-egress Redis -> ai_egress
```

The privacy boundary remains `PENDING` until authentication, network membership, route defaults, provider policy, and data classification are independently checked.

### 10.2 OmniRoute

Live state:

- Container: `omniroute-omniroute-1`.
- Image: `diegosouzapw/omniroute:3.8.50`.
- Internal port: 20128/tcp.
- No host port published.
- Container healthy.
- `ai_egress` and `omni_clients` attachment recorded.
- n8n model execution previously completed through `http://omniroute:20128/v1`.
- Dashboard previously reported reconnecting/unreachable.

Required acceptance:

```bash
# Use an approved existing diagnostic container; do not blindly pull a mutable image.
# Test internal /healthz, API, dashboard, and WebSocket behavior.
```

Do not test host `127.0.0.1:20128`; no host port is published. Do not hard-code container IPs.

Status: `CONFIRMED` gateway/container/routing; `PENDING` application acceptance and dashboard behavior.

### 10.3 Open WebUI

Live inventory at 2026-09-27 04:02 records the container as healthy and attached to `ai_clients`, `ai_egress`, and `proxy`. First-run administration, authentication, and successful OmniRoute-only route acceptance remain unverified.

Keep public registration, uploads, RAG, tools, MCP, plugins, and automatic provider fallback disabled until reviewed.

Status: `PENDING`.

### 10.4 VS Code Server

Live inventory at 2026-09-27 04:02 records `vscode-server` running on `linuxserver/code-server:latest`, attached to `dev_internal` and `ai_egress`, with no host-published port. Authentication and route acceptance remain incomplete.

Required:

- Enable application authentication.
- Verify session protection.
- Verify workspace mount and permissions.
- Verify intended AI route through OmniRoute.
- Do not expose publicly.

Status: `PENDING`.

### 10.5 Claude CLI

Prior evidence recorded access to OmniRoute but provider error:

```text
401 No active credentials for provider: anthropic
```

Resolve through approved secret storage and run only a harmless test. Never place credentials in chat, logs, Compose, or this document.

Status: `PENDING`.

---

## 11. WireGuard

### 11.1 Current configuration

| Item | Value | Status |
|---|---|---|
| Interface | `wg0` | `RECORDED` |
| Port | UDP 51820 | `CONFIRMED` listener/UFW |
| Network | `10.77.77.0/24` | `RECORDED — sensitive` |
| Server address | `10.77.77.1/24` | `RECORDED — sensitive` |
| Routing | IPv4 full tunnel | `CONFIRMED design` |
| IPv6 full tunnel | Not configured | `DEFERRED` |

### 11.2 Live peer evidence

At approximately `2026-09-19 15:28:13 UTC`:

| Peer address | Mapping | Handshake state |
|---|---|---|
| `10.77.77.2/32` | Old `android-leo` | Recent handshake |
| `10.77.77.3/32` | Old `mac-leo` | No recent handshake |
| `10.77.77.4/32` | Old `windows-leo` | No recent handshake |
| `10.77.77.5/32` | Old `iphone-leo` | No recent handshake |
| `10.77.77.6/32` | Old `moto-leo` | Recent handshake |
| `10.77.77.7/32` | Replacement `leo-one-mac` | Zero handshake |
| `10.77.77.8/32` | Replacement `leo-one-android` | Zero handshake |
| `10.77.77.9/32` | Replacement `leo-one-iphone` | Zero handshake |
| `10.77.77.10/32` | Replacement `leo-one-moto` | Zero handshake |
| `10.77.77.11/32` | Replacement `leo-one-windows` | Zero handshake |

Status: `PENDING — replacement migration not complete`.

Rules:

- Migrate one device at a time.
- Never run old and replacement full-tunnel profiles concurrently on one device.
- Verify a recent handshake, increasing transfer counters, and exit IP `89.58.63.213` for each replacement.
- Remove old peers only after all replacements are confirmed.
- Never share private keys, complete profiles, or `wg0.conf`.

---

## 12. Backup and recovery

### 12.1 Current evidence

The documented R2 process after credential rotation opened the repository and produced snapshot `fdbdc472` at `2026-09-19 08:47:28`, including `/srv/stack`. Vaultwarden inclusion through `/srv/stack` is confirmed.

The baseline local/R2 repositories were restored-tested on 2026-09-09 before later AI/Kasm/Vaultwarden additions were fully incorporated.

### 12.2 Current status

| Area | Status |
|---|---|
| Fresh R2 snapshot after credential rotation | `CONFIRMED` |
| `/srv/stack` in fresh R2 snapshot | `CONFIRMED` |
| Current n8n dump | `PENDING` until file and `pg_restore --list` evidence |
| Current Nextcloud backup | `PENDING/CONFLICT` until fresh listing/check/restore |
| Kasm volumes/database coverage | `PENDING` |
| OmniRoute/Redis state coverage | `PENDING` |
| Open WebUI state | `PENDING` |
| VS Code/workspaces state | `PENDING` |
| `/etc/wireguard` coverage | `PENDING` |
| Netdata state | `PENDING` |
| Repository integrity checks | `PENDING` |
| Representative restore from each repository | `PENDING` |
| n8n application restore | `PENDING` |
| Kasm application restore | `PENDING` |
| Vaultwarden restore | `DEFERRED` by owner |
| Disaster-recovery readiness | `NOT CLAIMED` |

### 12.3 Required completion chain

1. Check active process and lock holder.
2. Verify secret file ownership/modes without printing contents.
3. Create and validate n8n custom-format dump.
4. Run local backup.
5. Run R2 backup through the existing script.
6. List latest snapshots.
7. Confirm current paths are included.
8. Run `restic check` for both repositories.
9. Restore representative harmless files.
10. Perform controlled n8n and Kasm application restore drills.
11. Record timestamp, snapshot IDs, coverage, restore result, retention, and rollback assumptions.

Never delete production volumes or restore over live databases.

---

## 13. Vaultwarden

### 13.1 Confirmed state

Evidence date: `2026-09-19`.

- Version `1.37.3` deployed and healthy.
- Public hostname: `vault.trisektor.org`.
- HTTPS route: HTTP/2 200.
- `/alive`: HTTP/2 200.
- HTTP redirects to HTTPS.
- No host port published; internal port 80 only.
- Fresh R2 backup includes `/srv/stack`, which covers Vaultwarden data.
- Cloudflare Access was not applied initially to preserve Bitwarden client compatibility.
- Public registration remains temporarily enabled.
- Restore test is deferred by owner.

### 13.2 Outstanding work

- Onboard the six-account family target.
- Test web vault, browser extension, mobile, and desktop clients as applicable.
- Confirm synchronization.
- Enable 2FA and store recovery codes offline.
- Disable public registration after onboarding and client tests.
- Confirm `SIGNUPS_ALLOWED=false` from a private browser session.
- Record exact image digest in SSOT.
- Add backup-failure monitoring.
- Perform restore test when owner approves.

Never record Vaultwarden passwords, admin tokens, Argon2id hashes, database contents, recovery codes, or `.env` values.

---

## 14. Security and hardening

### 14.1 Confirmed controls

- Older 2026-09-19 UFW evidence recorded active status and default incoming/routed deny; current UFW rules were not obtained on 2026-09-27.
- Cloudflare proxy and Full (strict) TLS documented.
- Cloudflare Zero Trust owner-confirmed for n8n, Nextcloud, and Kasm.
- Nextcloud unauthenticated Access enforcement live-confirmed.
- Origin CA used by Caddy.
- Database services have no host-published ports.
- OmniRoute has no host-published port.
- AI services intended to remain private.
- Secrets stored outside Git in restricted paths.
- WireGuard IPv4 full tunnel available.
- Kasm browser access is through `desktop.trisektor.org`.

### 14.2 Security gaps

1. Verify Kasm browser login, session launch, and WebSocket behavior after removal of the host TCP 3389 mapping; perform the separate outside-in 8443/IPv4/IPv6 and Docker NAT review.
2. Rotate Kasm token material exposed in uploaded terminal/log artifacts.
3. Verify exact Cloudflare policy exports and authorized flows.
4. Verify n8n webhook behavior through Access.
5. Test Nextcloud/Kasm non-browser clients through intended access design.
6. Verify AI network membership and privacy controls.
7. Review Docker group and agent isolation.
8. Review SSH keys-only access and root-login policy without losing recovery.
9. Pin floating images.
10. Define Kasm upgrade and rollback policy.
11. Add protected Netdata alerting.
12. Verify backup coverage and restore drills before origin hardening.

### 14.3 Secret exposure incident

The uploaded Kasm terminal file contains token-bearing log material. Treat the following as exposed:

- Kasm registration/session token material.
- Kasm host/manager token material.
- Any similar secret-bearing log values in the same artifact.

Remediate by supported rotation/re-registration. Do not copy values into this document or attempt manual token edits.

---

## 15. Claim-level conflict register

| Claim | Conflicting or supporting sources | Controlling evidence | Current status | Required AI behavior |
| --- | --- | --- | --- | --- |
| Nextcloud maintenance mode cleared | Older 2026-09-09/13 completion claims vs failed 2026-09-12 backup attempt | Fresh `occ status` and maintenance read-back at 2026-09-19 15:18:27 UTC; post-repair status at approximately 15:23 UTC | `CONFIRMED` | May state that Nextcloud is not in maintenance mode |
| Nextcloud repair completed | Older completion claims vs missing dated repair output | `maintenance:repair --include-expensive` completed approximately 15:22 UTC; post-status showed no DB upgrade pending | `CONFIRMED` | May state repair completed; do not infer backup recoverability |
| Nextcloud quota set to 180 GB | Earlier quota claim vs later uncertainty | Fresh `occ user:info leo` at 15:18:27 UTC: quota 180 GB | `CONFIRMED` | May state the quota is verified |
| Nextcloud background jobs operating | Earlier completion claims vs post-incident uncertainty | Job list showed execution through 15:15 UTC | `CONFIRMED — recent execution observed` | Do not infer mail delivery or client acceptance |
| Nextcloud service containers running | Historical uncertainty vs live Docker state | Nextcloud/cron up; MariaDB healthy; Redis up at approximately 15:21 UTC | `CONFIRMED — container/service level` | Do not equate this with restore readiness |
| Nextcloud public route protected by Cloudflare Access | Owner confirmation vs older deferred records | Requests to `/` and `/status.php` returned Access HTTP 302 at 15:21:06 UTC | `CONFIRMED — unauthenticated protection` | Preserve Access; do not bypass it |
| Nextcloud authenticated client acceptance | Historical client tests vs current unauthenticated evidence | Current authenticated browser/client/WebDAV/CalDAV/CardDAV tests not supplied | `PENDING` | Test through intended Access-aware path |
| Nextcloud backup complete | Older handoffs vs missing current artifact chain | Snapshot/check/restore evidence not supplied for current state | `CONFLICT` | Treat as unverified |
| Kasm is served through `desktop.trisektor.org` | Kasm SSOT, owner statement, and Caddy route | Owner confirms mapping and Zero Trust; Caddy route/admin login were tested before the 2026-09-27 gateway change; post-change browser acceptance pending | `RECORDED; post-change acceptance PENDING` | Use the protected hostname as the normal route and re-test after the port change |
| Cloudflare Zero Trust protects Kasm browser route | Owner confirmation and route evidence vs older deferred documents | Owner confirmation for `desktop.trisektor.org`; exact policy export pending | `OWNER-CONFIRMED` | Preserve protection; do not infer policy details |
| Kasm runtime is operational | Kasm terminal health/heartbeat/admin evidence and live container health | Repeated API/RDP health checks HTTP 200; Kasm components healthy | `CONFIRMED` | Do not infer recovery readiness |
| TCP 8443 belongs to Kasm | Listener ambiguity vs live Docker mapping | `kasm_proxy` maps host 8443 to container 443 | `CONFIRMED — ownership` | Preserve Caddy upstream; do not alter blindly |
| TCP 3389 belongs to Kasm | Listener ambiguity vs live Docker/configuration | Kasm RDP gateway owns the internal port; 2026-09-27 ~04:22 follow-up showed no host mapping/listener | `CONFIRMED — internal ownership; host publication removed` | Do not advertise direct RDP; host mapping removal is already completed |
| TCP 3389 is required for normal Kasm browser access | Direct RDP publication vs documented Cloudflare/Caddy browser route | Normal documented route uses `desktop.trisektor.org`; direct 3389 requirement not demonstrated | `NOT REQUIRED BY DOCUMENTED ARCHITECTURE` | Do not advertise direct 3389 |
| TCP 3389 public exposure is acceptable | Older live mapping vs browser-only owner decision and gateway follow-up | Owner chose browser-only; Compose mapping removed; Docker inspect and `ss` showed no host publication/listener at ~04:22 UTC | `RESOLVED — mapping removed`; outside-in audit remains pending | Do not restore without explicit approval; test browser/session and audit remaining exposure separately |
| Telemetry ports 4317/8125/19999 are publicly exposed | Prior listener observation vs live bind ownership | OTEL and Netdata listeners are loopback-only | `CONFIRMED LOOPBACK-ONLY` | Do not expose them |
| OmniRoute has public host exposure | Dashboard concern vs live Docker port inspection | OmniRoute has internal 20128/tcp and no host mapping | `CONFIRMED PRIVATE HOST BINDING` | Preserve private routing |
| OmniRoute is application-operational | Docker health and n8n model test vs dashboard reconnecting issue | Internal health/API/WebSocket acceptance not fully supplied | `PENDING APP ACCEPTANCE` | Do not equate container health with acceptance |
| `ai_clients` network is absent or unused | Older SSOT marks the network historical vs 2026-09-27 live inventory | Docker inventory shows `ai_clients` exists and Open WebUI is a member | `RESOLVED — exists and membership recorded` | Do not delete or detach based on older notes; recheck live only before a membership change |
| AI privacy boundary is enforced | Ollama removal and intended architecture vs missing auth/data tests | Network membership, auth, defaults, provider policy, classification evidence incomplete | `PENDING` | Never send secrets; require approval for private data |
| WireGuard migration complete | Replacement profiles staged vs live handshake output | Old `.2` and `.6` have handshakes; replacements `.7`–`.11` have zero | `PENDING — NOT COMPLETE` | Do not remove old peers |
| Fresh R2 backup exists | Post-rotation backup evidence | Snapshot `fdbdc472` at 2026-09-19 08:47:28 including `/srv/stack` | `CONFIRMED — snapshot` | Do not infer full coverage or restore readiness |
| All persistent services are recoverable | Older baseline restores vs later service additions | Current coverage and application restore drills incomplete | `PENDING` | Do not claim disaster recovery readiness |
| Kasm backup and restore complete | Healthy runtime vs missing restore drill | No non-production Kasm restore evidence | `PENDING` | Do not claim Kasm recoverability |
| n8n owner and backup complete | 2026-09-09 progress handoff vs pending register | Current account check, dump, key recovery, snapshot, and restore not all evidenced | `CONFLICT/PENDING` | Do not claim operational acceptance |
| Kasm token material remains uncompromised | Secret boundary vs uploaded token-bearing logs | `kasem-update-terminal.txt` contains token-bearing Kasm log lines | `FAILED — ROTATION REQUIRED` | Rotate affected material; never reproduce values |
| Container images are immutably pinned | Local digests observed vs running floating tags | n8n, VS Code, Open WebUI, and rolling Kasm tags remain mutable in Compose/inventory | `PENDING` | Pin one stack at a time with rollback |
| Vaultwarden recovery-tested | Healthy deployment and R2 inclusion vs owner-deferred restore | No Vaultwarden restore test | `DEFERRED` | Do not claim recovery-tested status |
| OpenClaw recovery/security accepted | Healthy Gateway and model-list test vs missing backup, restore, sandbox, isolation, and inference evidence | OpenClaw deployment SSOT dated 2026-09-21 | `PENDING` | Verify coverage, restore, policy, and approved inference before claiming acceptance |
| Running container total | Earlier baseline prose says 21; owner-supplied live output and its named inventory enumerate 22 | `docker ps`-based output at 2026-09-27 04:02:24 UTC: 8 Kasm + 14 other; 22 names in total | `RESOLVED — 22 in that dated snapshot` | Do not repeat the 21 count or request another check to resolve this snapshot; obtain a new count only if current post-snapshot state is needed |
| OpenClaw host exposure | Older 2026-09-21 no-publication report vs 2026-09-27 live inventory | `openclaw-openclaw-gateway-1` maps only `127.0.0.1:18789 -> 18789`; no wildcard mapping recorded | `RESOLVED — loopback-only mapping recorded` | Use the SSH tunnel; do not describe this as no host publication |
| Hermes deployment / dashboard access | Hermes progress SSOT through 2026-09-26 and 2026-09-27 inventory | Pinned image running; `127.0.0.1:9119`; successful Mac Remote gateway connection reported | `DEPLOYED; chat/model/recovery acceptance PENDING` | Do not mark Hermes deferred or infer inference success |

For every future conflict, add a row before changing the dashboard or task register. A conflict is resolved only by fresh evidence, not by choosing the newest prose document.

---

## 16. Master task register

### Critical

- [x] Verify Nextcloud `occ status`; maintenance mode is off.
- [x] Verify Nextcloud repair and post-repair state.
- [x] Verify Nextcloud user `leo` quota reads 180 GB.
- [x] Verify recent Nextcloud background-job execution.
- [x] Map listeners 3389, 8443, 4317, 8125, and 19999.
- [x] Confirm Kasm runtime, API, RDP gateway, and public route evidence.
- [x] Confirm OmniRoute has no host-published port.
- [x] Confirm fresh post-rotation R2 snapshot evidence including `/srv/stack`.
- [ ] Rotate/remediate Kasm token-bearing log exposure.
- [x] Remove Kasm host TCP 3389 publication after browser-only decision; gateway health and absence of host listener verified at ~04:22 UTC.
- [ ] Verify Kasm browser/session/WebSocket after the change and complete outside-in 8443/IPv4/IPv6 plus Docker NAT review.
- [ ] Verify n8n encryption-key copy out-of-band.
- [ ] Create and validate n8n PostgreSQL custom-format dump.
- [ ] Verify current local/R2 backup coverage.
- [ ] Run Restic integrity checks.
- [ ] Restore representative files from local and R2 repositories.
- [ ] Complete n8n isolated restore drill.
- [ ] Complete Kasm isolated restore drill.
- [ ] Verify `/etc/wireguard` backup coverage.
- [ ] Verify current Kasm, AI, Open WebUI, VS Code, and workspace coverage.
- [ ] Verify `/srv/openclaw` backup coverage and perform a representative restore test.

### High

- [ ] Complete authenticated Nextcloud browser/client/WebDAV/CalDAV/CardDAV tests.
- [ ] Complete n8n owner-account verification and harmless workflow test.
- [ ] Test n8n webhook behavior through the intended Cloudflare policy.
- [ ] Diagnose OmniRoute `/healthz`, dashboard API, and WebSocket acceptance.
- [ ] Verify AI network membership and privacy controls.
- [ ] Enable and test VS Code Server authentication.
- [ ] Complete Open WebUI first-run setup, authentication, network, and OmniRoute route test.
- [ ] Resolve Claude CLI provider authentication and run harmless request.
- [ ] Complete WireGuard replacement migration; verify handshakes and exit IPs.
- [ ] Export/document Cloudflare Zero Trust policy structure and authorized tests.
- [ ] Complete Hermes remote chat, approved OmniRoute model-list/generation, provider-fallback, runtime UID, and restore acceptance.
- [ ] Complete Vaultwarden onboarding, client tests, synchronization, 2FA, and registration lock-down.
- [ ] Review OpenClaw sandbox/isolation policy and run an approved harmless inference test.

### Medium

- [ ] Pin floating image tags to reviewed immutable digests.
- [ ] Record tested rollback images and one-stack upgrade procedure.
- [ ] Record exact Vaultwarden image digest.
- [ ] Define Kasm upgrade/rollback policy.
- [ ] Review SSH hardening and recovery path.
- [ ] Review Docker group and AI-agent isolation.
- [ ] Review Netdata warnings.
- [ ] Add protected monitoring and backup-failure alerting.
- [ ] Perform Vaultwarden restore test when owner approves.

### Deferred by design

- [ ] IPv6 WireGuard full tunnel.
- [ ] Origin IP hardening, Authenticated Origin Pulls, or Cloudflare Tunnel migration.
- [ ] OmniRoute public exposure.
- [ ] Public Hermes route or dashboard exposure (deferred; keep SSH-forwarded loopback access unless separately approved).
- [ ] Agent access to Docker socket, Docker group, `stack-secrets`, WireGuard, unrestricted sudo, or Caddy keys.

---

## 17. Change Record

| Date | Change | Evidence | Result/follow-up |
|---|---|---|---|
| 2026-09-17 | Established canonical SSOT and anti-hallucination contract | Consolidation of source documents | This file remains operational authority |
| 2026-09-17 | Implemented `omni_clients` AI bridge and removed Ollama | Live network/model evidence | n8n route confirmed; privacy/application acceptance pending |
| 2026-09-17 | Owner confirmed Cloudflare Zero Trust for n8n, Nextcloud, and Kasm | Owner statement | Protection treated as enabled; exact policy tests pending |
| 2026-09-19 | Deployed Vaultwarden and verified post-rotation R2 snapshot | Public route, health, snapshot `fdbdc472` including `/srv/stack` | Service operational; signup and restore remain pending/deferred |
| 2026-09-19 | Corrected evidence directory location | `/root` attempt failed; user-owned evidence directory created | No production state changed by failed attempt |
| 2026-09-19 | Verified Nextcloud application and repair state | Live `occ` evidence at 15:18–15:23 UTC | Version 34.0.3.2; maintenance off; repair complete; no DB upgrade pending; quota 180 GB |
| 2026-09-19 | Verified Nextcloud services and Access enforcement | Docker/Compose and HTTP 302 Access results around 15:21 UTC | Containers running; MariaDB healthy; unauthenticated Access protection confirmed |
| 2026-09-19 | Reconciled UFW, listeners, Docker mappings, and service inventory | Evidence directory `/home/leo/vps-reconcile-20260919T152813Z` | 8443 maps to Kasm proxy; 3389 maps to Kasm RDP gateway; 4317/8125/19999 loopback-only; OmniRoute private |
| 2026-09-19 | Reconciled WireGuard peer handshakes | `wg show wg0 latest-handshakes` and transfer output | Old `.2` and `.6` active; replacements `.7`–`.11` inactive; migration remains pending |
| 2026-09-19 | Confirmed Kasm runtime health and intended route | Kasm terminal evidence, health checks, heartbeats, administrator activity, owner route statement | Runtime and browser route confirmed; backup/recovery pending |
| 2026-09-19 | Recorded Kasm token-bearing log exposure | `kasem-update-terminal.txt` contains token material | Treat affected material as exposed; rotate and remove/redact artifact |
| 2026-09-19 | Confirmed historical `ai_clients` network still exists | Live Docker network inventory | Membership requires verification; do not delete blindly |
| 2026-09-19 | Confirmed current image inventory includes mutable tags | Live Docker inventory and image digests | Record current/rollback digests; immutable Compose pinning remains pending |
| 2026-09-21 | Deployed OpenClaw from pinned tag `v2026.9.5` and configured OmniRoute integration | OpenClaw deployment SSOT; Gateway health, model status, model-list, and empty `docker port` evidence | At that time the Gateway was recorded healthy with no host publication; superseded by the 2026-09-27 loopback-only `127.0.0.1:18789` mapping; backup/restore, sandbox, isolation, and inference acceptance remain pending |
| 2026-09-22 | Revalidated SSOT structure and agent cross-references | Native conflict table, sequential section audit, evidence-date audit, and Markdown/error checks | Navigation map added; OpenClaw references aligned; no new service state claimed |
| 2026-09-27 | Reconciled current host inventory, Hermes deployment, OpenClaw mapping, persistent mounts, and Mac tunnel references | `_inbox/VPS-Key-Baseline-Information (5).md`, `_inbox/hermes_ssot_progress.md`, and `_inbox/leo-one-tunnels-recreation.md`; evidence through ~04:22 UTC | Updated current inventory and limits; Hermes model/chat/recovery and exact live Mac script state remain pending/unknown |
| 2026-09-27 ~04:21–04:22 | Removed Kasm RDP gateway host TCP 3389 publication | Approved Compose-only `ports: []` change, Compose validation, gateway recreation, `docker inspect`, `docker port`, and `ss` follow-up as recorded in key baseline | Gateway running/healthy; host 3389 absent; post-change browser/session acceptance and outside-in audit pending |
| 2026-09-27 | Separated generated inventory snapshots from curated SSOT | `scripts/update-vps-state.sh` defaults to `VPS_STATE.snapshot.md` and rejects the canonical file; shell syntax and overwrite-guard check passed | Prevents routine refresh from replacing service runbooks and agent task context |
| 2026-09-27 | Hardened the Mac SSH tunnel recreation runbook | `_inbox/leo-one-tunnels-recreation.md`; embedded script and install procedure checked with `bash -n` | Added strict host-key verification, inherited-forward clearing, exact destination ownership checks, subnet preflight, partial-start cleanup, atomic backup/install/restore, listener verification, and troubleshooting; installed Mac script remains unverified |
| 2026-09-27 | Clarified evidence freshness and agent lookup behavior | Review of dashboard, service sections, task register, network memberships, UDP 443 listener evidence, and container-count conflict | Added explicit no-repeat rule, marked local source-note availability, date-bound tracker evidence, resolved `ai_clients` membership, corrected UDP 443 host-exposure wording, and moved count reconciliation to recordkeeping priority |
| 2026-09-27 | Corrected the container total in the canonical state | Leo-supplied `docker ps`-based output and targeted inspection at 04:02:24 UTC, enumerating 8 Kasm + 14 non-Kasm containers | Recorded 22 running containers for that snapshot; identified 21 as an arithmetic error; no new VPS command was run |

### Future entry format

```markdown
| YYYY-MM-DD | Material change | Command/test/source evidence | Result, residual risk, and rollback |
```

---

## 18. Recovery rules

- Never delete Docker named volumes during troubleshooting.
- Never restore against a live production database without an approved restore plan.
- Stop the affected application before database restore.
- Preserve the exact n8n encryption key for credential decryption.
- Confirm target and destination before every restore.
- Keep console/SSH recovery available before firewall or origin hardening.
- Keep Cloudflare Full (strict) and Origin CA paths aligned.
- Do not rotate keys, certificates, VPN profiles, or secrets without a tested migration/rollback.
- Treat Kasm token-bearing logs as compromised until rotation is complete.
- Do not remove old WireGuard peers until replacement handshakes and exit IPs are proven.
- Do not claim disaster recovery readiness until current service restore drills pass.

---

## 19. Final operational position

As of the latest supplied evidence cutoff, 2026-09-27 ~04:22 UTC:

```text
Containers: 22 running in owner-supplied 2026-09-27 04:02:24 UTC snapshot (8 Kasm + 14 others); later state not implied
Nextcloud application and repair state: RESOLVED
Nextcloud quota and recent background jobs: RESOLVED/CONFIRMED
Nextcloud unauthenticated Cloudflare Access protection: CONFIRMED
Kasm route and runtime health: CONFIRMED
Kasm browser endpoint: desktop.trisektor.org
Kasm Cloudflare Zero Trust protection: OWNER-CONFIRMED
Kasm TCP 8443 ownership: CONFIRMED
Kasm internal TCP 3389 ownership: CONFIRMED
Kasm host TCP 3389 publication: REMOVED; no host listener in ~04:22 evidence
Kasm post-change browser/session and outside-in exposure audit: PENDING
Kasm token-bearing log exposure: FAILED — ROTATION REQUIRED
Telemetry listener ownership/bindings: CONFIRMED LOOPBACK-ONLY
OmniRoute private host binding: CONFIRMED
OmniRoute application/dashboard acceptance: PENDING
OpenClaw Gateway runtime and model-list path: RECORDED HEALTHY
OpenClaw host mapping: 127.0.0.1:18789 -> 18789 (loopback-only)
OpenClaw backup/restore/sandbox/isolation/inference acceptance: PENDING
Hermes deployment: RUNNING; 127.0.0.1:9119; pinned amd64 image recorded
Hermes remote dashboard: CONNECTED via Mac loopback 19119 -> VPS loopback 9119 (reported through 2026-09-26)
Hermes chat/model/fallback/isolation/restore acceptance: PENDING
Fresh R2 snapshot after credential rotation: CONFIRMED
Current all-service backup coverage: PENDING
Repository integrity and restore drills: PENDING
n8n dump/key/owner/restore acceptance: PENDING
WireGuard replacement migration: PENDING
AI privacy enforcement: PENDING
Cloudflare policy export/authorized tests: PENDING
VS Code/Open WebUI/Claude acceptance: PENDING
Vaultwarden onboarding/2FA/registration lock-down: PENDING
Image pinning and rollback records: PENDING
SSH/Docker isolation and monitoring alerting: PENDING
Disaster-recovery readiness: NOT CLAIMED
```

The VPS is operational, but it is not yet accepted as ready for unattended production change or enterprise-grade disaster recovery. The host-side Kasm 3389 mapping removal is complete; verify post-change browser/session behavior and remaining exposure separately. Prioritize Kasm token remediation, current backup coverage and restore tests, WireGuard migration, and application-level acceptance for OpenClaw, Hermes, and the other services one stack at a time.

**End of updated SSOT.**
