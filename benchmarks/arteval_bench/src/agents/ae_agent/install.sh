#!/bin/bash
# Install AE Agent dependencies inside the benchmark container.
# Ensures claude-agent-sdk is available so runner.py can run.
set -e

if ! python3 -c "import claude_agent_sdk" 2>/dev/null; then
    echo "Installing claude-agent-sdk..."
    pip3 install claude-agent-sdk --break-system-packages 2>/dev/null || \
    pip3 install claude-agent-sdk 2>/dev/null || true
    if ! python3 -c "import claude_agent_sdk"; then
        echo "WARNING: claude_agent_sdk still not importable; runner may fail."
    fi
fi

# Create ~/.claude/settings.json for 48h Bash timeout (same as other long-running agents)
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "BASH_MAX_TIMEOUT_MS": "172800000",
    "BASH_DEFAULT_TIMEOUT_MS": "172800000"
  }
}
EOF
echo "AE Agent environment ready (~/.claude/settings.json configured)."
