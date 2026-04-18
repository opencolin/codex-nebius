# Common Issues & Solutions

## Codex CLI Issues

### "codex: command not found"

Codex CLI is not installed or not in your PATH.

**Solution:**
```bash
npm install -g @openai/codex
node --version  # Verify Node.js 22+
```

If still not found after installing, restart your terminal or run:
```bash
export PATH="$(npm config get prefix)/bin:$PATH"
```

### "NEBIUS_API_KEY is not set"

The environment variable for your API key is not loaded.

**Solution:**
1. Make sure the setup script completed successfully
2. Reload your shell configuration:
   ```bash
   source ~/.zshrc   # or ~/.bashrc
   ```
3. Verify the key is set:
   ```bash
   echo $NEBIUS_API_KEY
   ```

If empty, run the setup script again:
```bash
bash setup-codex-nebius.sh
```

### "Configuration not found"

Codex can't find your `config.toml` file.

**Solution:**
Make sure the file exists:
```bash
ls ~/.codex/config.toml
```

If missing, run the setup script:
```bash
bash setup-codex-nebius.sh
```

## Connection Issues

### "Connection refused"

Can't connect to Token Factory API.

**Solution:**
1. Check your internet connection
2. Verify the API is reachable:
   ```bash
   curl -I https://api.tokenfactory.nebius.com/v1/models
   ```
3. Check your API key format (should start with `v1.`)

### "Unexpected status 422"

Token Factory is rejecting the request.

**Solution:**
This is a known issue with Codex's tool serialization. Try:
1. Use a different Codex profile
2. Simplify your prompt
3. Check your model name is correct
4. See [Authentication Troubleshooting](./authentication.md)

### "timeout: request timed out"

The request took too long.

**Solution:**
1. Reduce `max_tokens` in your profile
2. Try a faster model (Gemma-3-27b or Mistral-7B)
3. Check your internet connection

## Model Issues

### "Unknown model"

The model name is invalid or not available.

**Solution:**
1. Check the [Models reference](../reference/models.md)
2. Make sure you're using the full model ID with `nebius/` prefix
3. Verify the model exists in Token Factory

Example:
```bash
# Wrong
nebius/Hermes

# Correct
nebius/NousResearch/Hermes-4-405B
```

### "Rate limit exceeded"

Too many requests to Token Factory.

**Solution:**
1. Wait a few moments before retrying
2. Reduce request frequency
3. Check your Token Factory quota at [studio.nebius.ai](https://studio.nebius.ai)

## Configuration Issues

### "Invalid TOML syntax"

Your `config.toml` has a syntax error.

**Solution:**
1. Check for typos or missing quotes
2. Regenerate the file:
   ```bash
   rm ~/.codex/config.toml
   bash setup-codex-nebius.sh
   ```

### "Profile not found"

The profile you specified doesn't exist.

**Solution:**
1. List available profiles:
   ```bash
   codex profiles list
   ```
2. Use the correct profile name:
   ```bash
   codex --profile nebius-fast "test"
   ```

## Performance Issues

### "Codex is slow"

Responses are taking a long time.

**Solutions:**
- Use a faster model:
  ```bash
  codex --profile nebius-fast "quick task"
  ```
- Reduce `max_tokens` (smaller responses = faster)
- Try a simpler prompt
- Check your internet connection

### "High token usage"

Using more tokens than expected.

**Solutions:**
- Shorten your prompts
- Reduce `max_tokens` in profiles
- Use a faster model (uses fewer tokens)
- Review your Token Factory quota

## Other Issues

### "Permission denied"

Can't write to `~/.codex/` directory.

**Solution:**
Check directory permissions:
```bash
ls -la ~/.codex/
chmod 755 ~/.codex/
```

### "Module not found"

Missing JavaScript dependency.

**Solution:**
```bash
npm install -g @openai/codex --force
```

## Still Having Issues?

1. Check [Authentication Troubleshooting](./authentication.md)
2. Check [Connection Troubleshooting](./connection-errors.md)
3. Open an [issue on GitHub](https://github.com/opencolin/codex-nebius/issues)
4. Include:
   - Your Codex CLI version: `codex --version`
   - Your Node.js version: `node --version`
   - The exact error message
   - Steps to reproduce

## Getting Help

- **GitHub Issues:** [opencolin/codex-nebius/issues](https://github.com/opencolin/codex-nebius/issues)
- **Codex Documentation:** [github.com/openai/codex](https://github.com/openai/codex)
- **Token Factory Support:** [nebius.com](https://nebius.com)
