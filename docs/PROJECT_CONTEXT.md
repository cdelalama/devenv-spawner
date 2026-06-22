<!-- doc-version: 0.1.2 -->
# Project Context - devenv-spawner

## Vision
Automate the creation of development user environments on a shared VM, so new users (family members) get a fully working dev setup identical to the reference environment in minutes, not hours.

## Objectives
1. Single script to provision a new user with all dev tooling
2. Idempotent: safe to re-run on existing users (updates without destroying)
3. Each user gets isolated home, projects, config, and credentials
4. Shared system resources (Docker daemon, Go, system packages) used efficiently
5. Documented decisions for every design choice

## Stakeholders
- Technical owner: Carlos de la Lama-Noriega
- Primary users: Laura, Oscar (family members)
- Environment: dev-vm (10.0.0.110, Ubuntu 22.04, 16GB RAM, 2 vCPU)

## Architectural Overview
A provisioning script (bash) that:
1. Creates a Linux user with proper groups
2. Copies/generates dotfiles (.bashrc, .profile, tmux.conf)
3. Installs per-user tools (NVM + Node, Claude Code)
4. Sets up directory structure (~/src/, ~/runtime/)
5. Configures git, SSH keys, and basic Claude Code config

Shared system-level tools (Docker, Go, Python) are NOT installed per-user -- they're already available system-wide.

## Current Status (2026-06-22)
v0.1.2 completes the LLM-DocKit governance cleanup: SessionStart onboarding,
validator, version sync tooling, Trace helper, Codex hook installer, GitHub
templates, versioning rules, and integration docs are aligned with the current
template. The provisioning behavior remains unchanged: spawn-user.sh includes
automatic verify (bash) + diagnose (Claude Code CLI). Test phase with testuser
is complete; Laura has been provisioned. The repository was renamed from
`dev-spawner` to `devenv-spawner` and is the user-provisioning layer of the
`devenv-stack` registered in `~/src/home-infra/docs/DEVENV_STACK.md`.

## Upcoming Milestones
1. ~~Brainstorming: resolve all open design decisions~~ - DONE 2026-03-01
2. ~~v0.1.0: Core provisioning + teardown scripts~~ - DONE 2026-03-01
3. Rollout: remove testuser and provision Laura, then Oscar - IN PROGRESS
4. v0.2.0: Additional optional modules (doppler, etc.) - TBD

## References
- Infrastructure docs: ~/src/home-infra/docs/
- Devenv stack source of truth: ~/src/home-infra/docs/DEVENV_STACK.md
- Reference environment: cdelalama@dev-vm user setup
- Template: [LLM-DocKit](https://github.com/cdelalama/LLM-DocKit)
