#!/usr/bin/env bash
set -euo pipefail

TARGET="${VPS_SSH_TARGET:-}"
OUTPUT="${VPS_STATE_FILE:-VPS_STATE.md}"

if [[ -z "$TARGET" ]]; then
  printf 'Usage: VPS_SSH_TARGET=<ssh-host-alias> %s\n' "$0" >&2
  exit 2
fi

remote_script=''
read -r -d '' remote_script <<'REMOTE' || true
set -u

section() {
  printf '\n## %s\n\n' "$1"
}

value_or_unknown() {
  if [[ -n "${1:-}" ]]; then printf '%s' "$1"; else printf 'UNKNOWN'; fi
}

printf '# netcup VPS Leo: Single Source of Truth\n'
printf '\n> Read-only snapshot generated from the configured SSH target. Secrets and public addresses are intentionally omitted.\n'
printf '\n## Document Metadata\n\n'
printf -- '- **State file:** VPS_STATE.md\n'
printf -- '- **Last refreshed:** %s UTC\n' "$(date -u '+%Y-%m-%d %H:%M:%S')"
printf -- '- **Refresh source:** SSH target alias (not recorded)\n'
printf -- '- **State confidence:** Snapshot of commands listed below\n'

section 'Identity and Access'
printf -- '- **Provider:** netcup\n'
printf -- '- **Server name:** leo\n'
printf -- '- **Hostname:** %s\n' "$(hostname 2>/dev/null || printf UNKNOWN)"
printf -- '- **Public addresses:** OMITTED_BY_DESIGN\n'
printf -- '- **SSH credentials:** NOT COLLECTED\n'
printf -- '- **Privilege model:** %s\n' "$(id 2>/dev/null || printf UNKNOWN)"

section 'Host'
printf -- '- **Operating system:** %s\n' "$(. /etc/os-release 2>/dev/null && printf '%s' "${PRETTY_NAME:-UNKNOWN}" || printf UNKNOWN)"
printf -- '- **Kernel:** %s\n' "$(uname -srmo 2>/dev/null || printf UNKNOWN)"
printf -- '- **Architecture:** %s\n' "$(uname -m 2>/dev/null || printf UNKNOWN)"
printf -- '- **Timezone:** %s\n' "$(timedatectl show --property=Timezone --value 2>/dev/null || date +%Z 2>/dev/null || printf UNKNOWN)"
printf -- '- **Uptime:** %s\n' "$(uptime -p 2>/dev/null || printf UNKNOWN)"
printf -- '- **Last reboot:** %s\n' "$(who -b 2>/dev/null || printf UNKNOWN)"

section 'Capacity and Health'
printf -- '```text\n'
printf 'Load: '; uptime 2>/dev/null || true
printf '\nMemory:\n'; free -h 2>/dev/null || true
printf '\nDisk:\n'; df -hT 2>/dev/null || true
printf '```\n'

section 'Network and Exposure'
printf -- '- **Listening sockets:** See bounded command output below; addresses omitted where possible\n'
printf -- '- **Firewall:** %s\n' "$(if command -v ufw >/dev/null 2>&1; then ufw status 2>/dev/null | head -n 1; elif command -v firewall-cmd >/dev/null 2>&1; then firewall-cmd --state 2>/dev/null; else printf UNKNOWN; fi)"
printf -- '\n```text\n'
if command -v ss >/dev/null 2>&1; then ss -lntup 2>/dev/null | sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/ADDRESS/g' | head -n 80; else printf 'ss unavailable\n'; fi
printf '```\n'

section 'Runtime Inventory'
printf -- '- **Docker:** %s\n' "$(docker --version 2>/dev/null || printf UNKNOWN)"
printf -- '- **Docker Compose:** %s\n' "$(docker compose version 2>/dev/null || printf UNKNOWN)"
printf -- '- **Node.js:** %s\n' "$(node --version 2>/dev/null || printf UNKNOWN)"
printf -- '- **Python:** %s\n' "$(python3 --version 2>/dev/null || printf UNKNOWN)"
printf -- '- **Go:** %s\n' "$(go version 2>/dev/null || printf UNKNOWN)"
printf -- '- **Rust:** %s\n' "$(rustc --version 2>/dev/null || printf UNKNOWN)"
printf -- '- **Package updates:** Check not performed by this read-only snapshot\n'

section 'Services'
printf -- '```text\n'
if command -v systemctl >/dev/null 2>&1; then systemctl --type=service --state=running --no-pager --no-legend 2>/dev/null | head -n 100; else printf 'systemd unavailable\n'; fi
printf '```\n'

section 'Containers'
printf -- '```text\n'
if command -v docker >/dev/null 2>&1; then docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>/dev/null | sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/ADDRESS/g' | head -n 100; else printf 'Docker unavailable\n'; fi
printf '```\n'

section 'Backups and Security'
printf -- '- **Backup provider or method:** UNKNOWN\n'
printf -- '- **Last successful backup:** UNKNOWN\n'
printf -- '- **OS security updates:** Not checked by this read-only snapshot\n'
printf -- '- **SSH hardening:** Not checked by this read-only snapshot\n'
printf -- '- **Secrets:** NOT COLLECTED\n'
printf -- '- **Recent security events:** Not collected\n'

section 'AI Handoff Notes'
printf '%s\n' 'Treat this snapshot as authoritative only until a newer verified snapshot exists. Do not infer omitted values. Ask for explicit approval before any change.'
REMOTE

mkdir -p "$(dirname "$OUTPUT")"
tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT
ssh -o BatchMode=yes -o ConnectTimeout=10 "$TARGET" "bash -s" <<<"$remote_script" >"$tmp_file"
# Preserve the canonical header and replace the prior snapshot atomically.
install -m 0644 "$tmp_file" "$OUTPUT"
printf 'Updated %s from %s\n' "$OUTPUT" "$TARGET"
