# Installation Guide

Complete installation instructions for Codex CLI + Nebius Token Factory.

## System Requirements

- **Node.js** 22.0 or higher
- **npm** 10.0 or higher (comes with Node.js)
- **bash** or **zsh** shell
- **curl** (usually pre-installed on macOS/Linux)

## Step 1: Check Prerequisites

### Check Node.js version

```bash
node --version  # Should be v22.0.0 or higher
npm --version   # Should be 10.0.0 or higher
```

If you need to upgrade, use [nvm](https://github.com/nvm-sh/nvm) or [fnm](https://github.com/Schniz/fnm):

```bash
nvm install 22
# or
fnm install 22
```

### Check your shell

```bash
echo $SHELL  # Should end with /zsh or /bash
```

## Step 2: Install Codex CLI

### Via npm (Recommended)

```bash
npm install -g @openai/codex
```

Verify:
```bash
codex --version
# Should output: OpenAI Codex (vX.XXX.X)
```

### Via Homebrew (macOS)

```bash
brew install --cask codex
```

### Manual Binary Installation

Download from [GitHub Releases](https://github.com/openai/codex/releases) and add to PATH.

## Step 3: Get Nebius Token Factory API Key

1. Go to [studio.nebius.ai](https://studio.nebius.ai)
2. Sign up or log in
3. Create an API key (it will start with `v1.`)
4. Copy and save it — you'll need it in the next step

## Step 4: Clone and Run Setup

```bash
# Clone the repository
git clone https://github.com/opencolin/codex-nebius.git
cd codex-nebius

# Run the setup script
bash setup-codex-nebius.sh
```

The script will:
1. Verify Codex CLI is installed
2. Create `~/.codex` directory
3. Prompt for your API key
4. Generate `config.toml`
5. Test the connection

### What the script creates

- `~/.codex/config.toml` — Codex configuration with three profiles
- `~/.bashrc` or `~/.zshrc` — Environment variable for your API key

## Step 5: Reload Shell Configuration

```bash
# For zsh (default on macOS)
source ~/.zshrc

# For bash
source ~/.bashrc
```

Or simply **restart your terminal**.

## Step 6: Verify Installation

```bash
codex "test"
```

If successful, you'll get a response from Hermes model.

## Troubleshooting Installation

### "npm: command not found"

Node.js is not installed or not in your PATH:

```bash
# Install Node.js
curl -fsSL https://fnm.io/install | bash
fnm install 22
fnm use 22
```

Then try `npm install -g @openai/codex` again.

### "codex: command not found"

Codex wasn't installed globally or npm's global bin is not in PATH:

```bash
# Reinstall globally
npm install -g @openai/codex

# Check where npm puts global packages
npm config get prefix

# Make sure that directory is in your PATH
echo $PATH | grep -q "$(npm config get prefix)" && echo "OK" || echo "NOT IN PATH"
```

### Setup script fails

Make sure you're in the cloned directory:

```bash
cd codex-nebius
bash setup-codex-nebius.sh
```

If you get permission errors, make the script executable:

```bash
chmod +x setup-codex-nebius.sh
bash setup-codex-nebius.sh
```

## Next Steps

- Complete the [Quick Start](./quick-start) guide
- Read about available [Token Factory Models](./reference/models)
- Set up [Editor Integration](./usage/editor-integration)

## Getting Help

- Check [Troubleshooting](./troubleshooting/common-issues)
- Open an [issue on GitHub](https://github.com/opencolin/codex-nebius/issues)
