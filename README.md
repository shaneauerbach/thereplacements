# The Replacements

A framework for autonomous multi-agent collaboration using Claude Code.

## What Is This?

This repository provides scaffolding for running multiple Claude Code agents that collaborate on software development. Each agent has:

- **A role** (Engineer, QA, Product Manager, Architect)
- **An identity** (personality, responsibilities, constraints)
- **A work loop** (daemon-style continuous execution)
- **Communication** via GitHub Issues and PRs (no Slack needed)

The agents work autonomously, review each other's code, and escalate to a human team lead only when necessary.

## Quick Start

### 1. Clone and Customize

```bash
git clone https://github.com/yourusername/thereplacements myproject
cd myproject
```

Then open Claude Code and tell it what you want to build:

```
claude "I want to use this multi-agent framework to build [your project].
Help me customize the agent context files and set everything up."
```

Claude will help you:
- Update `agents/*/context.md` with your project-specific knowledge
- Adjust `CLAUDE.md` for your risk philosophy
- Configure repo references and labels

### 2. Set Up Git Worktrees

Each agent needs its own working directory to avoid git conflicts. Ask Claude Code to help:

```
claude "Help me set up git worktrees for the agents in this project"
```

This will create separate workspaces like:
```
~/github/
├── myproject/              # Main repo (human workspace)
├── myproject-engineer/     # Engineer agent workspace
├── myproject-qa/           # QA agent workspace
└── ...
```

See [DESIGN.md](./DESIGN.md) for details on why worktrees are needed.

### 3. Create GitHub Labels

The agents use labels to coordinate work. Ask Claude Code to create them:

```
claude "Create the GitHub labels needed for this multi-agent framework"
```

See [docs/workflow-reference.md](./docs/workflow-reference.md) for the full label reference.

### 4. Launch Agents

Use VS Code/Cursor tasks (Cmd+Shift+P → "Run Task") to launch agents, or ask Claude Code:

```
claude "Help me launch the Engineer and QA agents"
```

### 5. Monitor as Human Team Lead

Check what needs your attention periodically, or use the `/human` skill:

```
claude "/human"
```

This walks you through any pending decisions or PRs needing approval.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Issues & PRs                      │
│  (Source of truth for all work, communication, and reviews) │
└─────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
    ┌─────────┐          ┌─────────┐          ┌─────────┐
    │Architect│◄────────►│Engineer │◄────────►│   QA    │
    │         │  reviews │         │  reviews │         │
    └─────────┘          └─────────┘          └─────────┘
         │                    │                    │
         └────────────────────┼────────────────────┘
                              ▼
                    ┌──────────────────┐
                    │   Shared Repo    │
                    │  (main branch)   │
                    └──────────────────┘
```

## Key Design Patterns

### 1. Daemon Model
Agents are designed to run continuously - when idle, they snooze for 5 minutes, pull, and check for work again. The goal is maximum autonomy with minimum human babysitting.

**Reality check:** Agents are like us. Eventually they forget their instructions, get confused, or declare "my work is complete" when it isn't. The snooze loop and forbidden phrases in CLAUDE.md are designed to minimize this, but it still happens. When it does, just restart them. The framework is designed to be resilient - agents save state via git, and work coordination happens through GitHub labels, so restarting is cheap.

### 2. Label-Based Coordination
No chat/Slack needed. Agents find work via `agent:*` labels and request reviews via `needs-review:*` labels.

### 3. Git Worktrees
Each agent runs in its own worktree, preventing git conflicts when multiple agents work simultaneously.

### 4. Human Escalation
Sensitive changes (auth, config) require `needs-human-merge`. Decisions requiring human judgment get `needs-human` labels.

### 5. Cross-Agent Feedback
Agents can give each other feedback, recorded in `received-feedback.md`. When patterns emerge, agents propose updates to their own identity files.

## File Structure

```
├── CLAUDE.md                    # Master instructions for all agents
├── HUMAN.md                     # Guide for human team lead
├── DESIGN.md                    # Explanation of key patterns
├── agents/
│   ├── README.md                # Agent system overview
│   ├── engineer/
│   │   ├── identity.md          # Role, responsibilities, workflow
│   │   ├── context.md           # Project-specific knowledge
│   │   ├── feedback.md          # Self-improvement notes
│   │   └── received-feedback.md # Feedback from other agents
│   ├── qa/
│   ├── product-manager/
│   └── architect/
├── .vscode/tasks.json           # VS Code tasks to launch agents
├── .claude/
│   └── skills/
│       ├── human/               # Help human process agent asks
│       └── kill/                # Graceful agent shutdown
├── .github/
│   ├── workflows/ci.yml         # CI pipeline
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE/
├── asks/human.md                # Dashboard for human team lead
└── docs/workflow-reference.md   # Detailed label/command reference
```

## Customizing for Your Project

The easiest way to customize is to ask Claude Code:

```
claude "Help me add a new Security agent to this framework"
claude "Update the engineer context for a React/Node.js project"
claude "I don't need the Architect agent, help me remove it"
```

Claude will update the relevant files, labels, and VS Code tasks for you.

### What Can Be Customized

- **Agent roles** - Add, remove, or modify agents
- **Context files** - Project-specific knowledge per agent
- **Label system** - Different labels or workflows
- **CI pipeline** - Your tech stack's test/lint commands
- **Risk philosophy** - What requires human approval

## For More Information

- [CLAUDE.md](./CLAUDE.md) - How agents work
- [HUMAN.md](./HUMAN.md) - How to supervise agents
- [DESIGN.md](./DESIGN.md) - Why it's designed this way
- [docs/workflow-reference.md](./docs/workflow-reference.md) - All commands and labels

## License

MIT - Use however you want.
