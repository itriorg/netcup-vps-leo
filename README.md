# netcup-vps-leo

Private, portable operational context for the netcup VPS named `leo`.

The repository's final state document is [`VPS_STATE.md`](VPS_STATE.md), currently consolidated as version 3.13-agent-reference on 2026-09-27. It includes the documented Vaultwarden, OpenClaw, and Hermes deployments and remains intended for approved operators and AI clients that need the documented VPS context.

## Canonical state

[`VPS_STATE.md`](VPS_STATE.md) is the single source of truth. It is intentionally one Markdown file so it can be supplied to ChatGPT, Claude, Gemini, GitHub Copilot, or another AI client without copying a VPS status conversation each time.

Repository coding agents should also follow [`AGENTS.md`](AGENTS.md), which routes them to the canonical evidence and defines the approval, verification, and snapshot-reconciliation workflow.

The file contains operational facts and decision rules, but must never contain secrets. Unknown facts remain explicitly marked `UNKNOWN`.

Review the document's classification and remove any infrastructure details that should not be shared before changing the repository's visibility or distributing its contents.

OpenClaw deployment details are consolidated in Section 9.6 of `VPS_STATE.md`; Hermes is in Section 9.7 and Mac tunnel recreation in Section 9.8. OpenClaw is recorded healthy with a loopback-only `127.0.0.1:18789` host mapping and environment-backed OmniRoute configuration. Hermes is recorded running with a loopback-only `127.0.0.1:9119` dashboard mapping. Backup/restore, isolation, and full inference acceptance remain explicitly pending; neither loopback mapping is public by Docker binding.

## Repository boundary

`netcup-vps-leo/` is a standalone Git repository nested inside the larger workspace. Its GitHub remote, branch, history, and working tree are managed from this directory, not from the workspace root.

Use these commands from the workspace root:

```bash
git -C netcup-vps-leo status
git -C netcup-vps-leo pull --ff-only origin main
git -C netcup-vps-leo push origin main
```

Do not use root-level `git add`, `git commit`, `git pull`, or `git push` for this repository. The parent workspace intentionally ignores this directory to keep the two repositories separate.

## Refresh

From a trusted machine with an existing, reachable SSH configuration:

```bash
VPS_SSH_TARGET=leo ./scripts/update-vps-state.sh
```

The script collects a bounded, redacted inventory over SSH and writes `VPS_STATE.snapshot.md` beside the script by default. It uses only the local `VPS_SSH_TARGET` and optional `VPS_STATE_FILE` settings; it does not collect VPS environment variables, shell history, credentials, private keys, or application files. It refuses to overwrite the curated `VPS_STATE.md`, including when `VPS_STATE_FILE` targets that file. Review the snapshot against the canonical document and reconcile verified changes manually; the snapshot is not a replacement for the service runbooks, conflict register, or task register.

The refresh is read-only on the VPS and writes only a local snapshot. It requires a working SSH alias; this workspace cannot refresh it while the configured target is unresolved.

## AI workflow

1. Open `VPS_STATE.md` and follow its navigation map, evidence labels, and safety contract.
2. For an operational task, read the relevant service section, conflict register, and task register; treat recorded facts as dated evidence, not a live check.
3. Use read-only checks to resolve material unknowns. Before a production change, present impact, verification, and rollback and obtain required approval.
4. After an approved change, generate a separate snapshot, compare it with the canonical state, and manually reconcile verified facts and the Change Record.
5. Review the final diff. Commit only when the repository remote and branch policy are configured.

## Safety boundary

This repository is documentation and state context, not an automation channel. The snapshot script is read-only on the VPS. Destructive, production, authentication, firewall, DNS, backup, and secret-related changes require explicit review and execution outside this repository. Do not treat a local documentation update as proof that the VPS or a hosted Git copy has been updated.
