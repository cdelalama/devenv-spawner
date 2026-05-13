# Changelog

All notable changes to this project will be documented in this file.

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
