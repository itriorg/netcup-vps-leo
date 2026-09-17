# netcup-vps-leo

Private, portable operational context for the netcup VPS named `leo`.

## Canonical state

[`VPS_STATE.md`](VPS_STATE.md) is the single source of truth. It is intentionally one Markdown file so it can be supplied to ChatGPT, Claude, Gemini, GitHub Copilot, or another AI client without copying a VPS status conversation each time.

The file contains operational facts and decision rules, but must never contain secrets. Unknown facts remain explicitly marked `UNKNOWN`.

## Refresh

From a trusted machine with an existing SSH configuration:

```bash
VPS_SSH_TARGET=leo ./scripts/update-vps-state.sh
```

The script collects a bounded, redacted inventory over SSH. It does not read environment variables, shell history, credentials, private keys, or application files. Review the diff before committing or sharing the refreshed Markdown file.

## AI workflow

1. Open `VPS_STATE.md` in the AI client.
2. Ask the client to treat it as authoritative context.
3. Ask for a plan and verification steps before any change.
4. Refresh the file after approved infrastructure changes.
5. Commit the Markdown update with a short change description.

## Safety boundary

This repository is documentation and state context, not an automation channel. The snapshot script is read-only on the VPS. Destructive, production, authentication, firewall, DNS, backup, and secret-related changes require explicit review and execution outside this repository.
