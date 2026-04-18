# Quick Start

Get Codex CLI working with Nebius Token Factory in 5 minutes.

## Prerequisites

- **Node.js 22+** (check with `node --version`)
- **Nebius Token Factory API key** from [studio.nebius.ai](https://studio.nebius.ai)
- **bash or zsh** shell

## Installation

### 1. Install Codex CLI

```bash
npm install -g @openai/codex
```

Verify installation:
```bash
codex --version
```

### 2. Clone the setup script

```bash
git clone https://github.com/opencolin/codex-nebius.git
cd codex-nebius
```

### 3. Run the setup script

```bash
bash setup-codex-nebius.sh
```

The script will:
- ✓ Verify Codex CLI is installed
- ✓ Create `~/.codex` configuration directory
- ✓ Prompt for your Nebius Token Factory API key
- ✓ Generate `config.toml` with three profiles
- ✓ Test the connection (optional)

### 4. Reload your shell

```bash
source ~/.zshrc   # if using zsh
# or
source ~/.bashrc  # if using bash
```

## Start Using Codex

### Default Profile (Balanced)

```bash
codex "Write a Python function to validate email addresses"
```

### Fast Profile (Quick responses)

```bash
codex --profile nebius-fast "Quick implementation"
```

### Precise Profile (Detailed analysis)

```bash
codex --profile nebius-precise "Explain this codebase"
```

## Common Commands

**Get code suggestions:**
```bash
codex "Implement a binary search algorithm"
```

**Analyze existing code:**
```bash
codex --file src/main.py "What does this function do?"
```

**Interactive mode:**
```bash
codex --interactive
```

**Override model settings:**
```bash
codex -c temperature=0.3 "Be very precise"
codex -c max_tokens=500 "Keep it short"
```

## What's Next?

- Learn about [all available models](./reference/models)
- Configure [editor integration](./usage/editor-integration)
- Set up [git integration](./usage/git-integration)
- Explore [advanced profiles](./usage/profiles)

## Troubleshooting

**"Codex CLI not found"** — Run `npm install -g @openai/codex` and restart your shell.

**"Missing NEBIUS_API_KEY"** — Run `source ~/.zshrc` to load your API key, or run the setup script again.

**Connection errors** — See [Authentication Troubleshooting](./troubleshooting/authentication).

For more help, check [Common Issues](./troubleshooting/common-issues).
