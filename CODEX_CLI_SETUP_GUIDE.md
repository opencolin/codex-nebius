# Setting Up Codex CLI with Nebius Token Factory Models

A complete guide to configure Codex CLI to use Nebius Token Factory models for AI-assisted coding.

## Overview

Codex CLI is a universal AI coding assistant that supports multiple model providers through a unified CLI interface. This guide shows how to integrate it with **Nebius Token Factory models** for a unified command-line coding experience.

### Why Use Codex CLI + Token Factory?

- **Unified Interface**: One CLI for multiple model providers
- **Flexibility**: Switch models instantly via configuration
- **Easy Setup**: Configuration-based, no plugins needed
- **Multiple Profiles**: Different models for different tasks

## Prerequisites

Before starting, ensure you have:

1. **Node.js** (v16+) - For running Codex CLI
2. **Nebius Token Factory** - Access to Token Factory models
3. **System Requirements**:
   - At least 8GB RAM (16GB recommended for larger models)
   - For GPU acceleration: CUDA 11+ or Apple Silicon
   - ~30GB disk space for model weights

## Quick Start (Recommended)

```bash
# 1. Install Codex CLI
npm install -g @openai/codex

# 2. Run the setup script
curl -fsSL https://raw.githubusercontent.com/opencolin/nebius-skill/main/setup-codex-nebius.sh | bash

# 3. Start using Codex
codex "Write a Python function to validate email"
```

The setup script will:
- ✓ Verify Codex CLI is installed
- ✓ Create `~/.codex` configuration directory
- ✓ Prompt for your Nebius API key (saved securely)
- ✓ Generate `config.toml` with three profiles (fast, balanced, precise)
- ✓ Optionally test the connection

---

## Manual Installation

If you prefer to set up manually, follow these steps:

### Step 1: Install Codex CLI

```bash
# Via npm
npm install -g @openai/codex

# Via Homebrew (if available)
brew install codex-cli

# Verify installation
codex --version
```

### Step 2: Initialize Configuration Directory

```bash
# Create Codex config directory
mkdir -p ~/.codex

# Create main configuration file
touch ~/.codex/config.toml
```

## Configuring Token Factory Integration

### Understanding Token Factory

Token Factory is a Nebius service that provides:
- Tokenized access to language models
- Authentication via API keys
- Endpoint management and rate limiting
- Model versioning and switching

### Step 3: Configure Codex for Token Factory

Codex CLI uses a configuration-based provider system. Edit `~/.codex/config.toml` and add:

```toml
# Set default provider
default_profile = "nebius-token-factory"

# Define the Nebius Token Factory provider
# Codex follows a 3-tier config hierarchy:
# 1. CLI flags override everything
# 2. Profile settings override defaults
# 3. config.toml defaults apply

[model_providers.nebius_token_factory]
name = "Nebius Token Factory"
base_url = "https://api.tokenfactory.nebius.com/v1"
env_key = "NEBIUS_API_KEY"
wire_api = "responses"

[model_providers.nebius_fast]
name = "Nebius Fast (Mistral)"
base_url = "https://api.tokenfactory.nebius.com/v1"
env_key = "NEBIUS_API_KEY"
wire_api = "responses"
```

### Profile Configuration

Create profiles that reference your providers:

```toml
# Default profile - balanced use
[profiles.nebius-token-factory]
model_provider = "nebius_token_factory"
model_name = "nebius/NousResearch/Hermes-4-405B"
max_tokens = 4096
temperature = 0.7

# Fast profile - quick suggestions
[profiles.nebius-fast]
model_provider = "nebius_fast"
model_name = "nebius/google/Gemma-3-27b-it"
max_tokens = 2048
temperature = 0.5

# Precise profile - detailed analysis
[profiles.nebius-precise]
model_provider = "nebius_token_factory"
model_name = "nebius/Qwen/Qwen3-Coder-480B-A35B-Instruct"
max_tokens = 8192
temperature = 0.3
```

### Understanding `wire_api`

- **`wire_api = "responses"`** — The current standard for API-based providers (Token Factory, OpenAI, Azure)
- **`wire_api = "chat"`** — Deprecated; no longer supported by Codex CLI

Token Factory uses `wire_api = "responses"`. For more details, see the [Codex discussion on wire_api deprecation](https://github.com/openai/codex/discussions/7782).

### Step 4: Set Up Authentication

Store your Nebius Token Factory API key securely:

```bash
# Option 1: Environment variable (temporary)
export NEBIUS_API_KEY="your-token-factory-api-key"

# Option 2: Add to shell profile (permanent)
echo 'export NEBIUS_API_KEY="your-token-factory-api-key"' >> ~/.zshrc
source ~/.zshrc

# Option 3: Use a .env file (recommended for development)
# Create ~/.codex/.env
cat > ~/.codex/.env << EOF
NEBIUS_API_KEY=your-token-factory-api-key
EOF
```

### Step 5: Verify Configuration

Test your setup:

```bash
# List available profiles
codex profiles list

# Check active configuration
codex config show

# Test a simple completion
codex "Write a hello world function in Python"
```

Or if you used the setup script, the connection test was already performed during setup.

## Advanced: CLI Overrides and Dynamic Provider Switching

Codex CLI's configuration hierarchy allows you to override settings dynamically without editing `config.toml`:

### Override Provider at Runtime

```bash
# Override model provider for a single command
codex -c model_provider='"nebius_fast"' "Quick implementation"

# This takes precedence over profile settings
codex --profile nebius-precise -c model_provider='"nebius_fast"' "Use fast provider despite profile"

# Override temperature and token limits
codex -c temperature=0.3 -c max_tokens=1024 "Be precise"
```

### Configuration Precedence (highest to lowest)

1. **CLI flags** — `codex -c key=value` (overrides everything)
2. **Profile settings** — `codex --profile nebius-fast` (from config.toml)
3. **config.toml defaults** — Base configuration

This hierarchy makes it easy to switch between providers on-the-fly without permanent configuration changes.

## Advanced: Building Wrapper Libraries (Optional)

If you want to build an NPM package or wrapper (similar to the `openclaw-nebius` tokenfactory-plugin), you can create a library to:

- Auto-generate `config.toml` for users
- Provide TypeScript types for the Token Factory API
- Handle authentication and credential management
- Offer a CLI setup wizard

Example wrapper structure:

```typescript
// token-factory-provider.ts
import axios from 'axios';

interface TokenFactoryConfig {
  apiKey: string;
  endpoint: string;
  modelName: string;
}

export class TokenFactoryProvider {
  private config: TokenFactoryConfig;
  private client: axios.AxiosInstance;

  constructor(config: TokenFactoryConfig) {
    this.config = config;
    this.client = axios.create({
      baseURL: config.endpoint,
      headers: {
        'Authorization': `Bearer ${config.apiKey}`,
        'Content-Type': 'application/json',
      },
      timeout: 30000,
    });
  }

  async chat(messages: Array<{role: string; content: string}>) {
    const response = await this.client.post('/chat/completions', {
      model: this.config.modelName,
      messages,
    });
    return response.data.choices[0].message.content;
  }
}
```

This wrapper is **optional** — basic configuration works without it. Wrappers become useful when scaling to production or integrating with other systems.

## Usage Examples

### Basic Code Completion

```bash
# Using default profile (nebius-token-factory)
codex "Write a Python function to validate email addresses"

# Using specific profile
codex --profile nebius-fast "Quick function to parse JSON"

# With custom parameters
codex --max-tokens 8192 --temperature 0.5 "Explain this code snippet"
```

### Interactive Session

```bash
# Start interactive REPL
codex --interactive

# Then type prompts and receive responses in real-time
```

### With Code Context

```bash
# Analyze existing file
codex --file src/main.py "What does this function do?"

# Get code suggestions for directory
codex --directory src/ "Generate unit tests for these files"
```

### Profile Switching

```bash
# Quick switch between profiles using aliases
alias codex-fast="codex --profile nebius-fast"
alias codex-precise="codex --profile nebius-precise"

codex-fast "Quick implementation"
codex-precise "Complex algorithm explanation"
```

## Troubleshooting

### API Connection Issues

```bash
# Test endpoint connectivity
curl -H "Authorization: Bearer $NEBIUS_API_KEY" \
  https://api.nebius.ai/v1/models

# Check if API key is set
echo $NEBIUS_API_KEY

# Verify endpoint in config
codex config show | grep api_endpoint
```

### Configuration Problems

```bash
# Reset to defaults
rm ~/.codex/config.toml
codex init  # If available

# Validate TOML syntax
codex config validate

# Check for parse errors
cat ~/.codex/config.toml | python3 -m json.tool
```

### Model Performance

- **Slow Responses**: Reduce `max_tokens` or use a smaller model
- **High Errors**: Lower `temperature` for more consistent outputs
- **Token Limits**: Check Token Factory rate limits and quota

## Performance Optimization

### Token Factory Configuration

```toml
# For fast responses
[profiles.nebius-fast]
temperature = 0.3          # More deterministic
top_p = 0.9
top_k = 50
max_tokens = 1024          # Shorter responses

# For quality
[profiles.nebius-quality]
temperature = 0.5
top_p = 0.95
max_tokens = 4096
```

### Caching Strategies

```bash
# Cache common prompts to reduce API calls
codex --cache --ttl 3600 "function to sort array"
```

## Integration with Development Workflow

### Git Integration

```bash
# Add commit message generation
alias git-commit-msg="codex --profile nebius-fast"

# Suggest improvements to staged changes
git diff --staged | codex "Suggest code improvements"
```

### Editor Integration

### VSCode Integration

Create `.vscode/settings.json`:

```json
{
  "codex.profile": "nebius-token-factory",
  "codex.enabled": true,
  "codex.modelName": "nebius/llama2-70b"
}
```

Install the Codex VSCode extension, then use:
- `Cmd+K` (Mac) / `Ctrl+K` (Windows/Linux) for code suggestions

## Security Best Practices

1. **Never commit API keys** to version control
2. **Use environment variables** for sensitive data
3. **Rotate API keys regularly** through Token Factory console
4. **Audit API usage** through Nebius dashboard
5. **Set rate limits** in Token Factory configuration
6. **Use different profiles** for sensitive vs. non-sensitive code

```bash
# .gitignore
.env
.codex/.env
~/.codex/.env
NEBIUS_API_KEY
```

## Available Token Factory Models

Token Factory provides 40+ models. Here are some recommended for coding:

| Model | Best For | Speed |
|-------|----------|-------|
| **Hermes-4-405B** | Balanced, all-purpose (default) | Medium |
| **Gemma-3-27b** | Quick suggestions | Fast |
| **Qwen3-Coder-480B** | Complex code generation | Slow |
| **Kimi-K2.5** | Large context tasks | Medium |
| **DeepSeek-V3.2** | Reasoning and analysis | Medium |

See [Nebius Token Factory docs](https://nebius.ai/token-factory) for the complete model catalog.

## Advanced: Multiple Provider Setup

```toml
# Mix Token Factory with other backends
default_profile = "nebius-token-factory"

[profiles.nebius-token-factory]
provider = "custom"
model_name = "nebius/llama2-70b"
api_endpoint = "https://api.nebius.ai/v1/completions"
api_key_env = "NEBIUS_API_KEY"

# Fallback to local Ollama if Token Factory is unavailable
[profiles.local-ollama]
provider = "ollama"
model_name = "mistral"
api_endpoint = "http://localhost:11434"

# Switch between profiles based on availability
# codex --profile local-ollama "fallback request"
```

## About the Setup Script

The [`setup-codex-nebius.sh`](setup-codex-nebius.sh) script automates the entire configuration process:

**What it does:**
- Checks Codex CLI installation
- Creates `~/.codex` directory
- Prompts for your Nebius API key securely
- Adds API key to your shell profile (~/.bashrc or ~/.zshrc)
- Generates a pre-configured `config.toml` with three profiles
- Optionally tests the connection to Nebius Token Factory

**Supported shells:** bash, zsh (auto-detected)

**Run it anytime:** If you need to reconfigure or update your setup, just run the script again.

## Next Steps

1. **Run the setup script** (recommended) or **manually configure** following the steps above
2. **Test basic completions** to verify setup
3. **Create additional profiles** for different use cases if needed
4. **Integrate with your editor** (VSCode, Neovim, etc.)
5. **Configure git hooks** for automated suggestions
6. **Monitor API usage** through Token Factory dashboard

## References & Resources

### Codex CLI Documentation
- [Codex CLI: Running GPT OSS and Local Coding Models](https://dev.to/shashikant86/codex-cli-running-gpt-oss-and-local-coding-models-with-ollama-lm-studio-and-mlx-403g) — Original Dev.to article introducing Codex CLI architecture
- [Codex Provider Configuration Guide](https://www.morphllm.com/codex-provider-configuration) — Detailed provider setup patterns and configuration hierarchy
- [Codex CLI Technical Reference](https://blakecrosley.com/guides/codex) — Comprehensive technical guide for Codex CLI

### Custom Provider Examples
- [Custom Provider Configuration Example](https://gist.github.com/dingp/fab7365c84f5a008537bf645f9bd57d3) — Working example of custom provider setup
- [OpenCode Codex Provider Plugin](https://github.com/withakay/opencode-codex-provider) — Community example of a custom provider plugin

### Nebius Integration
- [Nebius Token Factory Documentation](https://nebius.ai/token-factory) — Official Token Factory service documentation
- [OpenClaw Nebius Plugin](https://github.com/opencolin/openclaw-nebius/tree/main/tokenfactory-plugin) — Reference implementation for Token Factory integration with OpenClaw
- [Nebius CLI Documentation](https://docs.nebius.com/cli/) — Official Nebius CLI reference

### Related Projects & SDKs
- [Nebius API Definitions](https://github.com/nebius/api) — gRPC API proto definitions and SDKs (Go, Python, etc.)
- [OpenClaw: Personal AI Assistant](https://github.com/opencolin/openclaw) — OpenClaw framework that integrates with Codex CLI and Nebius
- [OpenClaw Deploy](https://github.com/colygon/openclaw-deploy) — Deployment toolkit for running OpenClaw on Nebius

---

**Disclaimer:** This guide combines official documentation with community patterns and examples. Always verify with [official Codex CLI](https://github.com/shashikant86/codex-cli) and [Nebius](https://docs.nebius.com/) documentation for the latest updates.
