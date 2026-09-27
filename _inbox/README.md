# Source Document Inbox

Drop new VPS evidence and source documents in this folder for review and consolidation into `../VPS_STATE.md`.

- Keep new, unreviewed source files unsuffixed.
- After their relevant facts have been reconciled into `../VPS_STATE.md`, rename the local source to `<original-name>.merged.md` so it is not mistaken for pending input. Preserve the content for audit history; do not delete it.
- Do not mark an active operator runbook as merged or archive it while the canonical state or agent instructions still link to it as the procedure of record.
- For later updates, add the new source unsuffixed. Reconcile it against the dated canonical state, then mark that specific source `.merged.md` when complete.
- Do not add passwords, private keys, API tokens, or `.env` files.
- Source notes are intentionally ignored by Git and remain local; do not expect their contents or renames to appear in another clone. Keep durable operational facts and evidence lineage in `../VPS_STATE.md`.
- `_inbox/leo-one-tunnels-recreation.md` is an active, versioned runbook, not a consumed source note.
