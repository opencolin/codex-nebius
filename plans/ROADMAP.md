# Release Roadmap (decided by PM council, 2026-06-12)

Decided by the `pm-council-roadmap` workflow (run `wf_f52b2608-46c`): 5 PM personas
proposed independently, each proposal was adversarially critiqued (all 5 received
"needs-changes"), and the council chair synthesized this final roadmap, correcting
factual errors in the proposals against the live repo and installed Codex CLI.

Machine-readable source of truth: `plans/roadmap.json` (workflow args come from it).

## Baseline

**v1.0** — Tag commit 8801e31 ("Add: Document 'cho' error cause and safe download method") as an annotated tag v1.0 with NO code changes. This is the last clean, intentional script+docs content commit; it deliberately EXCLUDES the later churn commits e91eaec ("fix") and 4f2f98f ("oops") and, critically, EXCLUDES 84f90e4 which is the current HEAD but adds ONLY the orchestrator-reserved plans/ directory (tagging HEAD would bake plans/ into the release artifact). Command: `git tag -a v1.0 8801e31 -m 'v1.0: initial Codex CLI + Nebius Token Factory direct-setup script and Mintlify docs'` then `git push origin v1.0`. Do NOT rewrite history and do NOT create CHANGELOG.md at the baseline (it is introduced in v1.1 with a retroactive v1.0 entry). NOTE FOR OPERATOR: every input proposal incorrectly stated HEAD == 4f2f98f; verified actual HEAD is 84f90e4 and 4f2f98f is two commits behind. If you prefer to tag the literal latest non-plans commit instead of 8801e31, use 4f2f98f, but 8801e31 is recommended because its predecessors e91eaec/4f2f98f were the messy 'fix'/'oops' edits.

## Releases

| Release | Theme | Items | Status |
|---------|-------|-------|--------|
| [v1.1](releases/v1.1.md) | Config correctness and project identity | 3 | **merged, tagged v1.1** |
| [v1.2](releases/v1.2.md) | Make it verifiable and keep the docs site buildable | 3 | in progress |
| [v2.0](releases/v2.0.md) | The coherent 2.0 | 4 | pending |

## Chair rationale

This is a small bash-script-plus-docs repo whose sole purpose is to emit one correct ~/.codex/config.toml and document it. The honest path to v2.0 is therefore: fix the artifact, prove it stays fixed, then make the docs tell the truth — not add features. I rejected every speculative tangent (TypeScript wrapper, caching flags, editor-integration expansion) and, per the hard constraint and the 2026-06-11 rollback, nothing resembling a proxy/relay/local server appears anywhere — v2.0 even removes the guide's existing Ollama-fallback and NPM-wrapper asides that nudged toward those forbidden patterns.

The single most consequential council disagreement was the wire_api/base_url contract, and three proposals (release-manager, dx-pm) asserted 'wire_api=chat is correct; the guide is factually backwards.' I verified this empirically against the installed Codex CLI 0.135.0 using `codex --strict-config doctor` on sandboxed configs: wire_api='chat' is REJECTED (config fails to load), wire_api='responses' LOADS, and 'bogus' is rejected too (the value is enum-validated). So the guide (lines 140-143) is CORRECT and I standardized on wire_api='responses' across script and docs, with `codex --strict-config doctor` as an objective, hermetic acceptance gate. I also confirmed disable_tools exists nowhere in the tracked tree (only in plans/), so I dropped the reliability-pm/scope-cutter 'reintroduce disable_tools' items as built on a false premise; and I confirmed Mintlify resolves bare nav slugs to .md, so I dropped the release-manager/scope-cutter '.md->.mdx rename' as unnecessary and risky, adopting the dx-pm/docs-pm 'prune nav + fix dangling links' approach instead.

Sequencing follows strict semver and dependency order: v1.1 (MINOR) ships the backward-compatible config-correctness + identity fixes the artifact needs (base_url root, wire_api=responses, drop the wrong OPENAI_API_KEY/auth.json instruction, fix the dead nebius-skill URL and the Mistral/Gemma mislabel, correct the README upstream link) plus CHANGELOG/.gitignore. v1.2 (MINOR) makes it durable: a test suite that always runs under HOME=$(mktemp -d) with a stubbed codex (the script hard-exits without codex on PATH — verified), ShellCheck+nav CI, and a buildable Mintlify site (nav pruned to the 6 real pages, dangling links repaired). v2.0 (MAJOR, exactly the required final version) is a genuine breaking change — consolidating to a single provider normalizes keys that existing configs/--profile calls depend on — bundled with the model refresh and the final guide reconciliation (the last place api.nebius.ai, the Ollama fallback, and the shashikant disclaimer live).

Constraint enforcement I performed myself: final release is exactly v2.0; 4 releases (baseline + 3); each release has <=4 items; within every release the item file sets are strictly DISJOINT (I rejected the faked disjointness in three proposals that split setup-codex-nebius.sh across multiple parallel items or assigned phantom sidecar files — the script is owned by exactly one item per release, and in v1.2/v2.0 docs/reference/models.md is deliberately reserved to a single owner to avoid the Mintlify-vs-model-refresh collision). No item touches plans/. All file paths referenced exist in the repo or are explicitly new. Every test plan uses the verified printf 'testkey\
n\
' driver (NOT </dev/null, which I confirmed aborts under set -e before config.toml is created) and overrides HOME so the real ~/.codex and shell profiles are never modified.

## Cross-release handoff notes (READ BEFORE IMPLEMENTING ANYTHING)

ORDERING AND CROSS-RELEASE HAZARDS for implementing agents:

1) BASELINE COMMIT: All five input proposals wrongly claimed HEAD == 4f2f98f. Verified actual HEAD is 84f90e4, which adds ONLY plans/. Tag v1.0 at 8801e31 (recommended: last clean script+docs commit) so the tag does NOT include plans/. Do not `git push` history; only the annotated tag. The operator (not an item) creates all tags.

2) setup-codex-nebius.sh is edited in BOTH v1.1 (fix-generated-config) and v2.0 (consolidate-provider-config). This is safe ONLY because releases are sequential. The v2.0 edit assumes v1.1 already landed (base_url=/v1, wire_api=responses, no auth.json line, provider relabeled). Do not run them in parallel.

3) wire_api MUST be 'responses', never 'chat'. This was verified live: `codex --strict-config doctor` rejects wire_api='chat' (config fails to load) and accepts 'responses'. The acceptance gate `codex --strict-config doctor` is the objective check. If a future agent 'helpfully' changes it to 'chat', CI/acceptance will (and should) fail.

4) disable_tools: DO NOT add it. It is not in the tracked tree (only in plans/ORCHESTRATION.md as historical context) and was removed after commit d7ad935. Several council proposals wanted to 'reintroduce' it — ignore that; it is unsourced and the responses wire_api is the actual serialization fix path.

5) TEST INVOCATION: Never drive the script with `</dev/null`. Verified: the `read -sp` on line 37 hits EOF, `set -e` aborts at Step 3, and config.toml is NEVER created — every downstream assertion then fails. Use `printf 'testkey\
n\
' | HOME=$(mktemp -d) bash setup-codex-nebius.sh`. Also: the script's Step 1 (line 14) hard-exits if `codex` is not on PATH, so the test harness MUST prepend a `codex` stub to PATH; CI (ubuntu-latest, no codex installed) depends on this stub — do not add a real codex install step to CI.

6) Do NOT upgrade `set -e` to `set -euo pipefail` in v1.1 or v1.2. The interactive `read` calls abort under -u/EOF and would break the verified happy path; no item requests this change. If a future hardening release wants it, it must also add EOF guards to the reads, but that is out of scope here.

7) DISJOINT-FILE enforcement within a release is real (items run as parallel agents in one worktree). Note specifically: in v1.2, fix-mintlify-nav owns docs/introduction.md, quick-start.md, installation.md, usage/basic-commands.md, troubleshooting/common-issues.md and mint.json — but NOT docs/reference/models.md, which is intentionally reserved so v2.0's refresh-model-catalog can own it cleanly. In v2.0, the three model_name strings must match byte-for-byte across four files written by three different items (consolidate-provider-config -> script; refresh-model-catalog -> models.md; cut-v2-release -> README.md; reconcile-setup-guide -> guide). Treat docs/reference/models.md as the source of truth for those exact strings; if any model cannot be verified against the live Token Factory catalog, KEEP the existing IDs in all four rather than inventing new ones (no item can hit the live catalog in CI).

8) The .gitignore item must NOT add plans/ (it is tracked + orchestrator-reserved) and must NOT delete the existing .pytest_cache/ directory (only ignore it). README host normalization: mint.json uses nebius.com; README/guide have stray nebius.ai links — normalize to nebius.com where they are project/marketing links (the api host is api.tokenfactory.nebius.com, distinct).

9) base_url change (/v1/chat/completions -> /v1 root): verified the full path still LOADS under strict-config, so frame this as an internal-consistency fix (docs/reference/models.md:154 already uses /v1), not 'config is broken.' The runtime double-path concern could not be verified locally; the consistency argument is the defensible, checkable one.
