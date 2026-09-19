# netcup-vps-leo

Private, portable operational context for the netcup VPS named `leo`.

The repository's final state document is [`VPS_STATE.md`](VPS_STATE.md), currently consolidated as version 3.3 on 2026-09-19. It includes the latest documented Vaultwarden deployment and remains intended for approved operators and AI clients that need the documented VPS context.

## Canonical state

[`VPS_STATE.md`](VPS_STATE.md) is the single source of truth. It is intentionally one Markdown file so it can be supplied to ChatGPT, Claude, Gemini, GitHub Copilot, or another AI client without copying a VPS status conversation each time.

The file contains operational facts and decision rules, but must never contain secrets. Unknown facts remain explicitly marked `UNKNOWN`.

Review the document's classification and remove any infrastructure details that should not be shared before changing the repository's visibility or distributing its contents.

## Refresh

From a trusted machine with an existing, reachable SSH configuration:

```bash
VPS_SSH_TARGET=leo ./scripts/update-vps-state.sh
```

The script collects a bounded, redacted inventory over SSH. It does not read environment variables, shell history, credentials, private keys, or application files. Review the diff before committing or sharing the refreshed Markdown file.

The refresh is read-only on the VPS and updates only the local `VPS_STATE.md`. It requires a working SSH alias; this workspace cannot refresh the file while the configured target is unresolved.

## AI workflow

1. Open `VPS_STATE.md` in the AI client.
2. Ask the client to treat it as authoritative context.
3. Ask for a plan and verification steps before any change.
4. Refresh the file after approved infrastructure changes.
5. Review the diff and commit the Markdown update with a short change description when the repository remote and branch policy are configured.

## Safety boundary

This repository is documentation and state context, not an automation channel. The snapshot script is read-only on the VPS. Destructive, production, authentication, firewall, DNS, backup, and secret-related changes require explicit review and execution outside this repository. Do not treat a local documentation update as proof that the VPS or a hosted Git copy has been updated.
