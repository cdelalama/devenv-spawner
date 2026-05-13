#!/usr/bin/env bash
# Stop hook for devenv-spawner.
#
# Reads the Claude Code Stop hook payload from stdin and decides whether to
# block the session-end based on TWO conditions, both of which must hold:
#
#   1. This session actually edited at least one file covered by the rule at
#      .claude/rules/require-docs-on-code-change.md (scripts/**/*.sh, src/**,
#      *.yml, *.yaml). Detected by scanning the session transcript for
#      Edit/Write/MultiEdit/NotebookEdit tool_use entries.
#
#   2. scripts/dockit-validate-session.sh --json --quiet exits non-zero
#      (HANDOFF/HISTORY do not have today's date).
#
# If either condition is false, the hook exits 0 silently. Read-only research
# sessions therefore do not get blocked — which was the original design intent
# of the rule (see D-008).
#
# Output (on block): single-line JSON with {"decision":"block","reason":"..."}
# per Claude Code hook contract.

set -euo pipefail

cd "$(dirname "$0")/.."

PAYLOAD=$(cat || true)

TOUCHED=$(PAYLOAD="$PAYLOAD" python3 - <<'PY'
import json, os, fnmatch, sys

raw = os.environ.get("PAYLOAD", "")
try:
    payload = json.loads(raw) if raw else {}
except json.JSONDecodeError:
    payload = {}

transcript = payload.get("transcript_path")
if not transcript or not os.path.exists(transcript):
    # No transcript -> can't prove an edit happened in this session.
    # Be lenient: don't block.
    print("no")
    sys.exit(0)

EDIT_TOOLS = {"Edit", "Write", "MultiEdit", "NotebookEdit"}

def covered(rel: str) -> bool:
    # Globs from .claude/rules/require-docs-on-code-change.md
    if rel.startswith("scripts/") and rel.endswith(".sh"):
        return True
    if rel.startswith("src/"):
        return True
    if rel.endswith(".yml") or rel.endswith(".yaml"):
        return True
    return False

project_root = os.getcwd()

def to_rel(path: str) -> str:
    if not path:
        return ""
    try:
        return os.path.relpath(path, project_root)
    except ValueError:
        return path

def iter_tool_uses(line: str):
    try:
        ev = json.loads(line)
    except json.JSONDecodeError:
        return
    msg = ev.get("message") or {}
    content = msg.get("content")
    if not isinstance(content, list):
        return
    for c in content:
        if isinstance(c, dict) and c.get("type") == "tool_use":
            yield c

touched = False
try:
    with open(transcript, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            for tu in iter_tool_uses(line):
                if tu.get("name") not in EDIT_TOOLS:
                    continue
                inp = tu.get("input") or {}
                fp = inp.get("file_path") or inp.get("notebook_path") or ""
                rel = to_rel(fp)
                if rel and not rel.startswith("..") and covered(rel):
                    touched = True
                    break
            if touched:
                break
except OSError:
    pass

print("yes" if touched else "no")
PY
)

if [[ "$TOUCHED" != "yes" ]]; then
  exit 0
fi

if scripts/dockit-validate-session.sh --json --quiet >/dev/null 2>&1; then
  exit 0
fi

printf '{"decision":"block","reason":"Documentation not up to date. This session edited files covered by .claude/rules/require-docs-on-code-change.md. Update docs/llm/HANDOFF.md (Last Updated date) and add an entry to docs/llm/HISTORY.md before ending the session. Run: scripts/dockit-validate-session.sh --human"}'
