# Codex CLI + Nebius Token Factory

Welcome to the Codex CLI integration with Nebius Token Factory. This documentation guides you through setting up and using Codex CLI with Token Factory models for AI-assisted coding.

## What is Codex CLI?

[Codex CLI](https://github.com/openai/codex) is OpenAI's command-line interface that acts as a universal AI coding assistant. It supports multiple model providers through a unified CLI interface, allowing you to switch between different LLM backends seamlessly.

## What is Nebius Token Factory?

[Nebius Token Factory](https://nebius.com/token-factory) provides access to 40+ open-source language models including:
- **Qwen** (reasoning and coding)
- **DeepSeek** (advanced reasoning)
- **Llama** (general purpose)
- **Hermes** (high quality)
- **Gemma** (efficient)
- And many more

All models are available through a simple OpenAI-compatible API.

## Why Use Codex CLI + Token Factory?

- **Flexibility** — Switch between multiple models instantly
- **Unified Interface** — One CLI for all your LLM needs
- **Easy Setup** — Configuration-based, no plugins needed
- **Multiple Profiles** — Different models for different tasks

## Quick Start

```bash
# 1. Install Codex CLI
npm install -g @openai/codex

# 2. Run the setup script
bash setup-codex-nebius.sh

# 3. Start coding
codex "Write a Python function to validate email"
```

## Documentation Structure

- **[Quick Start](./quick-start)** — Get up and running in 5 minutes
- **[Installation](./installation)** — Detailed installation instructions
- **[Setup & Configuration](./setup/overview)** — Configure your provider and profiles
- **[Usage Guide](./usage/basic-commands)** — Learn Codex CLI commands
- **[Reference](./reference/models)** — Complete reference documentation
- **[Troubleshooting](./troubleshooting/common-issues)** — Common issues and solutions

## Next Steps

Ready to get started? Head to the [Quick Start](./quick-start) guide.

Have questions? Check [Troubleshooting](./troubleshooting/common-issues) or open an [issue on GitHub](https://github.com/opencolin/codex-nebius/issues).
