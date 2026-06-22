# Repository Structure Guide

## Top-Level Layout
```
devenv-spawner/
+-- .claude/                     (Claude Code hooks, rules, and local skills)
+-- .dockit-enabled              (LLM-DocKit sync opt-in marker)
+-- .github/                     (issue and PR templates)
+-- README.md                    (project introduction and quick start)
+-- LLM_START_HERE.md            (mandatory reading for LLM contributors)
+-- VERSION                      (project version, source of truth)
+-- CHANGELOG.md                 (user-visible change log)
+-- LICENSE
+-- docs/
|  +-- PROJECT_CONTEXT.md
|  +-- ARCHITECTURE.md
|  +-- STRUCTURE.md              (this file)
|  +-- VERSIONING_RULES.md       (SemVer and version sync policy)
|  +-- version-sync-manifest.yml (version marker targets)
|  +-- integrations/
|     +-- CODEX.md               (Codex CLI hook integration notes)
|  +-- llm/
|     +-- HANDOFF.md
|     +-- HISTORY.md
|     +-- DECISIONS.md
|     +-- README.md
|     +-- REVIEWS.md
+-- scripts/
|  +-- spawn-user.sh             (provisioning + verify + diagnose)
|  +-- despawn-user.sh           (user removal script)
|  +-- bump-version.sh           (version marker updater)
|  +-- check-version-sync.sh     (version marker validator)
|  +-- pre-commit-hook.sh        (local pre-commit guard)
|  +-- dockit-bootstrap-context.sh
|  +-- dockit-generate-external-context.sh
|  +-- dockit-install-codex-hook.sh
|  +-- dockit-trace-status.sh
|  +-- dockit-validate-session.sh
|  +-- test-validator.sh
+-- templates/
|  +-- bashrc.template           (user .bashrc)
|  +-- profile.template          (user .profile)
|  +-- tmux.conf.template        (user tmux config)
|  +-- gitconfig.template        (user git config, with placeholders)
|  +-- claude/
|     +-- CLAUDE.md.template     (Claude Code instructions, simplified)
|     +-- settings.json.template (Claude Code settings, base)
|     +-- settings.sounds.json.template (Claude Code settings with sound hooks)
|     +-- sounds/
|        +-- play-remote.sh      (sound notification script)
|        +-- play-error-remote.sh (error sound script with filtering)
+-- src/                         (reserved for future code)
+-- tests/                       (reserved for future tests)
```

## Directory Descriptions
| Path | Purpose | Notes |
|------|---------|-------|
| .claude/ | Claude Code hooks, rules, and repo-local skills | Required for Claude Code workflow |
| .dockit-enabled | Opts this repo into LLM-DocKit sync checks | Empty marker file |
| .github/ | GitHub issue and pull request templates | Optional operator convenience |
| docs/ | Project documentation | Required |
| docs/integrations/ | Integration notes for LLM tooling | Currently Codex CLI |
| docs/llm/ | Handoff and history for LLM contributors | Required |
| scripts/ | Provisioning (with verify+diagnose) and teardown scripts | Core of the project |
| scripts/dockit-*.sh | LLM-DocKit onboarding, validation, trace, and integration helpers | Operator workflow tooling |
| templates/ | Dotfile and config templates | Copied/rendered per user |
| templates/claude/ | Claude Code configuration templates | Includes base + sounds variants |
| src/ | Future application code | Currently empty |
| tests/ | Future automated tests | Currently empty |
