#!/usr/bin/env bash
# Validates that LLM session docs are up to date.
# Used by .claude/settings.json hooks.
#
# Usage:
#   scripts/dockit-validate-session.sh --human   # human-readable output
#   scripts/dockit-validate-session.sh --json     # JSON output for hooks
#   scripts/dockit-validate-session.sh --json --quiet  # silent, exit code only

set -euo pipefail

TODAY=$(date +%Y-%m-%d)
HANDOFF="docs/llm/HANDOFF.md"
HISTORY="docs/llm/HISTORY.md"

MODE="human"
QUIET=false
CHECKS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --human) MODE="human"; shift ;;
    --json)  MODE="json";  shift ;;
    --quiet) QUIET=true;   shift ;;
    --check) CHECKS+=("$2"); shift 2 ;;
    *) shift ;;
  esac
done

# If no specific checks, run all
if [[ ${#CHECKS[@]} -eq 0 ]]; then
  CHECKS=("handoff-date" "history-entry")
fi

PASS=true
FAILURES=()

for check in "${CHECKS[@]}"; do
  case "$check" in
    handoff-date)
      if ! grep -q "Last Updated.*${TODAY}" "$HANDOFF" 2>/dev/null; then
        PASS=false
        FAILURES+=("HANDOFF.md missing today's date ($TODAY)")
      fi
      ;;
    history-entry)
      if ! grep -q "^- ${TODAY}" "$HISTORY" 2>/dev/null; then
        PASS=false
        FAILURES+=("HISTORY.md missing entry for today ($TODAY)")
      fi
      ;;
  esac
done

if $PASS; then
  if [[ "$MODE" == "human" ]] && ! $QUIET; then
    echo "All checks passed."
  fi
  exit 0
else
  if ! $QUIET; then
    if [[ "$MODE" == "human" ]]; then
      echo "Documentation validation failed:"
      for f in "${FAILURES[@]}"; do
        echo "  - $f"
      done
    elif [[ "$MODE" == "json" ]]; then
      echo "{\"pass\": false, \"failures\": [\"${FAILURES[*]}\"]}"
    fi
  fi
  exit 1
fi
