#!/bin/bash
#
# Test harness for setup-codex-nebius.sh
#
# HARD RULE: every invocation of the setup script runs inside a throwaway HOME
# (HOME=$(mktemp -d), removed via trap) and with a stubbed `codex` prepended to
# PATH, so the real ~/.codex and shell profiles (~/.zshrc, ~/.bashrc) are never
# read or written, and Step 1 of the script (which hard-exits when `codex` is
# absent) passes deterministically without the real CLI.
#
# The script is driven NON-INTERACTIVELY with:
#     printf 'testkey\nn\n' | HOME=$tmp bash setup-codex-nebius.sh
# (a fake key, then 'n' to decline the connection test so no network call
# happens). Never pipe </dev/null: the `read -sp` hits EOF and `set -e` aborts
# before config.toml is created.
#
# Pure bash, no external test dependencies. Entrypoint: `bash tests/run.sh`.
# Exits 0 only if every assertion passes; non-zero on the first failure.

set -e

# ----------------------------------------------------------------------------
# Locate the repo root (parent of this tests/ directory) and the setup script.
# ----------------------------------------------------------------------------
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
SETUP_SCRIPT="$REPO_ROOT/setup-codex-nebius.sh"

if [ ! -f "$SETUP_SCRIPT" ]; then
    echo "FATAL: cannot find setup script at $SETUP_SCRIPT" >&2
    exit 1
fi

# ----------------------------------------------------------------------------
# Snapshot the REAL environment up front so we can prove at the end that the
# suite never touched it. We capture checksums of the files the script would
# write if HOME were not overridden.
# ----------------------------------------------------------------------------
REAL_HOME="$HOME"
real_fingerprint() {
    # Print "<sum> <path>" for each real file that exists; silent for missing.
    for f in "$REAL_HOME/.codex/config.toml" "$REAL_HOME/.zshrc" "$REAL_HOME/.bashrc"; do
        if [ -f "$f" ]; then
            shasum "$f" 2>/dev/null || true
        fi
    done
}
REAL_BEFORE=$(real_fingerprint)

# ----------------------------------------------------------------------------
# Build a stub `codex` on a temp bin dir. The setup script's Step 1 hard-exits
# if `codex` is not on PATH (line 14), so this stub is what makes tests (and
# CI, where the real CLI is absent) deterministic. It just prints a fake
# version string.
# ----------------------------------------------------------------------------
STUB_BIN=$(mktemp -d)
cat > "$STUB_BIN/codex" <<'STUB'
#!/bin/sh
echo "codex-cli 0.0.0-test"
STUB
chmod +x "$STUB_BIN/codex"

# Track sandbox HOMEs we create so the trap can clean every one of them up.
SANDBOXES=""

# shellcheck disable=SC2329  # invoked indirectly via `trap cleanup EXIT` below
cleanup() {
    rm -rf "$STUB_BIN"
    for d in $SANDBOXES; do
        rm -rf "$d"
    done
}
trap cleanup EXIT

# ----------------------------------------------------------------------------
# Tiny assertion helpers.
# ----------------------------------------------------------------------------
PASS=0
assert() {
    # assert <description> <condition-as-already-evaluated 0/1 via test>
    local desc="$1"
    shift
    if "$@"; then
        PASS=$((PASS + 1))
        printf 'ok   - %s\n' "$desc"
    else
        printf 'FAIL - %s\n' "$desc" >&2
        exit 1
    fi
}

fail() {
    printf 'FAIL - %s\n' "$1" >&2
    exit 1
}

# new_sandbox: echo a fresh throwaway HOME and register it for cleanup.
new_sandbox() {
    local d
    d=$(mktemp -d)
    SANDBOXES="$SANDBOXES $d"
    printf '%s' "$d"
}

# run_setup <home>: drive the setup script non-interactively inside the given
# sandbox HOME with the codex stub prepended to PATH. Feeds a fake key, then
# 'n' to decline the connection test. Echoes the script's combined output.
FAKE_KEY="testkey"
run_setup() {
    local home="$1"
    printf '%s\nn\n' "$FAKE_KEY" \
        | HOME="$home" PATH="$STUB_BIN:$PATH" bash "$SETUP_SCRIPT" 2>&1
}

echo "== setup-codex-nebius.sh test harness =="
echo "repo root: $REPO_ROOT"
echo

# ----------------------------------------------------------------------------
# (a) The script creates $HOME/.codex/config.toml and exits 0.
# ----------------------------------------------------------------------------
HOME_A=$(new_sandbox)
set +e
OUT_A=$(run_setup "$HOME_A")
RC_A=$?
set -e
assert "script exits 0 in a sandbox HOME" test "$RC_A" -eq 0
assert "config.toml is created under \$HOME/.codex" test -f "$HOME_A/.codex/config.toml"

CONFIG_A="$HOME_A/.codex/config.toml"

# ----------------------------------------------------------------------------
# (b) base_url has no '/chat/completions' and wire_api='responses' appears twice.
# ----------------------------------------------------------------------------
if grep -q 'chat/completions' "$CONFIG_A"; then
    fail "base_url must NOT contain '/chat/completions'"
fi
assert "no '/chat/completions' anywhere in generated config" true

WIRE_COUNT=$(grep -c 'wire_api = "responses"' "$CONFIG_A")
assert "wire_api = \"responses\" appears exactly twice (found $WIRE_COUNT)" test "$WIRE_COUNT" -eq 2

# Also assert wire_api is never 'chat' (the value strict-config rejects).
if grep -q 'wire_api *= *"chat"' "$CONFIG_A"; then
    fail "wire_api = \"chat\" must never appear (rejected by codex --strict-config)"
fi
assert "wire_api is never \"chat\"" true

# ----------------------------------------------------------------------------
# (c) No OPENAI_API_KEY / auth.json text in the setup script.
# ----------------------------------------------------------------------------
if grep -q 'OPENAI_API_KEY' "$SETUP_SCRIPT"; then
    fail "setup script must not mention OPENAI_API_KEY"
fi
if grep -q 'auth.json' "$SETUP_SCRIPT"; then
    fail "setup script must not mention auth.json"
fi
assert "setup script has no OPENAI_API_KEY / auth.json text" true

# ----------------------------------------------------------------------------
# (d) Idempotency: running twice into the same sandbox HOME leaves exactly one
#     `export NEBIUS_API_KEY=` line in the written profile.
#
# Driven via `bash`, the script sets BASH_VERSION and writes to $HOME/.bashrc.
# We assert on whichever profile actually received the export, to stay robust.
# ----------------------------------------------------------------------------
HOME_D=$(new_sandbox)
set +e
run_setup "$HOME_D" >/dev/null 2>&1
RC_D1=$?
run_setup "$HOME_D" >/dev/null 2>&1
RC_D2=$?
set -e
assert "idempotency: first run exits 0" test "$RC_D1" -eq 0
assert "idempotency: second run exits 0" test "$RC_D2" -eq 0

# Sum export lines across both candidate profile files (only one should exist).
EXPORT_COUNT=0
for prof in "$HOME_D/.bashrc" "$HOME_D/.zshrc"; do
    if [ -f "$prof" ]; then
        n=$(grep -c 'export NEBIUS_API_KEY=' "$prof")
        EXPORT_COUNT=$((EXPORT_COUNT + n))
    fi
done
assert "exactly one 'export NEBIUS_API_KEY=' line after two runs (found $EXPORT_COUNT)" \
    test "$EXPORT_COUNT" -eq 1

# ----------------------------------------------------------------------------
# (e) The entered key value is never echoed to stdout/stderr (read -sp is
#     silent). We captured the combined output of run (a); assert the fake key
#     never appears in it.
# ----------------------------------------------------------------------------
if printf '%s' "$OUT_A" | grep -q "$FAKE_KEY"; then
    fail "the entered API key ('$FAKE_KEY') leaked into the script output"
fi
assert "entered API key is never echoed to output" true

# ----------------------------------------------------------------------------
# Optional config-validity check.
#
# Only runs if a GENUINE codex binary is provided (not our stub), via the
# CODEX_REAL env var pointing at a real `codex` executable. This keeps the
# suite hermetic by default and lets CI (no codex installed) skip gracefully.
# When enabled, run the real codex against the sandbox config and assert it
# loads under --strict-config.
# ----------------------------------------------------------------------------
if [ -n "${CODEX_REAL:-}" ] && [ -x "$CODEX_REAL" ]; then
    VER=$("$CODEX_REAL" --version 2>/dev/null || true)
    case "$VER" in
        *0.0.0-test*)
            echo "skip - CODEX_REAL points at the test stub; skipping config-validity check"
            ;;
        *)
            echo "info - running config-validity check with CODEX_REAL=$CODEX_REAL ($VER)"
            set +e
            DOCTOR_OUT=$(CODEX_HOME="$HOME_A/.codex" "$CODEX_REAL" --strict-config doctor 2>&1)
            set -e
            # `codex doctor` runs a FULL health diagnostic and its overall exit
            # code reflects auth/network too, which we intentionally do not have
            # (fake key, no connection). The spec asks us to assert the config
            # LOADS, so we check doctor's config signal explicitly and ignore
            # the auth/websocket sections. Under --strict-config a bad config
            # (e.g. wire_api="chat") would NOT report "loaded"/"parse ok".
            if printf '%s\n' "$DOCTOR_OUT" | grep -Eq 'config[[:space:]]+loaded|config\.toml parse[[:space:]]+ok'; then
                assert "codex --strict-config doctor reports config loaded" true
            else
                printf '%s\n' "$DOCTOR_OUT" >&2
                fail "codex --strict-config doctor did not report the config as loaded"
            fi
            ;;
    esac
else
    echo "skip - no real codex provided (set CODEX_REAL=/path/to/codex to enable config-validity check)"
fi

# ----------------------------------------------------------------------------
# Prove the real environment was never touched.
# ----------------------------------------------------------------------------
REAL_AFTER=$(real_fingerprint)
if [ "$REAL_BEFORE" != "$REAL_AFTER" ]; then
    echo "expected (before):" >&2
    printf '%s\n' "$REAL_BEFORE" >&2
    echo "actual   (after):" >&2
    printf '%s\n' "$REAL_AFTER" >&2
    fail "real \$HOME files changed during the run (sandbox leak!)"
fi
assert "real \$HOME (.codex/config.toml, .zshrc, .bashrc) is byte-identical before/after" true

echo
echo "== all $PASS assertions passed =="
exit 0
