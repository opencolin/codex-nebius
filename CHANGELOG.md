# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-06-12

The coherent 2.0: a breaking provider-config cleanup, a verified-fresh model
catalog, and a docs set fully reconciled with the shipped configuration.

### Changed

- **BREAKING:** Consolidated the generated `config.toml` to a single
  `nebius_token_factory` model provider. All three profiles
  (`nebius-token-factory`, `nebius-fast`, `nebius-precise`) now set
  `model_provider = "nebius_token_factory"`, and the redundant
  `[model_providers.nebius_fast]` block — which only differed by a now-removed
  label and was otherwise identical — has been removed. This normalizes the
  provider/profile keys that existing `~/.codex/config.toml` files and
  `--profile` invocations depend on.
- Refreshed and re-verified the Token Factory model catalog
  (`docs/reference/models.md`), adding a "Models last verified" date and a link
  to the official Token Factory model list so future staleness is checkable.
- Reconciled `CODEX_CLI_SETUP_GUIDE.md` with the shipped config: every
  `config.toml` example now uses the API root
  `https://api.tokenfactory.nebius.com/v1` with `wire_api = "responses"`, the
  consolidated single-provider layout is reflected throughout, the host is
  corrected to `api.tokenfactory.nebius.com`, the Node.js requirement reads 22+,
  and the official Codex CLI link points at
  [openai/codex](https://github.com/openai/codex).

### Added

- `LICENSE` file at the repository root (MIT), matching the license already
  declared in the README.
- "Upgrading from 1.x" guidance in the README pointing at the migration notes
  below.

### Removed

- Removed the setup guide's local-Ollama fallback profile and the NPM/TypeScript
  wrapper aside, both of which nudged toward unsupported, non–direct-setup
  patterns.

### Migration

This release **changes the provider and profile layout** of the generated
`~/.codex/config.toml`. If you configured Codex with a 1.x version of this
project, your existing config references the removed `nebius_fast` provider.

To migrate:

1. Re-run the setup script
   (`bash setup-codex-nebius.sh`). Before writing the new configuration it copies
   your current `~/.codex/config.toml` to a timestamped backup,
   `config.toml.bak.<timestamp>` (a prior backup is never overwritten), and
   prints a breaking-change notice with the backup path.
2. The regenerated config uses a single `nebius_token_factory` provider with
   `base_url = "https://api.tokenfactory.nebius.com/v1"` and
   `wire_api = "responses"`. All three profiles now reference that one provider.
3. If you had customized the old `nebius_fast` provider, re-apply those changes
   to the consolidated `nebius_token_factory` provider (or a new provider block
   of your own); any `--profile nebius-fast` invocations continue to work and now
   resolve through `nebius_token_factory`.

## [1.1.0]

Config correctness and project identity: make the generated `~/.codex/config.toml`
load and work, point the project at the real upstream, and add changelog/ignore
scaffolding.

### Added

- `CHANGELOG.md` (this file) following Keep a Changelog.
- `.gitignore` covering Python caches, editor metadata, `.env`, macOS cruft, and
  the `tmp-home/` test-scratch directory.

### Changed

- Generated config now uses the API root `https://api.tokenfactory.nebius.com/v1`
  for both model providers instead of embedding the full
  `/v1/chat/completions` path, matching the documented base URL.
- Both model providers now set `wire_api = "responses"`, the value accepted by the
  installed Codex CLI under `--strict-config` (`wire_api = "chat"` is rejected).
- Relabeled the second provider from "Nebius Fast (Mistral)" to "Nebius Fast" to
  match its Gemma-based profile.
- Corrected the README upstream link to the official
  [openai/codex](https://github.com/openai/codex) repository and fixed the
  positioning copy to describe remote, OpenAI-compatible Nebius Token Factory
  access rather than local AI.

### Removed

- Dropped the incorrect "Add your OPENAI_API_KEY to ~/.codex/auth.json" setup
  step; authentication is via the `NEBIUS_API_KEY` environment variable only.

### Fixed

- Repaired the dead setup-guide URL printed by the script and the dead
  `nebius-skill` references, pointing them at the `codex-nebius` repository.

## [1.0.0]

Initial release.

### Added

- `setup-codex-nebius.sh`: interactive script that installs/configures Codex CLI
  to talk directly to Nebius Token Factory, prompting for the API key and writing
  `~/.codex/config.toml` with model providers and ready-to-use profiles
  (Hermes-4-405B, Gemma-3-27b, Qwen3-Coder-480B).
- Mintlify documentation site: introduction, quick-start, installation, basic
  commands, model reference, and troubleshooting pages.
