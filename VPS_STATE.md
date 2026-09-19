# VPS-CUPNET / Leo One

## Enterprise Operational Single Source of Truth

**Document status:** Updated reconciliation baseline  
**Document version:** 3.4-reconciliation  
**Last updated:** 2026-09-19  
**Primary evidence cutoff:** 2026-09-19, including live VPS reconciliation, Nextcloud repair verification, Kasm terminal evidence, and Vaultwarden deployment evidence  
**Owner:** Leo  
**Provider:** netcup / Cupnet  
**Classification:** Private internal operations document  
**Canonical file:** `VPS_STATE.md`

> This document consolidates the prior SSOT and the fresh verification evidence supplied during the 2026-09-19 reconciliation session. It is the operational authority for AI clients and operators. Do not create parallel handoff files. Update this file and its Change Record after every material change.

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
- Use Docker DNS service names, never historical container IP addresses, in persistent configuration.
- Propose read-only inspection first for unknown state.
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
| Host identity / hostname | `P` | N/A | Recheck live host baseline |
| UFW / listener ownership | `P` | N/A | Especially 3389 / 8443 / 4317 / 8125 |
| Caddy / Cloudflare TLS | `LV` | Live evidence | Public route and TLS path recorded |
| Nextcloud runtime | `LV` | Live evidence | Repair and status confirmed |
| Nextcloud backups / restore | `P` | N/A | Restore not proven |
| n8n runtime | `LV` | Live evidence | Runtime confirmed; dump/restore still pending |
| n8n encryption key / dump path | `P` | N/A | Recovery not yet proven |
| Kasm route / admin login | `LV` | Live evidence | Browser route and login confirmed |
| Kasm port exposure / RDP decision | `P` | N/A | Direct 3389 must be resolved |
| Kasm backup / restore | `P` | N/A | Not yet proven |
| OmniRoute runtime | `LV` | Live evidence | Container/runtime confirmed |
| OmniRoute dashboard / API / WebSocket | `P` | N/A | Acceptance incomplete |
| WireGuard migration | `P` | N/A | Old peers must not be removed yet |
| Vaultwarden route / service | `LV` | Live evidence | Startup and route confirmed |
| Vaultwarden onboarding / 2FA / lockdown | `P` | N/A | Not complete |
| Backup repository / restore drill | `P` | N/A | Snapshot exists, restore not proven |
| Cloudflare Zero Trust | `OC` | Owner-confirmed | Policy details and client tests still pending |

Update rule:
- Directly checked live: `LV`
- Confirmed by Leo but not independently rechecked: `OC`
- Uncertain or unproven: `P`

---

## 1. Executive current position

The VPS is a functioning multi-service Docker platform with Cloudflare/Caddy public routes, private AI services through OmniRoute, WireGuard, Nextcloud, n8n, Kasm, and Vaultwarden.

The 2026-09-19 reconciliation resolved several documentation uncertainties:

- Nextcloud maintenance mode, repair, quota, service state, and post-repair database state are confirmed.
- Kasm runtime health, public route, administrator access, and RDP gateway ownership are confirmed.
- Listener ownership for TCP `8443`, TCP `3389`, TCP `4317`, UDP/TCP `8125`, and TCP `19999` is confirmed.
- OmniRoute has no host-published port in the live inventory.
- The existing R2 fresh snapshot after credential rotation is documented and includes `/srv/stack`.
- The intended Kasm browser route is `https://desktop.trisektor.org` through Cloudflare Zero Trust and Caddy.

The following remain unresolved or require controlled remediation:

- Direct public TCP `3389` is published by Kasm’s RDP gateway and is separate from the Cloudflare-protected browser route.
- Kasm token-bearing logs were uploaded and must be treated as exposed; affected token material requires rotation.
- Current all-service backup coverage, repository integrity, and application restore drills are not fully proven.
- n8n owner account, dump, independent encryption-key recovery, and isolated restore are not fully proven.
- WireGuard replacement peers have no documented handshakes; old peers must not be removed.
- OmniRoute application-level dashboard/API/WebSocket acceptance remains incomplete despite container health and n8n model execution.
- AI network membership and privacy-boundary enforcement require verification.
- Open WebUI, VS Code Server, and Claude CLI acceptance remains incomplete.
- Vaultwarden onboarding, 2FA, registration lock-down, and restore remain incomplete.
- Floating image tags remain in use.
- SSH hardening, Docker/agent isolation, monitoring alerting, and disaster-recovery drills remain incomplete.

---

## 2. Current state dashboard

| Area | Current documented state | Evidence date | Status | Next action |
|---|---|---:|---|---|
| Host identity | Debian 13 Trixie; hostname `v2202609410969512760`; hardware access warnings were non-fatal | 2026-09-19 | `RECORDED/CONFIRMED` | Recheck full host baseline when convenient |
| Compute/storage | 8 vCPU, approximately 16 GiB RAM, approximately 503 GiB filesystem; fresh Kasm heartbeat showed approximately 10.3% disk used | 2026-09-19 | `RECORDED/CONFIRMED` | Continue capacity monitoring |
| UFW | Active; incoming/routed deny; TCP 22/80/443 and UDP 51820 allowed; no explicit 3389 or 8443 rules | 2026-09-19 | `CONFIRMED` | Reconcile Docker-published Kasm ports with intended exposure |
| Caddy | Running; ports 80/443; Cloudflare Origin CA model; public reverse-proxy routes | 2026-09-19 | `CONFIRMED` | Validate configuration before changes |
| Nextcloud | Version 34.0.3.2; maintenance off; repair complete; no DB upgrade pending; `leo` quota 180 GB; recent jobs; MariaDB healthy; Redis running | 2026-09-19 | `CONFIRMED` application state | Verify backup/restore and authenticated clients |
| n8n | Running with PostgreSQL; public route documented; no host ports | 2026-09-19 | `RECORDED/CONFIRMED` container state | Verify owner, dump, key recovery, restore, and webhook behavior |
| Kasm | Runtime/API/RDP health confirmed; public route and admin login confirmed; `desktop.trisektor.org` is the intended browser route | 2026-09-19 | `CONFIRMED` runtime; `PENDING` recovery/security acceptance | Rotate exposed token material; decide/remediate direct 3389 exposure; verify restore |
| TCP 8443 | `kasm_proxy` publishes host 8443 to internal Kasm HTTPS 443 | 2026-09-19 | `CONFIRMED` mapping; security acceptance pending | Preserve Caddy upstream and test rollback before changing |
| TCP 3389 | `kasm_rdp_gateway` publishes host 3389 on IPv4 and IPv6 | 2026-09-19 | `CONFIRMED` ownership; `PENDING` security disposition | Normal access is through Cloudflare/Caddy; test whether host publication can be removed safely |
| Telemetry 4317/8125/19999 | OTEL and Netdata listeners are loopback-only | 2026-09-19 | `CONFIRMED` loopback mapping | Do not expose; document ownership |
| Ollama | Removed; no approved local model route | 2026-09-17 | `CONFIRMED` | Do not recreate without architecture decision |
| OmniRoute | Healthy container; `omni_clients` and `ai_egress`; no host port; n8n model execution previously succeeded | 2026-09-19 | `CONFIRMED` container/routing; `PENDING` app acceptance | Test `/healthz`, dashboard API, WebSocket, and privacy boundary |
| Open WebUI | Running and healthy; final network/auth/route acceptance not fully evidenced | 2026-09-19 | `PENDING` | Verify final network membership, authentication, and OmniRoute route |
| VS Code Server | Running privately; image uses floating `latest`; authentication acceptance incomplete | 2026-09-19 | `PENDING` | Enable/test authentication and verify network/mount boundary |
| Claude CLI | Gateway path recorded; provider authentication previously returned 401 | 2026-09-17 | `PENDING` | Resolve credentials through approved secret mechanism and harmless test |
| WireGuard | Standard IPv4 full tunnel; ten peers configured; old `.2` and `.6` had recent handshakes; replacements `.7`–`.11` had zero | 2026-09-19 | `PENDING` migration | Migrate one device at a time; verify handshake and exit IP |
| Backups | R2 repository opened after credential rotation; snapshot `fdbdc472` at 2026-09-19 08:47:28 included `/srv/stack`; full current coverage and restore not proven | 2026-09-19 | `CONFIRMED` fresh snapshot; `PENDING` recovery | Run repository checks, coverage verification, representative restores, and application drills |
| Cloudflare Zero Trust | Owner confirms protection for n8n, Nextcloud, and Kasm; Nextcloud unauthenticated redirect confirmed | 2026-09-19 | `OWNER-CONFIRMED/CONFIRMED` | Export policy structure and test authorized flows without bypasses |
| Vaultwarden | Version 1.37.3 healthy; public route, `/alive`, redirect, and R2 inclusion confirmed; signup temporarily enabled | 2026-09-19 | `CONFIRMED/PENDING` | Onboard users, test clients, enable 2FA, disable signup, test restore |
| Image pinning | Several services use `latest` or rolling tags; local digests observed but Compose immutability not proven | 2026-09-19 | `PENDING` | Pin one stack at a time with rollback digests |
| SSH/Docker isolation | Docker membership is root-equivalent; SSH and agent boundary not fully reviewed | 2026-09-19 | `PENDING` | Review without losing console/SSH recovery |
| Monitoring | Netdata loopback access confirmed; alerting design not accepted | 2026-09-19 | `PENDING` | Add protected alerting and review collector warnings |
| Disaster recovery | Baseline restore history predates later AI/Kasm/Vaultwarden additions | 2026-09-19 | `PENDING` | Complete current-service restore drills; do not claim readiness |

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
| RAM | Approximately 16 GiB hardware; approximately 15 GiB visible | `RECORDED` |
| Storage | Approximately 503 GiB filesystem | `RECORDED` |
| Authoritative hostname | `v2202609410969512760` | `CONFIRMED` |
| Authoritative FQDN | `v2202609410969512760.powersrv.de` | `CONFIRMED` |
| Public IPv4 | `89.58.63.213` | `RECORDED — private` |
| Interface | `eth0` | `RECORDED` |
| Administrator | `leo` | `CONFIRMED` |
| Privilege model | `leo` belongs to `docker` and `stack-secrets`; Docker membership is root-equivalent | `CONFIRMED` |
| OS | Debian GNU/Linux 13 Trixie | `RECORDED` |
| Docker Engine | 29.8.0 in prior record; live version should be rechecked | `RECORDED` |
| Docker Compose | v5.5.1 in prior record | `RECORDED` |

Do not paste or record private provider identifiers, secret-bearing configuration, or unrestricted environment output.

---

## 4. Network, firewall, and public exposure

### 4.1 Intended public architecture

```text
Internet
  -> Cloudflare DNS/proxy and Full (strict) TLS
  -> Caddy on host TCP 80/443 and container UDP 443 capability
      -> cloud.trisektor.org  -> Nextcloud
      -> n8n.trisektor.org    -> n8n
      -> desktop.trisektor.org -> https://host.docker.internal:8443 -> Kasm
      -> vault.trisektor.org  -> Vaultwarden

WireGuard wg0 -> IPv4 full tunnel through UDP 51820

Private AI:
  omni_clients -> OmniRoute gateway
  ai_egress    -> OmniRoute and Redis provider-egress path
```

### 4.2 UFW evidence

Live UFW evidence at approximately `2026-09-19 15:28:13 UTC`:

```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
Allowed TCP: 22, 80, 443
Allowed UDP: 51820
IPv6 equivalents: 22, 80, 443 TCP and 51820 UDP
```

No explicit UFW rules exist for TCP 3389 or TCP 8443. This does not alone establish that Docker-published ports are unreachable. Docker port publishing and host firewall/NAT behavior must be considered together.

### 4.3 Live listener mapping

Live `ss` and Docker inspection at approximately `2026-09-19 15:28:13 UTC` mapped the listeners as follows:

| Listener | Owner | Binding | Status |
|---|---|---|---|
| TCP 22 | sshd | `0.0.0.0` and IPv6 | Intended SSH |
| TCP 80 | Docker proxy / Caddy | `0.0.0.0` and IPv6 | Intended HTTP |
| TCP 443 | Docker proxy / Caddy | `0.0.0.0` and IPv6 | Intended HTTPS |
| UDP 443 | Caddy container capability | Container exposes UDP 443; UFW rule absent | QUIC policy requires deliberate verification |
| UDP 51820 | WireGuard | `0.0.0.0` and IPv6 | Intended VPN |
| TCP 8443 | Docker proxy / `kasm_proxy` | `0.0.0.0` and IPv6 | Kasm HTTPS host endpoint |
| TCP 3389 | Docker proxy / `kasm_rdp_gateway` | `0.0.0.0` and IPv6 | Direct Kasm RDP gateway exposure |
| TCP 4317 | `otel-plugin` | `127.0.0.1` | Loopback-only telemetry |
| TCP/UDP 8125 | Netdata | Loopback only | Loopback-only telemetry |
| TCP 19999 | Netdata | `127.0.0.1` | Loopback-only dashboard |

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

The current direct TCP 3389 publication is a separate path:

```text
Internet / host TCP 3389
  -> kasm_rdp_gateway
```

Cloudflare Zero Trust protecting `desktop.trisektor.org` does not automatically protect a direct IP-based TCP 3389 endpoint. The documented browser architecture does not require users to connect directly to port 3389.

Current status:

```text
TCP 3389 ownership: CONFIRMED — Kasm RDP gateway
TCP 3389 normal browser requirement: NOT DEMONSTRATED
TCP 3389 public exposure acceptance: PENDING controlled decision
```

Do not remove the mapping blindly. If removal is approved, preserve the Compose rollback copy, remove only the host-side `3389:3389` publication, leave the internal RDP port intact, recreate only the affected service, and test Kasm browser login, session creation, WebSocket behavior, and listener closure.

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

Live network inventory showed:

| Network | Subnet | Type/status | Intended role |
|---|---|---|---|
| `proxy` | `172.18.0.0/16` | Bridge | Caddy/public proxy |
| `nextcloud_nextcloud_internal` | `172.19.0.0/16` | Internal bridge | Nextcloud, MariaDB, Redis, cron |
| `n8n_n8n_internal` | `172.20.0.0/16` | Bridge | n8n and PostgreSQL |
| `ai_clients` | `172.21.0.0/16` | External bridge; historical | Legacy/old AI network; membership requires verification |
| `ai_egress` | `172.22.0.0/16` | External bridge | OmniRoute provider egress and Redis |
| `dev_internal` | `172.23.0.0/16` | External bridge | VS Code private development network |
| `kasm_default_network` | `172.24.0.0/16` | Bridge | Kasm services |
| `kasm_sidecar_network` | `172.25.0.0/16` | Kasm sidecar network | Kasm sidecars |
| `omni_clients` | `172.26.0.0/16` | `Internal true` | Approved client-to-OmniRoute bridge |
| `host` | Host | Host mode | Docker standard network |
| `bridge` | `172.17.0.0/16` | Default bridge | Docker standard network |

The existence of `ai_clients` is confirmed, but existence alone does not prove that an active service is incorrectly attached. Run a redacted membership check before detaching or deleting anything:

```bash
for network in ai_clients ai_egress omni_clients dev_internal proxy; do
  printf '\n=== %s ===\n' "$network"
  docker network inspect "$network" \
    --format '{{range $id, $c := .Containers}}{{println $c.Name}}{{end}}' \
    2>/dev/null || true
done
```

Policy:

- OmniRoute should use `omni_clients` and `ai_egress`.
- Redis provider-egress should use `ai_egress` only.
- Approved AI clients should use `omni_clients` deliberately.
- Databases, Caddy, and unrelated services must not join AI networks.
- No AI service should have a host-published public port.
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
| UDP 443 | Container capability; UFW policy needs deliberate decision | `PENDING` |
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
- `kasm_rdp_gateway`: healthy, host TCP 3389 to container 3389.
- `kasm_agent`: healthy.
- `kasm_api`: healthy.
- `kasm_manager`: healthy.
- `kasm_guac`: healthy.
- `kasm_db`: healthy.

The uploaded Kasm terminal evidence also shows repeated API and RDP gateway health checks returning HTTP 200, manager/agent heartbeat activity, and authenticated administrator API activity.

Status:

```text
Kasm runtime: CONFIRMED
Kasm API health: CONFIRMED
Kasm RDP gateway health: CONFIRMED
Kasm public browser route: CONFIRMED
Kasm administrator login: CONFIRMED
```

### 9.2 Intended access path

The owner confirms Kasm is mapped to `desktop.trisektor.org` and secured with Cloudflare Zero Trust. Use only this browser endpoint for normal operation:

```text
https://desktop.trisektor.org
```

Do not instruct users to connect directly to TCP 3389.

### 9.3 TCP 3389

The live binding and Kasm configuration prove TCP 3389 belongs to the Kasm RDP gateway. The documented browser route goes through Cloudflare/Caddy and does not demonstrate a need for direct public host port 3389.

Current status:

```text
Ownership: CONFIRMED
Public binding: CONFIRMED
Normal browser requirement: NOT DEMONSTRATED
Security acceptance: PENDING
```

If removal is approved:

1. Confirm actual live Compose path.
2. Copy the current Compose file to a private rollback directory.
3. Remove only host-side `3389:3389`.
4. Keep internal Kasm RDP port 3389.
5. Validate Compose.
6. Recreate only the affected gateway.
7. Test `desktop.trisektor.org` through Cloudflare.
8. Test administrator login, session creation, and WebSocket behavior.
9. Confirm `ss` no longer shows host 3389.
10. Record result and rollback path.

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

Live container is healthy, but final network membership, first-run administration, authentication, and successful OmniRoute-only route are not fully evidenced.

Keep public registration, uploads, RAG, tools, MCP, plugins, and automatic provider fallback disabled until reviewed.

Status: `PENDING`.

### 10.4 VS Code Server

Live container is running on `linuxserver/code-server:latest`. Prior evidence records private deployment but incomplete authentication and route acceptance.

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

- UFW active with default incoming/routed deny.
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

1. Resolve or formally accept direct public TCP 3389 exposure.
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

```markdown
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
| Kasm is served through `desktop.trisektor.org` | Kasm SSOT, owner statement, and Caddy route | Owner confirms mapping and Zero Trust; Caddy route and admin login tested | `CONFIRMED` | Use the protected hostname as the normal route |
| Cloudflare Zero Trust protects Kasm browser route | Owner confirmation and route evidence vs older deferred documents | Owner confirmation for `desktop.trisektor.org`; exact policy export pending | `OWNER-CONFIRMED` | Preserve protection; do not infer policy details |
| Kasm runtime is operational | Kasm terminal health/heartbeat/admin evidence and live container health | Repeated API/RDP health checks HTTP 200; Kasm components healthy | `CONFIRMED` | Do not infer recovery readiness |
| TCP 8443 belongs to Kasm | Listener ambiguity vs live Docker mapping | `kasm_proxy` maps host 8443 to container 443 | `CONFIRMED — ownership` | Preserve Caddy upstream; do not alter blindly |
| TCP 3389 belongs to Kasm | Listener ambiguity vs live Docker/configuration | `kasm_rdp_gateway` maps host 3389 and Kasm config defines proxy port 3389 | `CONFIRMED — ownership` | Treat as separate direct exposure |
| TCP 3389 is required for normal Kasm browser access | Direct RDP publication vs documented Cloudflare/Caddy browser route | Normal documented route uses `desktop.trisektor.org`; direct 3389 requirement not demonstrated | `NOT REQUIRED BY DOCUMENTED ARCHITECTURE` | Do not advertise direct 3389 |
| TCP 3389 public exposure is acceptable | Kasm internal RDP design vs public binding | Live IPv4/IPv6 host binding; UFW has no explicit rule; browser path is separately protected | `PENDING SECURITY DECISION` | Do not remove or retain blindly; test a reversible change |
| Telemetry ports 4317/8125/19999 are publicly exposed | Prior listener observation vs live bind ownership | OTEL and Netdata listeners are loopback-only | `CONFIRMED LOOPBACK-ONLY` | Do not expose them |
| OmniRoute has public host exposure | Dashboard concern vs live Docker port inspection | OmniRoute has internal 20128/tcp and no host mapping | `CONFIRMED PRIVATE HOST BINDING` | Preserve private routing |
| OmniRoute is application-operational | Docker health and n8n model test vs dashboard reconnecting issue | Internal health/API/WebSocket acceptance not fully supplied | `PENDING APP ACCEPTANCE` | Do not equate container health with acceptance |
| Historical `ai_clients` network is absent | SSOT marks network historical vs live inventory | Live Docker network list shows `ai_clients` exists | `CONFIRMED EXISTS; MEMBERSHIP PENDING` | Verify memberships before deletion/detach |
| AI privacy boundary is enforced | Ollama removal and intended architecture vs missing auth/data tests | Network membership, auth, defaults, provider policy, classification evidence incomplete | `PENDING` | Never send secrets; require approval for private data |
| WireGuard migration complete | Replacement profiles staged vs live handshake output | Old `.2` and `.6` have handshakes; replacements `.7`–`.11` have zero | `PENDING — NOT COMPLETE` | Do not remove old peers |
| Fresh R2 backup exists | Post-rotation backup evidence | Snapshot `fdbdc472` at 2026-09-19 08:47:28 including `/srv/stack` | `CONFIRMED — snapshot` | Do not infer full coverage or restore readiness |
| All persistent services are recoverable | Older baseline restores vs later service additions | Current coverage and application restore drills incomplete | `PENDING` | Do not claim disaster recovery readiness |
| Kasm backup and restore complete | Healthy runtime vs missing restore drill | No non-production Kasm restore evidence | `PENDING` | Do not claim Kasm recoverability |
| n8n owner and backup complete | 2026-09-09 progress handoff vs pending register | Current account check, dump, key recovery, snapshot, and restore not all evidenced | `CONFLICT/PENDING` | Do not claim operational acceptance |
| Kasm token material remains uncompromised | Secret boundary vs uploaded token-bearing logs | `kasem-update-terminal.txt` contains token-bearing Kasm log lines | `FAILED — ROTATION REQUIRED` | Rotate affected material; never reproduce values |
| Container images are immutably pinned | Local digests observed vs running floating tags | n8n, VS Code, Open WebUI, and rolling Kasm tags remain mutable in Compose/inventory | `PENDING` | Pin one stack at a time with rollback |
| Vaultwarden recovery-tested | Healthy deployment and R2 inclusion vs owner-deferred restore | No Vaultwarden restore test | `DEFERRED` | Do not claim recovery-tested status |
```

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
- [ ] Decide and safely remediate direct public TCP 3389 exposure.
- [ ] Verify n8n encryption-key copy out-of-band.
- [ ] Create and validate n8n PostgreSQL custom-format dump.
- [ ] Verify current local/R2 backup coverage.
- [ ] Run Restic integrity checks.
- [ ] Restore representative files from local and R2 repositories.
- [ ] Complete n8n isolated restore drill.
- [ ] Complete Kasm isolated restore drill.
- [ ] Verify `/etc/wireguard` backup coverage.
- [ ] Verify current Kasm, AI, Open WebUI, VS Code, and workspace coverage.

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
- [ ] Test Kasm authenticated browser sessions and WebSocket behavior after any 3389 decision.
- [ ] Complete Vaultwarden onboarding, client tests, synchronization, 2FA, and registration lock-down.

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
- [ ] Hermes deployment.
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

As of the 2026-09-19 reconciliation:

```text
Nextcloud application and repair state: RESOLVED
Nextcloud quota and recent background jobs: RESOLVED/CONFIRMED
Nextcloud unauthenticated Cloudflare Access protection: CONFIRMED
Kasm route and runtime health: CONFIRMED
Kasm browser endpoint: desktop.trisektor.org
Kasm Cloudflare Zero Trust protection: OWNER-CONFIRMED
Kasm TCP 8443 ownership: CONFIRMED
Kasm TCP 3389 ownership: CONFIRMED
Kasm TCP 3389 security acceptance: PENDING
Kasm token-bearing log exposure: FAILED — ROTATION REQUIRED
Telemetry listener ownership/bindings: CONFIRMED LOOPBACK-ONLY
OmniRoute private host binding: CONFIRMED
OmniRoute application/dashboard acceptance: PENDING
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

The VPS is operational, but it is not yet accepted as ready for unattended production change or enterprise-grade disaster recovery. The fastest safe path is to remediate the Kasm token exposure, make a deliberate decision on direct TCP 3389, verify current backup coverage and restores, complete WireGuard migration, and close application-level acceptance gaps one stack at a time.

**End of updated SSOT.**
