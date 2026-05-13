# Decision Log (Stable Rationale)

This file captures durable "why" decisions. Keep it stable and link to it from `docs/llm/HANDOFF.md`.

Format:
- Use IDs: `D-001`, `D-002`, ...
- Keep each decision self-contained.
- Prefer facts and tradeoffs over narration.

---

## D-001 - Multi-user on same VM over separate VMs

**Status:** accepted (2026-03-01)

### Decision
Provision multiple development users on a single shared VM rather than creating separate VMs.

### Context
Need to provide development environments for family members (Laura, Oscar). Options: separate VMs vs shared VM with multiple users.

### Rationale
- Shared VM avoids 3x overhead of base OS + services (Docker daemon, Ollama, system packages)
- 16GB RAM / 2 vCPU is enough for non-simultaneous use
- Single point of maintenance (one OS to update)
- Easy to scale up (add RAM/CPU) if needed later
- Home lab context: full isolation not required

### Implications
- Docker daemon is shared (all users see containers, resolved by naming convention)
- Port conflicts possible (resolved ad-hoc)
- Heavy process from one user affects others

---

## D-002 - NVM per-user, not system-wide

**Status:** accepted (2026-03-01)

### Decision
Each user gets their own `~/.nvm/` installation rather than a system-wide Node.js.

### Rationale
- Full isolation: each user can use different Node versions
- Standard approach, well-documented
- ~200MB per user is acceptable
- No coordination needed for version changes

---

## D-003 - Tiered provisioning with optional modules

**Status:** accepted (2026-03-01)

### Decision
Base install (Node, Docker, Claude Code, git, tmux, SSH) plus optional modules via flags (--with-ollama, --with-sounds, --copy-admin-credentials).

### Rationale
- Kids don't need Doppler, Ollama, or sound hooks on day one
- Flags make it explicit what gets installed
- Easy to add more modules later without touching core logic

---

## D-004 - Shared Ollama service

**Status:** accepted (2026-03-01)

### Decision
All users share Carlos's Ollama instance at 127.0.0.1:11434 via OLLAMA_HOST env var.

### Rationale
- Ollama is already running as a systemd service
- Each instance would load models into RAM separately (wasteful)
- Single env var addition per user

---

## D-005 - Claude API key shared by default, opt-in copy

**Status:** accepted (2026-03-01)

### Decision
Admin credentials are only copied with explicit `--copy-admin-credentials` flag. Not copied by default.

### Rationale
- Security: sharing API keys should be a conscious decision
- Each user can set up their own Anthropic account later
- Flag validates $SUDO_USER and source file existence before copying
- Never overwrites existing credentials (user may have set their own)

---

## D-006 - Create-if-missing with --update-templates for updates

**Status:** accepted (2026-03-01)

### Decision
Dotfiles are only created if they don't exist (idempotent). The `--update-templates` flag forces overwrite with automatic `.bak.<timestamp>` backups.

### Rationale
- Protects user customizations by default
- Backup before overwrite enables easy rollback
- Single script handles both create and update flows

---

## D-007 - Automatic verify + diagnose post-provisioning

**Status:** accepted (2026-03-01)

### Decision
After provisioning, spawn-user.sh automatically runs 12 bash verification checks. If any check fails, it launches Claude Code CLI (claude -p) as the admin user to diagnose failures and suggest fixes.

### Context
Need to validate that provisioning actually worked. Options: manual testing, bash checks, or AI-assisted diagnosis.

### Rationale
- Bash verify is fast (~2s) and catches obvious issues (missing tools, wrong permissions)
- Claude Code CLI runs in print mode (-p), uses the admin's existing subscription (no extra cost)
- Diagnosis only triggers on failure (zero overhead on happy path)
- Claude Code runs read-only (allowed tools: Bash, Read, Glob, Grep) - cannot modify anything
- Two-tier approach: fast bash for detection, smart AI for root cause analysis

### Implications
- Requires Claude Code installed and authenticated for the admin user ($SUDO_USER)
- If Claude Code is unavailable, diagnosis is skipped with a warning (non-fatal)
- Diagnosis adds 10-30s when triggered (API round-trip)
- No session persistence (--no-session-persistence flag)

---

## D-008 - Stop hook gates on real code edits, not session occurrence

**Status:** accepted (2026-05-12)

### Decision
The Stop hook (`scripts/dockit-stop-hook.sh`) only blocks session-end when both:
1. The session transcript shows at least one `Edit`/`Write`/`MultiEdit`/`NotebookEdit` tool call against a path covered by `.claude/rules/require-docs-on-code-change.md` (`scripts/**/*.sh`, `src/**`, `*.yml`, `*.yaml`).
2. `scripts/dockit-validate-session.sh --json --quiet` exits non-zero.

If condition 1 is false, the hook exits 0 silently. Read-only research sessions are no longer blocked.

### Context
The previous Stop hook unconditionally invoked the validator on every session-end, regardless of whether the session had modified any code. Research-only sessions (e.g. "compare project A vs project B") got blocked and forced spurious HANDOFF/HISTORY entries that recorded "no code changes" — noise in the change log and friction at the end of every read-only session.

The written rule at `.claude/rules/require-docs-on-code-change.md` already scopes the requirement to *modifications* of specific globs; the hook was simply stricter than the rule.

### Rationale
- Aligns hook behavior with the written rule (modifications gate the requirement).
- "Did this session edit covered files" is decidable from the Claude Code session transcript (`transcript_path` in the Stop hook payload) — no need to diff git state, which would be confused by pre-existing uncommitted changes from previous sessions.
- Detection happens in the hook layer, not in the validator, so `dockit-validate-session.sh` keeps a single clean responsibility ("are HANDOFF/HISTORY current?").
- Validator semantics unchanged: callers can still run it manually with `--human` to check doc freshness regardless of session activity.

### Implications
- Requires `python3` (already present on Ubuntu dev-vm; used for JSON parsing).
- Hook is silent on no-op sessions — no telemetry that the hook fired. Acceptable: the original hook was also silent on the happy path.
- If the transcript is missing or unreadable, the hook is lenient (exits 0). Acceptable: a malformed transcript is a Claude Code issue, not a docs-discipline issue.
- The glob list is duplicated between the rule file and the hook script. If the rule globs change, update both. Kept simple (no YAML parser dependency) at the cost of this duplication.

---

## D-009 - devenv-spawner is the user-provisioning layer of the devenv-stack

**Status:** accepted (2026-05-13)

### Decision
This repository is named `devenv-spawner` and serves as the user-provisioning layer of the `devenv-stack` registered in `~/src/home-infra/docs/DEVENV_STACK.md`.

### Context
The remote development tooling previously lived under several unrelated repo names (`tmux-workspace`, `ssh-session-menu`, `termux-client`, `dev-tools`, `dev-spawner`). On 2026-05-13 the stack was consolidated under the `devenv-*` naming model, with `home-infra` as source of truth, LLM-DocKit as the documentation scaffold, and ForgeOS as the operator toolbox layer.

### Rationale
- The repo provisions users who will consume the same remote development environment managed by the rest of the `devenv-stack`.
- The `devenv-spawner` name makes the role discoverable next to `devenv`, `devenv-entry`, `devenv-android`, and `devenv-bootstrap`.
- Keeping the old `~/src/dev-spawner` path as a temporary symlink protects active sessions and scripts while documentation and operators move to the new name.

### Implications
- New documentation, handoffs, and cross-repo references should use `devenv-spawner`.
- Historical references to `dev-spawner` remain valid when discussing pre-rename commits or compatibility symlinks.
- The parallel LLM-DocKit Stop-hook/validator upgrade remains separate work and should be committed independently.
