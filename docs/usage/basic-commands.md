# Basic Commands

Learn the fundamental Codex CLI commands for everyday use.

## Basic Syntax

```bash
codex [options] "<prompt>"
```

## Essential Commands

### Simple Prompt

Ask Codex to generate code:

```bash
codex "Write a Python function to calculate factorial"
```

### With Profile

Use a specific profile:

```bash
codex --profile nebius-fast "Quick implementation"
codex --profile nebius-precise "Detailed explanation"
```

### Analyze a File

Get insights about existing code:

```bash
codex --file src/main.py "What does this do?"
codex --file src/app.ts "Find bugs in this file"
```

### Interactive Mode

Have a conversation with Codex:

```bash
codex --interactive
```

Type prompts and get responses back-and-forth.

## Common Options

| Option | Description |
|--------|-------------|
| `-c, --config` | Specify config file path |
| `--profile` | Use a specific profile |
| `--file` | Provide a file for context |
| `--directory` | Provide a directory for context |
| `--interactive` | Interactive mode |
| `--temperature` | Set creativity (0-1) |
| `--max-tokens` | Maximum response length |
| `--model` | Override model |

## Temperature & Tokens

### Temperature (Creativity)

Lower = more deterministic, higher = more creative

```bash
# Very deterministic (0.1)
codex -c temperature=0.1 "Implement bubble sort"

# Balanced (0.7)
codex "Generate sample data"

# Very creative (0.95)
codex -c temperature=0.95 "Write creative code example"
```

### Max Tokens (Response Length)

Control how long the response can be:

```bash
# Short response
codex -c max_tokens=100 "One-liner solution"

# Medium response
codex -c max_tokens=1024 "Detailed explanation"

# Long response  
codex -c max_tokens=4096 "Complete implementation"
```

## Real-World Examples

### Generate Code

```bash
codex "Write a REST API endpoint in FastAPI that returns user data"
codex "Create a React component for a todo list with add/delete"
codex "SQL query to find top 10 customers by revenue"
```

### Explain Code

```bash
codex --file app.py "Explain this Python file in detail"
codex "How does OAuth2 work?"
codex "What's the difference between async/await and callbacks?"
```

### Fix Issues

```bash
codex "Fix this TypeError in my code"
codex --file buggy.py "This crashes with IndexError, help!"
codex "Optimize this slow SQL query"
```

### Documentation

```bash
codex "Write docstrings for this function"
codex "Generate a README for my project"
codex "Create test cases for this function"
```

## Profile Usage

### Default Profile (Balanced)

```bash
codex "General coding task"
```

### Fast Profile

```bash
codex --profile nebius-fast "Quick implementation"
```

Use when you want speed over quality.

### Precise Profile

```bash
codex --profile nebius-precise "Complex algorithm"
```

Use when you want high-quality, detailed responses.

## Tips & Tricks

### Chain Commands

```bash
# Generate code then ask questions about it
codex "Write a recursive Fibonacci function"
codex "Add error handling to the Fibonacci function"
codex "Optimize the Fibonacci function for performance"
```

### Use Context

```bash
# Provide file context
codex --file myfile.py "How can I improve this?"

# Provide directory context
codex --directory src/ "Summarize this codebase"
```

### Adjust Temperature

```bash
# For precise tasks
codex -c temperature=0.3 "Generate SQL query"

# For creative tasks
codex -c temperature=0.8 "Generate test data"
```

## Next Steps

- Learn about [Profiles](./profiles.md)
- Set up [Editor Integration](./editor-integration.md)
- Configure [Git Integration](./git-integration.md)
- See all [Available Models](../reference/models.md)

## Need Help?

- Check [Common Issues](../troubleshooting/common-issues.md)
- See [API Reference](../reference/api-endpoints.md)
