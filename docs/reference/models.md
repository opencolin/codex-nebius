# Available Models

Token Factory provides 40+ open-source language models. Here are the recommended models for different use cases.

## Quick Reference

| Model | Best For | Size | Speed |
|-------|----------|------|-------|
| **Hermes-4-405B** | Balanced, all-purpose (default) | 405B | Medium |
| **Gemma-3-27b** | Quick suggestions | 27B | Fast |
| **Qwen3-Coder-480B** | Complex coding tasks | 480B | Slow |
| **Kimi-K2.5** | Large context tasks | - | Medium |
| **DeepSeek-V3.2** | Advanced reasoning | - | Medium |

## Reasoning Models

Best for complex problem-solving and detailed analysis.

### DeepSeek-V3.2
```
Model ID: nebius/deepseek-ai/DeepSeek-V3.2
Context: 163K tokens
Best for: Advanced reasoning, complex algorithms
```

### Qwen3 Reasoning
```
Model ID: nebius/Qwen/Qwen3-235B-A22B-Thinking-2507
Context: Large
Best for: Deep analysis, research
```

## Coding-Optimized Models

Specialized for code generation and analysis.

### Qwen3 Coder
```
Model ID: nebius/Qwen/Qwen3-Coder-480B-A35B-Instruct
Context: Large
Best for: Code generation, debugging, refactoring
Speed: Slow (high quality)
```

### CodeLLaMA
```
Model ID: nebius/meta-llama/Llama-3.3-70B-Instruct
Context: 8K tokens
Best for: Code suggestions, completions
Speed: Medium
```

## General Purpose Models

### Hermes-4-405B (Default)
```
Model ID: nebius/NousResearch/Hermes-4-405B
Context: Very large
Best for: All tasks, balanced quality/speed
Speed: Medium
Recommended: Yes
```

### Llama-3.3-70B
```
Model ID: nebius/meta-llama/Llama-3.3-70B-Instruct
Context: 8K tokens
Best for: General-purpose tasks
Speed: Medium
```

## Fast Models

Optimized for speed with decent quality.

### Gemma-3-27B
```
Model ID: nebius/google/Gemma-3-27b-it
Context: 8K tokens
Best for: Quick suggestions, fast iterations
Speed: Fast
```

### Mistral-7B
```
Model ID: nebius/mistralai/Mistral-7B-Instruct-v0.3
Context: 32K tokens
Best for: Quick responses, resource-constrained
Speed: Very Fast
```

## Long Context Models

Best for analyzing large codebases or documents.

### Kimi-K2.5
```
Model ID: nebius/moonshot-ai/Kimi-K2.5
Context: 262K tokens
Best for: Large file analysis, long documentation
Speed: Medium
```

## Image Generation

Token Factory also provides image generation models.

### FLUX.1-schnell
```
Model ID: nebius/black-forest-labs/FLUX.1-schnell
Best for: Fast image generation
```

### FLUX.1-dev
```
Model ID: nebius/black-forest-labs/FLUX.1-dev
Best for: High-quality image generation
```

## Using Different Models

### In Configuration

Edit `~/.codex/config.toml`:

```toml
[profiles.my-profile]
model_provider = "nebius_token_factory"
model_name = "nebius/meta-llama/Llama-3.3-70B-Instruct"
max_tokens = 4096
temperature = 0.7
```

### At Runtime

```bash
# Override model for a single command
codex -c model_name='"nebius/deepseek-ai/DeepSeek-V3.2"' "complex task"
```

## Choosing a Model

- **Need speed?** → Gemma-3-27b or Mistral-7B
- **Need quality?** → Hermes-4-405B or Qwen3-Coder-480B
- **Need balance?** → Hermes-4-405B (default)
- **Need reasoning?** → DeepSeek-V3.2 or Qwen3-Thinking
- **Large context?** → Kimi-K2.5
- **Code generation?** → Qwen3-Coder-480B

## Model API Keys

All models use the same API endpoint and authentication:
```
Endpoint: https://api.tokenfactory.nebius.com/v1
Auth: Bearer token (NEBIUS_API_KEY environment variable)
```

## Complete Model List

For the complete list of 40+ models, visit the [Nebius Token Factory documentation](https://nebius.com/token-factory).

## Pricing

See [studio.nebius.ai](https://studio.nebius.ai) for current pricing. Most models cost $0.15–$1.00 per million input tokens.
