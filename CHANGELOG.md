# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
