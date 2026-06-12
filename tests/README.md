# Tests

A pure-bash, dependency-free harness that exercises [`setup-codex-nebius.sh`](../setup-codex-nebius.sh)
without ever touching your real environment.

## Running

From the repository root:

```bash
bash tests/run.sh
```

It exits `0` only if every assertion passes, and non-zero on the first failure.
There are no external dependencies — just `bash`, `printf`, `grep`, `mktemp`,
and `shasum` (all standard on macOS and `ubuntu-latest`).

## The two mandatory rules

These are non-negotiable. Every place the suite executes the setup script obeys
both, and any new test you add must do the same.

### 1. HOME sandbox — never touch the real environment

The setup script writes to `$HOME/.codex/config.toml` and appends an
`export NEBIUS_API_KEY=...` line to a shell profile (`~/.bashrc` or `~/.zshrc`).
Tests must **never** let it write to your real home directory.

Every invocation therefore runs inside a throwaway HOME:

```bash
tmp=$(mktemp -d)
HOME="$tmp" bash setup-codex-nebius.sh   # writes into $tmp, not ~
```

The harness creates each sandbox with `mktemp -d`, registers it, and removes all
of them via a single `trap ... EXIT` cleanup. As a final guard it checksums your
real `~/.codex/config.toml`, `~/.zshrc`, and `~/.bashrc` **before and after** the
run and fails loudly if any of them changed.

### 2. The `printf 'testkey\nn\n'` driver — never `</dev/null`

The script is interactive: it reads the API key with `read -sp` and then asks
whether to test the connection with `read -p ... -n 1`. Drive it
non-interactively by piping exactly two lines:

```bash
printf 'testkey\nn\n' | HOME="$tmp" bash setup-codex-nebius.sh
#       \______/ \/
#        fake key  'n' = decline the connection test (no network call)
```

**Do not pipe `</dev/null`.** With no input, the `read -sp` on the key hits EOF
and — because the script runs under `set -e` — the run aborts at Step 3 *before*
`config.toml` is ever created, so every downstream assertion fails. This was
verified; the `printf` two-line driver is the supported pattern.

## The `codex` stub on PATH

Step 1 of the setup script hard-exits if `codex` is not found on `PATH`
(`command -v codex`). To keep tests deterministic — and to let CI pass on
`ubuntu-latest`, where the real CLI is **not** installed — the harness writes a
tiny stub to a temp bin dir and prepends it to `PATH`:

```sh
#!/bin/sh
echo "codex-cli 0.0.0-test"
```

That is the only reason Step 1 succeeds in CI; **do not** add a real `codex`
install step to the workflow.

## What is asserted

- **(a)** The script creates `$HOME/.codex/config.toml` and exits `0`.
- **(b)** `base_url` contains no `/chat/completions`, and `wire_api = "responses"`
  appears exactly twice (and `wire_api = "chat"` never appears — `chat` is
  rejected by `codex --strict-config`).
- **(c)** The setup script contains no `OPENAI_API_KEY` or `auth.json` text.
- **(d)** Idempotency: running twice into the same sandbox HOME leaves exactly
  one `export NEBIUS_API_KEY=` line in the written profile.
- **(e)** The entered key value is never echoed to output (the harness captures
  combined stdout/stderr and greps for the fake key, expecting none).
- A final guard asserts the real `$HOME` profile/config files are byte-identical
  before and after the suite.

## Optional: config-validity check

If you want the suite to additionally confirm that a *real* Codex CLI loads the
generated config, point `CODEX_REAL` at a genuine `codex` binary:

```bash
CODEX_REAL="$(command -v codex)" bash tests/run.sh
```

When set (and not pointing at the test stub), the harness runs
`CODEX_HOME=$HOME/.codex codex --strict-config doctor` against the sandbox config
and asserts it loads. When unset — the default, and the case in CI — this check
is skipped gracefully so the suite stays hermetic and never depends on the host
having `codex` installed.
