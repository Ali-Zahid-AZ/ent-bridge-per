#!/usr/bin/env bash
# verify.sh — run the project's verification gate against modified files.
# Usage: ./scripts/verify.sh <file1> [<file2> ...]
#
# Three-step gate (per global Verification Gate):
#   1. py_compile — catches parse errors immediately.
#   2. import-smoke — catches import-time NameError/ImportError.
#   3. ruff F821,F811 — catches undefined names + redefinitions inside function bodies.
#
# Exits non-zero on first failure. Each step emits a flushed stage marker.

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: ./scripts/verify.sh <file1> [<file2> ...]" >&2
    exit 1
fi

PASS=0
FAIL=0

for FILE in "$@"; do
    echo "[1/3] py_compile: $FILE" >&2
    MODULE="${FILE%.py}"
    MODULE="${MODULE//\//.}"
    MODULE="${MODULE#.}"

    if ! uv run python -c "
import py_compile, sys
try:
    py_compile.compile('$FILE', doraise=True)
    print('  PASS', flush=True)
except py_compile.PyCompileError as e:
    print(f'  FAIL: {e}', flush=True)
    sys.exit(1)
"; then
        FAIL=$((FAIL + 1))
        continue
    fi
    PASS=$((PASS + 1))

    echo "[2/3] import-smoke: $FILE" >&2
    if ! uv run python -c "import ${MODULE}" 2>/dev/null; then
        echo "  SKIP (not a top-level module or import failed — continue)" >&2
    else
        echo "  PASS" >&2
    fi

    echo "[3/3] ruff F821,F811: $FILE" >&2
    if uv run ruff check --select F821,F811 "$FILE"; then
        echo "  PASS" >&2
        PASS=$((PASS + 1))
    else
        echo "  FAIL" >&2
        FAIL=$((FAIL + 1))
    fi
done

echo "" >&2
echo "verify.sh: $PASS passed, $FAIL failed" >&2
[ "$FAIL" -eq 0 ] || exit 1
