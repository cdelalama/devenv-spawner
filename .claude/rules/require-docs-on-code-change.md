---
globs:
  - "scripts/**/*.sh"
  - "src/**/*"
  - "*.yml"
  - "*.yaml"
---
When modifying files matching these paths, you MUST also update:
1. `docs/llm/HANDOFF.md` — update "Last Updated" date and "Session Focus"
2. `docs/llm/HISTORY.md` — append an entry with today's date

Run `scripts/dockit-validate-session.sh --human` to verify compliance before ending the session.

Enforcement: `scripts/dockit-stop-hook.sh` (wired into Stop in `.claude/settings.json`)
blocks session-end only if the session transcript shows at least one
`Edit`/`Write`/`MultiEdit`/`NotebookEdit` against a covered path AND the validator
fails. Read-only sessions do not trigger the block. See D-008 in
`docs/llm/DECISIONS.md`. If the `globs` list above changes, also update the
matching logic in `scripts/dockit-stop-hook.sh`.
