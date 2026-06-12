# HANDOFF — pipeline COMPLETE ✅

> Final state, written at close-out on 2026-06-12. Read `plans/ORCHESTRATION.md`
> for how this pipeline worked and `plans/ROADMAP.md` for what was decided and shipped.

## Outcome

All releases decided by the PM council are **merged, tagged, and pushed**, and CI
is green on main (run 27406746953: ShellCheck ✓, sandboxed test suite ✓, nav-guard ✓).

| Release | Status | Tag on origin |
|---------|--------|---------------|
| v1.0 (baseline) | tagged @ `8801e31` (pre-existing content, no changes) | yes |
| v1.1 — config correctness & identity | merged + tagged, verify pass round 1 | yes |
| v1.2 — test harness, CI, Mintlify nav | merged + tagged, verify pass round 1 | yes |
| v2.0 — provider consolidation, model catalog, release cut | merged + tagged, verify pass round 1 | yes |

Post-release hotfix on main (not a release): CI workflow was rejected by GitHub
("Unrecognized named-value: 'runner'" — job-level `env` cannot use the `runner`
context; moved to step level) and `on: push` was limited to `main` so tag pushes
don't double-trigger. Recorded under `[Unreleased]` in CHANGELOG.md.

## Workflow run registry (session 2b60d6ac, 2026-06-12)

| Workflow | runId | Result |
|----------|-------|--------|
| pm-council-roadmap | `wf_f52b2608-46c` | roadmap decided (11 agents) |
| release-implement v1.1 | `wf_3361321e-952` | pass (4 agents) |
| release-implement v1.2 | `wf_e77a7467-74f` | pass (4 agents) |
| release-implement v2.0 | `wf_56d0398b-d6b` | pass (7 agents, incl. legitimate cross-item fix to tests/run.sh for the single-provider consolidation) |
| (crashed first attempt) | `wf_643989a3-732` | 0 agents — Workflow `args` arrived as a JSON string; script now guards with `typeof args === 'string' ? JSON.parse(args) : args` |

## Nothing to resume

No running workflows, no worktrees (`git worktree list` shows only the main
checkout), no release branches, clean tree. Future work starts a NEW pipeline:
follow `plans/ORCHESTRATION.md` from Phase 1 (council) with a fresh roadmap, or
implement individual changes conventionally against main with CI as the gate.

## Lessons recorded for future agents

1. Workflow `args` may arrive JSON-stringified — always guard-parse.
2. GitHub Actions context availability (e.g. `runner` only at step level) cannot
   be caught by YAML parsing or local step execution — only a real push reveals it.
3. Unfiltered `on: push` also fires on tag pushes — filter branches.
4. `codex --strict-config doctor` rejects `wire_api = "chat"`; `"responses"` is
   the verified value (negative-controlled in v1.1, v1.2, and v2.0 verification).
5. Never drive setup-codex-nebius.sh with `</dev/null`; use
   `printf 'testkey\nn\n' | HOME=$(mktemp -d) bash setup-codex-nebius.sh`.
