# Codex CLI + Nebius Token Factory

Setup and configure [Codex CLI](https://github.com/openai/codex) for AI-assisted coding using [Nebius Token Factory](https://nebius.com/token-factory) models over an OpenAI-compatible API.

## Quick Start

```bash
# 1. Install Codex CLI
npm install -g @openai/codex

# 2. Download and run the setup script
curl -fsSL https://raw.githubusercontent.com/opencolin/codex-nebius/main/setup-codex-nebius.sh -o setup-codex-nebius.sh
chmod +x setup-codex-nebius.sh
bash setup-codex-nebius.sh

# 3. Start coding
codex "Write a Python function to validate email addresses"
```

**Tip:** Download the script first instead of piping directly to avoid corruption issues.

## Features

🔄 **Flexible** — Switch models instantly via configuration  
🚀 **Fast Setup** — Automated configuration script  
📦 **Three Profiles** — Fast, balanced, and precise models  
🎯 **Unified CLI** — One interface for multiple LLM providers  

## What's Included

- **[setup-codex-nebius.sh](setup-codex-nebius.sh)** — Automated setup script
  - Checks dependencies
  - Creates `~/.codex` configuration
  - Prompts for API key securely
  - Tests connection to Token Factory
  - Generates pre-configured profiles

- **[CODEX_CLI_SETUP_GUIDE.md](CODEX_CLI_SETUP_GUIDE.md)** — Complete setup guide
  - Manual configuration steps
  - Advanced profile customization
  - Integration with editors (VSCode, Neovim)
  - Git workflow integration
  - Troubleshooting & security best practices

## Prerequisites

- **Codex CLI** — Install with `npm install -g @openai/codex`
- **Nebius Token Factory API key** — Get from https://nebius.com/
- **bash or zsh** — For the setup script

## Usage

### Basic Commands

```bash
# Using default profile (balanced)
codex "Write a Python function"

# Using fast profile
codex --profile nebius-fast "Quick implementation"

# Using precise profile
codex --profile nebius-precise "Detailed explanation"
```

### Override at Runtime

```bash
# Change temperature for more/less creative output
codex -c temperature=0.3 "Be precise"

# Limit response length
codex -c max_tokens=1024 "Short answer"
```

## Profiles

| Profile | Model | Use Case | Speed |
|---------|-------|----------|-------|
| **nebius-token-factory** (default) | Hermes-4-405B | Balanced, all-purpose | Medium |
| **nebius-fast** | Gemma-3-27b | Quick suggestions and completions | Fast |
| **nebius-precise** | Qwen3-Coder-480B | Complex coding and analysis | Slow |

## Configuration

After running the setup script, configuration is stored in `~/.codex/config.toml`.
All three profiles share a single `nebius_token_factory` provider:

```toml
default_provider = "nebius_token_factory"
default_profile = "nebius-token-factory"

[model_providers.nebius_token_factory]
name = "Nebius Token Factory"
base_url = "https://api.tokenfactory.nebius.com/v1"
env_key = "NEBIUS_API_KEY"
wire_api = "responses"

# Balanced (default)
[profiles.nebius-token-factory]
model_provider = "nebius_token_factory"
model_name = "nebius/NousResearch/Hermes-4-405B"
max_tokens = 4096
temperature = 0.7

# Fast
[profiles.nebius-fast]
model_provider = "nebius_token_factory"
model_name = "nebius/google/Gemma-3-27b-it"
max_tokens = 2048
temperature = 0.5

# Precise
[profiles.nebius-precise]
model_provider = "nebius_token_factory"
model_name = "nebius/Qwen/Qwen3-Coder-480B-A35B-Instruct"
max_tokens = 8192
temperature = 0.3
```

See [CODEX_CLI_SETUP_GUIDE.md](CODEX_CLI_SETUP_GUIDE.md) for detailed configuration options.

## Upgrading from 1.x

v2.0 is a **breaking** release: the redundant `nebius_fast` provider was removed and
all three profiles now reference the single `nebius_token_factory` provider. If you
have an existing `~/.codex/config.toml` from a 1.x setup, just re-run the setup
script — it backs up your old config to `config.toml.bak.<timestamp>` before writing
the new layout. See the [Migration notes in the CHANGELOG](CHANGELOG.md#migration)
for details.

## Troubleshooting

### "bash: line XXX: cho: command not found"

This error occurs when the setup script is corrupted during download via pipe.

**Solution:** Download the script first, then run it:
```bash
curl -fsSL https://raw.githubusercontent.com/opencolin/codex-nebius/main/setup-codex-nebius.sh -o setup-codex-nebius.sh
chmod +x setup-codex-nebius.sh
bash setup-codex-nebius.sh
```

Or clone the repository:
```bash
git clone https://github.com/opencolin/codex-nebius.git
cd codex-nebius
bash setup-codex-nebius.sh
```

### "Codex CLI not found"
```bash
npm install -g @openai/codex
```

### "UNAUTHENTICATED" error
Verify your Nebius API key:
```bash
echo $NEBIUS_API_KEY
```

Reload your shell profile if you just set it:
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Connection test failed
Check connectivity to Token Factory:
```bash
curl -H "Authorization: Bearer $NEBIUS_API_KEY" \
  https://api.tokenfactory.nebius.com/v1/models
```

For more troubleshooting, see [CODEX_CLI_SETUP_GUIDE.md](CODEX_CLI_SETUP_GUIDE.md#troubleshooting).

## Resources

- [Codex CLI GitHub](https://github.com/openai/codex) — Official Codex CLI repository
- [Nebius Documentation](https://docs.nebius.com/) — Official Nebius docs
- [Nebius Token Factory](https://nebius.com/token-factory) — Token Factory service
- [Codex Provider Configuration](https://www.morphllm.com/codex-provider-configuration) — Provider setup guide

## License

MIT

## Contributing

Found an issue or have suggestions? Please open an issue or submit a PR!

---

**Part of the [codex-nebius](https://github.com/opencolin/codex-nebius) project** — AI Skills for Nebius infrastructure
