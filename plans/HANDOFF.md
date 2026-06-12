# HANDOFF — live pipeline state

> Updated by the orchestrator at each milestone/tick. Read `plans/ORCHESTRATION.md` first,
> then `plans/ROADMAP.md` (especially its cross-release handoff notes), then the
> per-release plan you are working on.

## Current phase

**Phase 3 — implementing v2.0 (FINAL release)** (workflow `release-implement`)

- Council (Phase 1): DONE — runId `wf_f52b2608-46c`, decided v1.0 baseline + v1.1/v1.2/v2.0.
- Roadmap docs (Phase 2): DONE — see `plans/ROADMAP.md`, `plans/releases/*.md`, `plans/roadmap.json`.
- v1.1: MERGED + tagged (workflow runId `wf_3361321e-952`, passed verify round 1, 4 agents)
- v1.2: MERGED + tagged (workflow runId `wf_e77a7467-74f`, passed verify round 1, 4 agents)
- v2.0 release workflow: RUNNING — runId `wf_56d0398b-d6b` (background task `wk6au7e9m`)
- Reusable release script (patched): `~/.claude/projects/-Users-colin-Code-codex-codex-nebius/2b60d6ac-dd12-4c72-a5e7-74b559b601d9/workflows/scripts/release-implement-wf_643989a3-732.js`
  — invoke per release with `Workflow({scriptPath, args: {version, worktreePath, items: [{id, files[]}]}})`;
  agents read full specs from `plans/releases/<ver>.md` in the worktree.
- GOTCHA for future agents: Workflow `args` can arrive as a JSON-encoded STRING inside the
  script. The script now guards with `typeof args === 'string' ? JSON.parse(args) : args`.
  First launch (runId `wf_643989a3-732`) crashed on this before any agent ran.

## Next action

When the v2.0 workflow completes with a passing verdict: commit in the worktree,
merge `release/v2.0` into main with `--no-ff`, tag `v2.0`, push main + tags, remove
the worktree, update this file + ROADMAP, then CLOSE OUT (Phase 4): verify all tags
on origin, clean tree, no leftover worktrees, mark this file complete.

## Release status

| Release | Status | Branch | Worktree | Tag pushed |
|---------|--------|--------|----------|------------|
| v1.0 (baseline) | tagged @ `8801e31` | — | — | yes |
| v1.1 | merged + tagged | merged, branch deleted | removed | yes |
| v1.2 | merged + tagged | merged, branch deleted | removed | yes |
| v2.0 | in progress | `release/v2.0` | `/Users/colin/Code/codex/worktrees/v2.0` | no |

## Repo state

- origin: https://github.com/opencolin/codex-nebius
- main: `4f2f98f` + plans commits (84f90e4, …)
- Baseline tag: `v1.0` @ `8801e31` (annotated; deliberately excludes the
  "fix"/"oops" commits and plans/ — see ROADMAP baseline section)
- Worktrees root: `/Users/colin/Code/codex/worktrees/`

## Workflow run registry

| Workflow | runId | Status | Notes |
|----------|-------|--------|-------|
| pm-council-roadmap | `wf_f52b2608-46c` | completed | 11 agents; full output: `/private/tmp/claude-501/-Users-colin-Code-codex/2b60d6ac-dd12-4c72-a5e7-74b559b601d9/tasks/w3rcftvip.output` |
| release-implement (v1.1) | `wf_3361321e-952` | completed, pass | output: `/private/tmp/claude-501/-Users-colin-Code-codex/2b60d6ac-dd12-4c72-a5e7-74b559b601d9/tasks/w4uhzuler.output` |
| release-implement (v1.2) | `wf_e77a7467-74f` | completed, pass | output: `/private/tmp/claude-501/-Users-colin-Code-codex/2b60d6ac-dd12-4c72-a5e7-74b559b601d9/tasks/w6hjf27s1.output` |
| release-implement (v2.0) | `wf_56d0398b-d6b` | running | task `wk6au7e9m` |

## Heartbeat

Last orchestrator tick: 2026-06-12T09:07Z (v1.2 merged+tagged; v2.0 launched)
