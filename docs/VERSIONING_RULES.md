<!-- doc-version: 0.1.3 -->
# Versioning Rules

`devenv-spawner` uses SemVer for the user-provisioning tooling and its
DocKit-governed operator workflow.

## Version Source
- `VERSION` is the source of truth.
- `docs/version-sync-manifest.yml` lists files whose visible markers must match
  `VERSION`.

## What Requires a Version Bump

- Patch: non-breaking fixes, documentation governance updates, validator or
  hook maintenance, and provisioning refactors that preserve behavior.
- Minor: backward-compatible provisioning capabilities, new optional modules,
  or new operator workflows.
- Major: breaking CLI changes, destructive default behavior changes, or
  migration requirements for existing provisioned users.

Documentation-only updates under `docs/llm/` do not require a version bump
unless they change tooling, hooks, or operator-facing workflow semantics.

## Commands

Run:

```sh
scripts/bump-version.sh <new_version>
scripts/check-version-sync.sh
```

Install the local pre-commit hook:

```sh
cp scripts/pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Update Process
1. Decide the SemVer impact.
2. Run `scripts/bump-version.sh <new_version>`.
3. Fill in the generated `CHANGELOG.md` section.
4. Update `docs/llm/HANDOFF.md` and `docs/llm/HISTORY.md`.
5. Run `scripts/dockit-validate-session.sh --human`.
6. Run `scripts/check-version-sync.sh`.

## Notes
- Do not edit version markers manually when a bump is required.
- If a new marker type is needed, add support in both
  `scripts/bump-version.sh` and `scripts/check-version-sync.sh` first.
