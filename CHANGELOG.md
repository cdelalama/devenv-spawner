# Changelog

All notable changes to this project will be documented in this file.

## [0.1.3] - 2026-09-12

### Added
- Added the centrally managed Fable-preferred, exact-Opus fallback review
  policy.

### Changed
- Preserved the repository's prior full-template identity and provisioning
  behavior.

### Fixed
- None.

## [0.1.2] - 2026-06-22

### Added
- Added LLM-DocKit sync opt-in and current template governance assets:
  `.dockit-enabled`, version sync tooling, validator smoke tests, SessionStart
  bootstrap, Trace helper, Codex hook installer, GitHub templates, and Codex
  integration notes.
- Added `docs/VERSIONING_RULES.md` so the version sync manifest no longer
  points at a missing policy file.

### Changed
- Aligned Claude Code hooks with the LLM-DocKit v4.12.3 template-managed model.
- Updated repository structure, handoff, and project context docs for v0.1.2.

### Fixed
- Reconciled the stale D-008 Stop-hook contract by recording D-010 and removing
  the now-unwired `scripts/dockit-stop-hook.sh` helper.
- Fixed DocKit validation failures for missing HISTORY date, stale HANDOFF date,
  missing Open work orientation, and missing versioning rules.

## [0.1.1] - 2026-05-13

### Changed
- Recorded the repository rename from `dev-spawner` to `devenv-spawner` and its role as the user-provisioning layer of the `devenv-stack`.
- Updated active documentation and user-visible script/template labels to use the new `devenv-spawner` name.

### Fixed
- Added the missing `scripts/dockit-validate-session.sh` that the Stop hook expects.
- Added `scripts/dockit-stop-hook.sh` and scoped it so read-only sessions do not force spurious HANDOFF/HISTORY updates.

## [0.1.0] - 2026-03-01

### Added
- Project bootstrap from LLM-DocKit template
- `scripts/spawn-user.sh` — idempotent user provisioning with optional modules
  - Base: Linux user, docker group, dotfiles, NVM+Node, pnpm, Claude Code, SSH key
  - Optional: `--with-ollama`, `--with-sounds`, `--copy-admin-credentials`
  - Update mode: `--update-templates` with automatic `.bak` backups
  - Automatic post-provisioning verify (12 bash checks: node, npm, pnpm, claude, git, tmux, docker, dirs, ssh, permissions)
  - Automatic diagnose on failure via Claude Code CLI (read-only, uses admin's subscription)
- `scripts/despawn-user.sh` — safe user removal with confirmation and `--yes` flag
- Templates: bashrc, profile, tmux.conf, gitconfig, Claude Code config (base + sounds)
- 7 design decisions documented in DECISIONS.md (D-001 through D-007)
- Initial documentation (README, PROJECT_CONTEXT, ARCHITECTURE, STRUCTURE)

### Fixed
- `((COUNT++))` arithmetic with `set -e` causing premature exit (bash returns exit 1 when post-increment evaluates to 0)
