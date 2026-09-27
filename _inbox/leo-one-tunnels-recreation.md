# Leo One SSH Tunnel Runbook

- **Document status:** Operator runbook
- **Runbook revision:** 2.0
- **Last reconciled:** 2026-09-27
- **VPS evidence reference:** [VPS_STATE.md](../VPS_STATE.md) 3.10; inventory cutoff 2026-09-27 04:22 UTC
- **Target host alias:** `leo-one`
- **Mac script path:** `~/bin/leo-one-tunnels.sh`
- **Scope:** Six local SSH forwards from one Mac to the Leo One VPS
- **Live Mac script status:** `UNKNOWN`; this runbook is the reviewed recreation source, not proof of the installed copy.
- **Validation status:** Embedded script and install procedure passed Bash syntax checks in a Linux environment; no live Mac or VPS tunnel execution was performed.

## Purpose and Safety

This runbook recreates and operates the Mac-side tunnel script. It does not change the VPS, Docker Compose projects, firewall, DNS, Caddy, or Cloudflare. All local listeners bind to `127.0.0.1` and are intended for use from the Mac only.

The script terminates an existing SSH process on a managed port only when its command line matches the expected `leo-one` forward for that exact local port. If the port is held by another SSH command or a non-SSH process, the script aborts without killing it. If tunnel creation fails partway through, it stops the tunnels started during that run.

Do not expose these local listeners on `0.0.0.0` or `[::]`. Do not treat a successful SSH forward as proof that the application is healthy, authenticated, or authorized. Model/API traffic through OmniRoute is provider-bound and remains subject to the VPS privacy rules.

The script creates six SSH local-forwarding tunnels through the SSH alias `leo-one`:

| Mac listener | VPS destination | Service |
|---:|---|---|
| `127.0.0.1:3000` | Open WebUI container IP on `172.22.0.0/16`, TCP `8080` | Open WebUI, `http://127.0.0.1:3000` |
| `127.0.0.1:8080` | VS Code Server container IP on `172.23.0.0/16`, TCP `8443` | VS Code Server, `https://127.0.0.1:8080` |
| `127.0.0.1:20128` | OmniRoute container IP on `172.22.0.0/16`, TCP `20128` | OmniRoute, `http://127.0.0.1:20128` |
| `127.0.0.1:19999` | VPS `127.0.0.1:19999` | Netdata, `http://127.0.0.1:19999` |
| `127.0.0.1:18789` | VPS `127.0.0.1:18789` | OpenClaw Gateway, `http://127.0.0.1:18789` |
| `127.0.0.1:19119` | VPS `127.0.0.1:9119` | Hermes dashboard, `http://127.0.0.1:19119` |

The container IPs are discovered at each run and are not persistent configuration. The recorded subnet assignments are operational evidence, not a guarantee they will never change; if a service moves networks, update and review the script before use.

Use the complete reviewed script below as the source of truth. Do not regenerate an alternative with an AI tool unless the requirements change and the result is reviewed and validated.

## Required prerequisites

Before execution, confirm the Mac has:

- SSH access to the VPS through the alias `leo-one`.
- A `Host leo-one` entry in `~/.ssh/config`, or equivalent SSH configuration.
- A previously verified VPS host key in `known_hosts`.
- Working non-interactive SSH authentication and Docker inspection permissions for VPS user `leo`.
- `lsof`, `ps`, and standard macOS command-line utilities available.

The VPS prerequisites are the recorded running services and expected network memberships below. These values are dated evidence; verify changed or stale state with read-only checks before changing the script.

| Service | VPS project/container | Required network or bind |
|---|---|---|
| Open WebUI | `open-webui` | `ai_egress`, recorded as `172.22.0.0/16`; TCP `8080` |
| VS Code Server | `vscode-server` | `dev_internal`, recorded as `172.23.0.0/16`; TCP `8443` |
| OmniRoute | Compose project `/srv/stack/omniroute`, service `omniroute` | `ai_egress`, recorded as `172.22.0.0/16`; TCP `20128` |
| Netdata | VPS loopback | `127.0.0.1:19999` |
| OpenClaw | Compose project `/srv/openclaw`, service `openclaw-gateway` | VPS loopback publication `127.0.0.1:18789` |
| Hermes | Compose project `/srv/stack/hermes`, service `hermes` | VPS loopback publication `127.0.0.1:9119` |

The recorded OpenClaw publication is loopback-only:

```yaml
ports:
  - "127.0.0.1:18789:18789"
```

Do not broaden either AI service to a wildcard host bind. The recorded mapping does not prove current reachability or application acceptance.

## Install or Replace the Script

Run this procedure in a Bash terminal on the Mac. It creates a timestamped copy if replacing an existing script, validates the temporary script before installation, and renames the validated script into place on the same filesystem. A failed backup or syntax check stops the operation.

```bash
set -euo pipefail
mkdir -p "$HOME/bin"
target="$HOME/bin/leo-one-tunnels.sh"

if [[ -e "$target" ]]; then
  backup="$target.bak.$(date '+%Y%m%dT%H%M%S')"
  if [[ -e "$backup" ]]; then
    printf 'Backup already exists; refusing to overwrite: %s\n' "$backup" >&2
    exit 1
  fi
  cp -p "$target" "$backup"
  printf 'Previous script backed up to %s\n' "$backup"
fi

temporary_script=$(mktemp "$HOME/bin/.leo-one-tunnels.sh.XXXXXX")
trap 'rm -f "$temporary_script"' EXIT
cat > "$temporary_script" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SSH_TARGET="leo-one"
SSH_OPTIONS=(
  -o BatchMode=yes
  -o ConnectTimeout=10
  -o StrictHostKeyChecking=yes
  -o ClearAllForwardings=yes
)
MANAGED_PORTS=(3000 8080 20128 19999 18789 19119)
old_pids=()
started_pids=()

cleanup_started_tunnels() {
  local pid
  for pid in "${started_pids[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
}

on_exit() {
  local status=$?
  trap - EXIT
  if (( status != 0 )); then
    printf 'Tunnel setup failed; stopping tunnels started by this run.\n' >&2
    cleanup_started_tunnels
  fi
  exit "$status"
}
trap on_exit EXIT

ip_in_subnet() {
  local address="$1"
  local expected_second_octet="$2"
  local first_octet
  local second_octet
  local third_octet
  local fourth_octet

  [[ "$address" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || return 1
  IFS=. read -r first_octet second_octet third_octet fourth_octet <<< "$address"
  (( 10#$first_octet == 172 && 10#$second_octet == 10#$expected_second_octet && 10#$third_octet <= 255 && 10#$fourth_octet <= 255 ))
}

WEBUI_IP=$(ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" 'docker inspect --format "{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}" open-webui' | awk '/^172[.]22[.]/ { print; exit }')
CODE_IP=$(ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" 'docker inspect --format "{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}" vscode-server' | awk '/^172[.]23[.]/ { print; exit }')
OMNI_IP=$(ssh "${SSH_OPTIONS[@]}" "$SSH_TARGET" 'container_id=$(docker compose --project-directory /srv/stack/omniroute ps -q omniroute) && [ -n "$container_id" ] && docker inspect --format "{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}" "$container_id"' | awk '/^172[.]22[.]/ { print; exit }')

if ! ip_in_subnet "$WEBUI_IP" 22; then
  printf 'Open WebUI IP missing or outside expected 172.22.0.0/16 network: %s\n' "${WEBUI_IP:-EMPTY}" >&2
  exit 1
fi
if ! ip_in_subnet "$CODE_IP" 23; then
  printf 'VS Code Server IP missing or outside expected 172.23.0.0/16 network: %s\n' "${CODE_IP:-EMPTY}" >&2
  exit 1
fi
if ! ip_in_subnet "$OMNI_IP" 22; then
  printf 'OmniRoute IP missing or outside expected 172.22.0.0/16 network: %s\n' "${OMNI_IP:-EMPTY}" >&2
  exit 1
fi

echo "WEBUI_IP=$WEBUI_IP"
echo "CODE_IP=$CODE_IP"
echo "OMNI_IP=$OMNI_IP"

printf 'Checking existing listeners on managed local ports...\n'
for port in "${MANAGED_PORTS[@]}"; do
  pids=$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)
  if [[ -n "$pids" ]]; then
    while IFS= read -r pid; do
      [[ "$pid" =~ ^[0-9]+$ ]] || continue
      command_line=$(ps -p "$pid" -o command=)
      case "$port" in
        3000) expected_destination='127.0.0.1:3000:172.22.'; expected_remote_port=8080 ;;
        8080) expected_destination='127.0.0.1:8080:172.23.'; expected_remote_port=8443 ;;
        20128) expected_destination='127.0.0.1:20128:172.22.'; expected_remote_port=20128 ;;
        19999) expected_destination='127.0.0.1:19999:127.0.0.1'; expected_remote_port=19999 ;;
        18789) expected_destination='127.0.0.1:18789:127.0.0.1'; expected_remote_port=18789 ;;
        19119) expected_destination='127.0.0.1:19119:127.0.0.1'; expected_remote_port=9119 ;;
      esac
      case "$command_line" in
        *"-L ${expected_destination}"*":${expected_remote_port}"*"${SSH_TARGET}"*)
          old_pids+=("$pid")
          ;;
        *)
          printf 'Refusing to stop PID %s on port %s: listener is not the expected managed %s SSH forward.\n' "$pid" "$port" "$SSH_TARGET" >&2
          exit 1
          ;;
      esac
    done <<< "$pids"
  fi
done

printf 'Stopping verified existing Leo One tunnel process(es)...\n'
for pid in "${old_pids[@]}"; do
  kill "$pid"
done

start_tunnel() {
  local label="$1"
  local local_port="$2"
  local remote_host="$3"
  local remote_port="$4"

  printf 'Creating %s: 127.0.0.1:%s -> %s:%s (via %s)\n' "$label" "$local_port" "$remote_host" "$remote_port" "$SSH_TARGET"
  ssh -fN "${SSH_OPTIONS[@]}" \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -L "127.0.0.1:${local_port}:${remote_host}:${remote_port}" \
    "$SSH_TARGET"

  local listener_pids
  listener_pids=$(lsof -tiTCP:"$local_port" -sTCP:LISTEN 2>/dev/null || true)
  if [[ -z "$listener_pids" ]]; then
    printf 'No SSH listener found after starting %s on local port %s.\n' "$label" "$local_port" >&2
    return 1
  fi

  local pid
  while IFS= read -r pid; do
    [[ "$pid" =~ ^[0-9]+$ ]] || continue
    local command_line
    command_line=$(ps -p "$pid" -o command=)
    case "$command_line" in
      *"-L 127.0.0.1:${local_port}:${remote_host}:${remote_port}"*"${SSH_TARGET}"*) ;;
      *)
        printf 'Listener PID %s on port %s does not match the new %s forward.\n' "$pid" "$local_port" "$label" >&2
        return 1
        ;;
    esac
    started_pids+=("$pid")
  done <<< "$listener_pids"
}

start_tunnel "open-webui" 3000 "$WEBUI_IP" 8080
start_tunnel "vscode-server" 8080 "$CODE_IP" 8443
start_tunnel "omniroute" 20128 "$OMNI_IP" 20128
start_tunnel "netdata" 19999 127.0.0.1 19999
start_tunnel "openclaw" 18789 127.0.0.1 18789
start_tunnel "hermes" 19119 127.0.0.1 9119

printf 'All six SSH listeners are established.\n'
printf 'Open WebUI: http://127.0.0.1:3000\n'
printf 'VS Code Server: https://127.0.0.1:8080\n'
printf 'OmniRoute: http://127.0.0.1:20128\n'
printf 'Netdata: http://127.0.0.1:19999\n'
printf 'OpenClaw: http://127.0.0.1:18789\n'
printf 'Hermes: http://127.0.0.1:19119\n'
EOF
if ! bash -n "$temporary_script"; then
  printf 'Syntax validation failed; existing script was not replaced.\n' >&2
  exit 1
fi
chmod 700 "$temporary_script"
mv -f "$temporary_script" "$target"
trap - EXIT
printf 'Installed validated script at %s\n' "$target"
```

The script uses `BatchMode=yes`; the SSH key must be available to the Mac's SSH agent, and remote Docker commands must not require an interactive password or `sudo` prompt. Verify the SSH alias and Docker access before installing or running the tunnel script:

```bash
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=yes -o ClearAllForwardings=yes leo-one 'docker ps --format "{{.Names}}" >/dev/null'
```

## Start the tunnels

```bash
"$HOME/bin/leo-one-tunnels.sh"
```

Expected output includes all six service names and URLs. A successful local bind confirms SSH setup, not successful application authentication or health.

```text
Creating open-webui: 127.0.0.1:3000 -> ...
Creating vscode-server: 127.0.0.1:8080 -> ...
Creating omniroute: 127.0.0.1:20128 -> ...
Creating netdata: 127.0.0.1:19999 -> 127.0.0.1:19999
Creating openclaw: 127.0.0.1:18789 -> 127.0.0.1:18789
Creating hermes: 127.0.0.1:19119 -> 127.0.0.1:9119
All six SSH listeners are established.
```

## Script behavior and design notes

- The SSH alias is `leo-one` everywhere.
- Container IPs are resolved at each run because Docker IP addresses can change.
- Existing listeners are inspected before any cleanup. Only a process whose command line matches the expected local port, service destination/port, and `leo-one` target is terminated; unrelated SSH and non-SSH listeners cause a fail-closed abort.
- `ssh -fN` backgrounds each forwarding session.
- The three container IPs are checked against their expected subnets before any existing tunnel is stopped.
- `ExitOnForwardFailure=yes` makes a failed local bind or forwarding setup fail instead of appearing successful.
- Keepalive options help detect broken idle sessions.
- Local listeners bind to loopback and are not reachable from other devices.
- If any new tunnel fails to start, the script terminates tunnels started in that invocation. It cannot restore the prior tunnels it stopped; fix the reported cause and rerun the script.
- The Hermes dashboard uses the separate local port `19119` to avoid colliding with its VPS listener `9119`.
- The script does not modify the VPS, Docker Compose files, firewall, DNS, Caddy, or Cloudflare.
- The script does not print secrets.
- The script is a start/refresh tool; it has no stop or verification flags.

## Verify, Stop, and Troubleshoot

### Verify local listeners

Run on the Mac after startup. Each managed port should show an SSH listener bound only to `127.0.0.1`:

```bash
for port in 3000 8080 20128 19999 18789 19119; do
  printf '\n=== 127.0.0.1:%s ===\n' "$port"
  lsof -nP -iTCP:"$port" -sTCP:LISTEN || true
done
```

An SSH listener confirms that the local forward was established. It does not prove remote application health, user authentication, model availability, or authorization. Test the intended app separately without entering secrets into shell history or this document.

### Stop a tunnel

The start script deliberately does not expose a stop mode. To stop a tunnel, use `lsof -nP -iTCP:<port> -sTCP:LISTEN` to identify its PID, then inspect the command with `ps -p <PID> -o pid=,command=`. Send `kill <PID>` only after confirming the command line matches the intended `leo-one` forward and exact service destination. If it does not match, do not kill it; identify the owner first. Repeat for the managed ports that should be stopped.

### Troubleshooting

| Symptom | Likely cause | Safe response |
|---|---|---|
| `Permission denied` or connection timeout | SSH alias, key agent, VPN/network route, or SSH policy | Run the non-interactive SSH prerequisite check; verify the alias and agent without printing keys or configuration secrets. |
| `docker inspect` fails or an IP is missing | Service is stopped, user `leo` lacks Docker access, or network membership changed | Do not proceed with old/stale container IPs. Use read-only service/network inspection and update this runbook only after verification. |
| Refuses to stop a listener | The PID is not an exact managed tunnel or its process arguments are not visible as expected | Leave it running; inspect `lsof` and `ps` output and resolve ownership manually. |
| `Address already in use` | Another process acquired a managed local port after preflight or the old listener has not exited | Inspect the port owner. Do not kill an unidentified process; rerun only after resolving the conflict. |
| One of the SSH forwards fails | Remote route/port unavailable or SSH forward setup rejected | The script removes tunnels started during that invocation. Previously running managed tunnels may already have been stopped; fix the cause and rerun. |
| Local port listens but the app fails | Application/authentication issue or wrong service endpoint | Diagnose the application separately; a tunnel is not an application health check. |

Do not paste full terminal logs, environment dumps, SSH private configuration, API keys, cookies, or provider credentials into incident notes.

## Backup and recovery commands

List candidate backups and inspect the exact file before restore:

```bash
ls -1t "$HOME"/bin/leo-one-tunnels.sh.bak.* 2>/dev/null
```

Set `backup_path` to the exact reviewed file. The following validates it, preserves the current script, installs to a temporary file, and atomically replaces the target:

```bash
set -euo pipefail
target="$HOME/bin/leo-one-tunnels.sh"
backup_path="$HOME/bin/leo-one-tunnels.sh.bak.YYYYMMDDTHHMMSS"
[[ -f "$backup_path" ]]
bash -n "$backup_path"

if [[ -e "$target" ]]; then
  current_backup="$target.before-restore.$(date '+%Y%m%dT%H%M%S')"
  cp -p "$target" "$current_backup"
  printf 'Current script preserved at %s\n' "$current_backup"
fi

temporary_script=$(mktemp "$HOME/bin/.leo-one-tunnels.sh.XXXXXX")
trap 'rm -f "$temporary_script"' EXIT
cp -p "$backup_path" "$temporary_script"
bash -n "$temporary_script"
chmod 700 "$temporary_script"
mv -f "$temporary_script" "$target"
trap - EXIT
printf 'Restored reviewed backup to %s\n' "$target"
```

The script is installed when it exists at:

```text
~/bin/leo-one-tunnels.sh
```

with mode `0700`, passes `bash -n`, and all six expected local listeners are confirmed by the verification command. These checks do not establish application acceptance.
