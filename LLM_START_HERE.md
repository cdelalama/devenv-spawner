<!-- doc-version: 0.1.1 -->
# LLM Start Guide - devenv-spawner

## Read This First (Mandatory)

Welcome to devenv-spawner. Before you contribute, review the sections below.

Recommended reading order:
1. This file (rules, workflows, and current expectations)
2. docs/PROJECT_CONTEXT.md (vision, architecture, current state)
3. docs/llm/HANDOFF.md (current work state and priorities)

## Critical Rules (Non-Negotiable)

### Language Policy
- All code and documentation: English
- Conversation with the user: Spanish
- Comments in code: English
- File names: English

### Documentation Update Rules
- Update docs/llm/HANDOFF.md every time you make a change.
- Append an entry to docs/llm/HISTORY.md in every session.
- HISTORY format: YYYY-MM-DD - <LLM_NAME> - <Brief summary> - Files: [list] - Version impact: [yes/no + details]

### Commit Message Policy
- **Title:** under 72 characters
- **Description:** under 200 characters, focused on user impact and why the change matters

### Infrastructure Context
- Reference environment: cdelalama@dev-vm (10.0.0.110)
- Infrastructure docs: ~/src/home-infra/docs/ (INVENTORY.md, SERVICES.md, CONVENTIONS.md, ONBOARDING.md)
- These docs are the source of truth for network and infrastructure context

## Current Focus (Snapshot)

Source of truth: docs/llm/HANDOFF.md.
- Last Updated: 2026-05-13 - GPT-5 Codex
- Working on: Preserving the user-provisioning workflow while recording the `devenv-spawner` rename and stack membership.
- Status: v0.1.1 consolidates the Stop hook docs guardrail and the `devenv-spawner` rename cleanup. Auto-verify (bash) + auto-diagnose (Claude CLI) remain unchanged.

## Quick Navigation
- Project Overview: docs/PROJECT_CONTEXT.md
- Current Work State: docs/llm/HANDOFF.md
- Change History: docs/llm/HISTORY.md

---

Every change must be documented. If you are unsure about a rule, ask the user before proceeding.
