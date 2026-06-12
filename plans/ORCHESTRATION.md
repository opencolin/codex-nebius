# Orchestration Plan: codex-nebius releases to v2.0

This is the master plan for the multi-agent release pipeline. Any agent picking up
this project should read this file, then `plans/HANDOFF.md` for live state, then
the per-release plans in `plans/releases/`.

## Mission

Take opencolin/codex-nebius from its current unversioned state to a tagged v2.0
through a sequence of small releases, decided by a council of PM agents and
implemented by per-release workflows in isolated git worktrees.

## Hard constraints (do not violate)

1. **Direct-setup only. No proxy.** The project configures Codex CLI to talk
   *directly* to Nebius Token Factory. A merge of the
   KiranChilledOut/claude-codex-nebius-proxy codebase was explicitly rejected and
   rolled back on 2026-06-11 (force-push reset to `4f2f98f`). Do not re-introduce
   any proxy/server component.
2. **The repo stays a script + docs project.** Bash setup script, setup guide,
   Mintlify docs. No long-running services.
3. **Tests must never touch the user's real environment.** Any execution of
   `setup-codex-nebius.sh` in tests must run with an overridden `HOME`
   (e.g. `HOME=$(mktemp -d)`) so the real `~/.codex` and shell profiles
   (`~/.zshrc`, `~/.bashrc`) are never modified.
4. **Release work items must not touch `plans/`.** That directory belongs to the
   orchestrator; release branches editing it would conflict with live handoff
   updates on main.
5. **Releases are sequential.** Each release branches from main *after* the
   previous release merged. No parallel release branches.

## Known issues feeding the roadmap (from git history + README review)

- Piped-download corruption of the setup script (the "cho: command not found"
  error) — currently only worked around by a download-first instruction.
- Tool-call serialization issues against the `/chat/completions` endpoint led to
  a `disable_tools` config and endpoint switching (commits `53ad639`, `d7ad935`,
  `2f9814d`).
- README intro links "Codex CLI" to `shashikant86/codex-cli`; the official repo
  is `openai/codex` (the Resources section is correct).
- `base_url` in generated config embeds the full `/v1/chat/completions` path.
- Model profiles (Hermes-4-405B / Gemma-3-27b / Qwen3-Coder-480B) may be stale
  vs. the current Token Factory catalog.
- No CI, no tests, no .gitignore, no CHANGELOG, no version tags.

## Pipeline design

### Phase 1 — PM council (Workflow: `pm-council-roadmap`)

- 5 PM personas propose independent roadmaps (parallel, fresh context each):
  release-manager, dx-pm, reliability-pm, docs-pm, scope-cutter.
- Each proposal gets an adversarial critique (pipeline stage, no barrier).
- A chair agent receives all proposal+critique pairs (barrier — needs all) and
  emits the final roadmap as structured JSON:
  - 2–4 releases, final one exactly `v2.0`
  - baseline decision for the current state (e.g. tag `v1.0` as-is)
  - per release: theme, rationale, ≤4 work items with exact file lists
    (disjoint within a release so item agents can run in parallel),
    acceptance criteria, test plan.

### Phase 2 — Documentation

Orchestrator writes from the council JSON:
- `plans/ROADMAP.md` — the decided roadmap + rationale
- `plans/releases/<version>.md` — one per release, self-contained enough for a
  cold agent to implement
- updates `plans/HANDOFF.md`
Commit and push to main before any implementation starts.

### Phase 3 — Per-release implementation (Workflow: `release-implement`, one run per release)

For release `<ver>`:

```bash
cd /Users/colin/Code/codex/codex-nebius
git worktree add -b release/<ver> /Users/colin/Code/codex/worktrees/<ver> main
```

Workflow stages (args = the release object from the roadmap JSON):
1. **Implement** — one agent per work item, in parallel, all operating only on
   files inside `/Users/colin/Code/codex/worktrees/<ver>`. Item agents edit
   files only; they do not run git commands.
2. **Verify** — one agent checks `bash -n`, runs the script HOME-sandboxed,
   checks every acceptance criterion. Returns `{pass, issues[]}`.
3. **Fix** — if verification fails, a fix agent addresses `issues`, then
   re-verify. Max 2 fix rounds; if still failing, stop and record in HANDOFF.

Then the orchestrator (main loop, not agents):
```bash
cd /Users/colin/Code/codex/worktrees/<ver>
git add -A && git commit          # release content
cd /Users/colin/Code/codex/codex-nebius
git merge --no-ff release/<ver>
git tag <ver>
git push origin main --tags
git worktree remove /Users/colin/Code/codex/worktrees/<ver>
git branch -d release/<ver>
```

Update `plans/HANDOFF.md` + roadmap status, commit, push. Move to next release.

### Phase 4 — Close-out

Verify all tags on origin, clean tree, no leftover worktrees; mark HANDOFF
complete with resume instructions.

## Timer protocol

The orchestrator self-schedules wake-ups while workflows run in the background.
Requested tick: 30s; the platform clamps to a 60s minimum, so ticks are 60s.
Each tick: check workflow status, advance the pipeline if a phase finished,
refresh the heartbeat line in `plans/HANDOFF.md`.

## How to resume this pipeline (for any agent)

1. Read `plans/HANDOFF.md` — it names the current phase, running workflow runId,
   persisted workflow script path, and next action.
2. If a workflow was mid-run: resume with
   `Workflow({scriptPath: <from HANDOFF>, resumeFromRunId: <from HANDOFF>})` —
   completed agents return cached results; only unfinished calls re-run.
3. If between releases: take the next unstarted release from `plans/ROADMAP.md`,
   follow Phase 3 above.
4. Worktrees live under `/Users/colin/Code/codex/worktrees/<ver>`; if one exists
   for an unmerged release, inspect `git -C <worktree> status` before re-running.
