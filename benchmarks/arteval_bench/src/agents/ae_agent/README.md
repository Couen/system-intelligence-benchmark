# AE Agent (ArtEval sub-agent)

This agent is the **ae-agent** logic integrated as a sub-agent of the system-intelligence-benchmark ArtEval benchmark. It uses the Claude Agent SDK to run artifact evaluation tasks inside the benchmark container.

## Contract

- **install.sh**: Installs `claude-agent-sdk` and configures `~/.claude/settings.json` (48h Bash timeout).
- **runner.sh**: Entry point invoked as `runner.sh <model> <task_or_path>`. Forwards to `runner.py`.
- **runner.py**: Runs the task with Claude Agent SDK; second argument can be task text or a path to a file (to avoid shell quoting issues with long tasks).

## Usage from the benchmark

Point the benchmark at this agent directory (e.g. `.../agents/ae_agent`). The benchmark will:

1. Upload the agent to `/agent` in the container.
2. Run `install.sh` then `runner.sh "$model" "$task"`.
3. Use the same long-running and live-log behavior as `claude_sdk` (48h timeout, live log streaming, `_agent_eval` removal before run and upload before evaluation, container kept for debugging).

## Dependencies

- Python 3 with `claude-agent-sdk` (installed by `install.sh`).
- Optional: `message_formatter` for prettier output (if present in the environment).

## Relation to standalone ae-agent repo

The standalone [ae-agent](https://github.com/Couen/ae-agent) repo provides a full CLI and host/Docker orchestration. This sub-agent is only the in-container runner used when the benchmark calls an agent; the benchmark’s `run_eval_in_env.py` handles orchestration, so no copy of `main.py`, `run_eval.py`, or `utils.py` is needed here.
