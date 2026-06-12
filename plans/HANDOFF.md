# HANDOFF — live pipeline state

> Updated by the orchestrator at each milestone/tick. Read `plans/ORCHESTRATION.md` first.

## Current phase

**Phase 1 — PM council running** (workflow `pm-council-roadmap`)

- Council workflow runId: `wf_f52b2608-46c` (background task `w3rcftvip`)
- Workflow script path: `~/.claude/projects/-Users-colin-Code-codex/2b60d6ac-dd12-4c72-a5e7-74b559b601d9/workflows/scripts/pm-council-roadmap-wf_f52b2608-46c.js`
- Resume if interrupted: `Workflow({scriptPath: <above>, resumeFromRunId: "wf_f52b2608-46c"})`
- Started: 2026-06-12T08:31:58Z

## Next action

When the council workflow completes: take its returned roadmap JSON, write
`plans/ROADMAP.md` + `plans/releases/<version>.md`, commit + push, then begin
Phase 3 with the first release (see ORCHESTRATION.md Phase 3 runbook).

## Release status

| Release | Status | Branch | Worktree | Tag pushed |
|---------|--------|--------|----------|------------|
| _(decided by council)_ | — | — | — | — |

## Repo state

- main @ `4f2f98f` (+ plans/ commits), origin: https://github.com/opencolin/codex-nebius
- No version tags yet; baseline tagging is a council decision.
- Worktrees root: `/Users/colin/Code/codex/worktrees/` (empty)

## Heartbeat

Last orchestrator tick: 2026-06-12T08:31:58Z (pipeline starting)
