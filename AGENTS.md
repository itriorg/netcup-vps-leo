# Repository Agent Instructions

This repository is operational context for the Leo One VPS, not a channel for changing the live server.

## Required context

- Treat [`VPS_STATE.md`](VPS_STATE.md) as the canonical state and follow its evidence labels, authority order, safety rules, navigation map, conflict register, task register, and recovery constraints.
- Before answering or acting on an infrastructure task, read the relevant dashboard rows and service section, then check related conflicts and open tasks. Use the dated evidence as recorded state, not as a live observation.
- Use [`_inbox/leo-one-tunnels-recreation.md`](_inbox/leo-one-tunnels-recreation.md) for the Mac tunnel recreation procedure. Other `_inbox` source notes are ignored by Git and may not exist in another checkout; their reconciled facts belong in `VPS_STATE.md`.

## Operational workflow

1. Establish the target service, evidence date, relevant unknowns, and whether the request is documentation-only or changes live infrastructure.
2. Prefer narrowly scoped, read-only checks for stale or unknown state. Redact secrets and sensitive output before recording evidence.
3. Before production changes, state impact, risk, exact verification, and rollback. Obtain the approval required by `VPS_STATE.md`; never infer approval from a documentation request.
4. Make only the approved, minimal change. Run the behavior-scoped check, record its result and residual risk, and update the verification tracker, task register, conflict register when applicable, and Change Record.
5. The refresh helper writes an ignored `VPS_STATE.snapshot.md`; compare it with the canonical file and reconcile verified facts manually. Never replace `VPS_STATE.md` with generated snapshot output.

## Secret and safety boundaries

- Never request, print, store, or commit credentials, tokens, private keys, secret-bearing environment files, access cookies, or sensitive logs.
- Do not run blind pulls, destructive Compose commands, volume deletion, database operations, restores, key rotation, firewall/DNS/access-control changes, or public exposure changes.
- Keep private dashboards loopback-only as recorded; do not assume a healthy container, backup listing, or network membership proves application acceptance, privacy isolation, or recoverability.
- Do not commit or push changes unless explicitly requested. Keep edits limited to the requested documentation or code.
