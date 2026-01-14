# The Replacements

A framework for autonomous multi-agent collaboration using Claude Code.

> *"It's a joke about how these agentic teams will replace us in tech."*

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

Edit these files for your project:
- `agents/*/context.md` - Add your project-specific knowledge
- `CLAUDE.md` - Adjust risk philosophy if needed
- Update repo references from `OWNER/REPO` to your actual repo

### 2. Set Up Git Worktrees

Each agent needs its own working directory to avoid git conflicts. Git worktrees let multiple agents work in parallel, each on their own branch, while sharing the same repository history.

#### Why Worktrees?

Without worktrees, if Engineer runs `git checkout feature-a` and QA runs `git checkout feature-b`, they'd constantly conflict. Worktrees give each agent an isolated workspace.

#### Create Worktrees

```bash
# From your main project directory
cd ~/github/myproject

# Create a worktree for each agent you want to run
git worktree add ../myproject-engineer main
git worktree add ../myproject-qa main
git worktree add ../myproject-pm main
git worktree add ../myproject-architect main
```

This creates:
```
~/github/
├── myproject/              # Main repo (human workspace)
├── myproject-engineer/     # Engineer agent workspace
├── myproject-qa/           # QA agent workspace
├── myproject-pm/           # Product Manager workspace
└── myproject-architect/    # Architect workspace
```

#### Worktree Management

```bash
# List all worktrees
git worktree list

# Remove a worktree (if you want fewer agents)
git worktree remove ../myproject-architect

# Add a worktree later
git worktree add ../myproject-architect main
```

#### Update VS Code Tasks

After creating worktrees, update `.vscode/tasks.json` to match your paths:

```json
{
  "command": "cd ~/github/myproject-engineer && ..."
}
```

Replace `yourproject` with your actual project name (e.g., `myproject`).

### 3. Create GitHub Labels

The agents use labels to coordinate work. Create these in your repo:

```bash
# Agent assignment labels
gh label create "agent:engineer" --color "1d76db"
gh label create "agent:qa" --color "0e8a16"
gh label create "agent:pm" --color "d93f0b"
gh label create "agent:architect" --color "5319e7"

# Review request labels
gh label create "needs-review:engineer" --color "fbca04"
gh label create "needs-review:qa" --color "fbca04"
gh label create "needs-review:pm" --color "fbca04"
gh label create "needs-review:architect" --color "fbca04"

# Approval labels
gh label create "approved:engineer" --color "0e8a16"
gh label create "approved:qa" --color "0e8a16"
gh label create "approved:pm" --color "0e8a16"
gh label create "approved:architect" --color "0e8a16"
gh label create "approved:human" --color "0e8a16"

# Status labels
gh label create "status:needs-changes" --color "d93f0b"
gh label create "status:blocked" --color "b60205"
gh label create "needs-human" --color "c2e0c6"
gh label create "needs-human-merge" --color "c2e0c6"

# Priority labels
gh label create "priority:high" --color "b60205"
gh label create "priority:medium" --color "fbca04"
gh label create "priority:low" --color "0e8a16"
```

### 4. Launch Agents

Use VS Code/Cursor tasks (Cmd+Shift+P → "Run Task"):
- **Launch Engineer Agent**
- **Launch QA Agent**
- **Launch All Agents**

Or manually:
```bash
cd ~/github/myproject-engineer
claude "You are the Engineer agent. Read agents/engineer/identity.md, context.md, feedback.md then start the work loop from CLAUDE.md."
```

### 5. Monitor as Human Team Lead

```bash
# Check what needs your attention
gh pr list --label "needs-human-merge"
gh issue list --label "needs-human"

# Or use the /human skill
claude "/human"
```

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
Agents never stop. When idle, they snooze for 5 minutes, pull, and check for work again. This creates a truly autonomous system.

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

### Adding Project Context

Edit `agents/*/context.md` to add your specific:
- Tech stack and patterns
- Domain knowledge
- Current priorities
- Important files and locations

### Adjusting Agent Roles

You can:
- Remove agents you don't need
- Add new agents by copying an existing agent directory
- Modify responsibilities in identity files

### Changing the Label System

If you want different labels, update:
- `CLAUDE.md` (the reference section)
- `docs/workflow-reference.md`
- Each agent's identity file (the Labels section)

## For More Information

- [CLAUDE.md](./CLAUDE.md) - How agents work
- [HUMAN.md](./HUMAN.md) - How to supervise agents
- [DESIGN.md](./DESIGN.md) - Why it's designed this way
- [docs/workflow-reference.md](./docs/workflow-reference.md) - All commands and labels

## License

MIT - Use however you want.
