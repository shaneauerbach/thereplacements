# Human Team Lead Guide

Instructions for the human overseeing the agent team.

---

## Quick Start

### First-Time Setup
```bash
# 1. Set up global permissions (one-time, applies to all worktrees)
# Copy the permissions block from .claude/settings.json to ~/.claude/settings.json

# 2. Create worktrees for parallel agents
cd ~/github/yourproject
git worktree add ../yourproject-engineer main
git worktree add ../yourproject-qa main
git worktree add ../yourproject-pm main
```

### Launch Agents
```bash
# Engineer
cd ~/github/yourproject-engineer && claude "You are the Engineer agent. Read agents/engineer/identity.md, context.md, feedback.md, received-feedback.md and follow CLAUDE.md workflow."

# QA
cd ~/github/yourproject-qa && claude "You are the QA agent. Read agents/qa/identity.md, context.md, feedback.md, received-feedback.md and follow CLAUDE.md workflow."

# PM
cd ~/github/yourproject-pm && claude "You are the Product Manager agent. Read agents/product-manager/identity.md, context.md, feedback.md, received-feedback.md and follow CLAUDE.md workflow."
```

### Daily Check-In
```bash
gh pr list --label "needs-human-merge"   # PRs needing your approval
gh issue list --label "needs-human"       # Questions needing your input
cat asks/human.md                         # Dashboard view
```

---

## Processing Agent Asks

Use `/human` command to walk through pending asks, or manually:

### Approve a PR
```bash
# Add approval label, remove review request
gh api repos/OWNER/REPO/issues/<num>/labels --method POST --input - <<< '["approved:human"]'
gh api repos/OWNER/REPO/issues/<num>/labels/needs-human-merge --method DELETE
```

### Answer a Question
```bash
# Comment on the issue with your decision
gh issue comment <num> --body "Decision: [your answer]"
gh issue close <num>  # if resolved
```

### Update Dashboard
Edit `asks/human.md` - move resolved items to the Resolved table.

---

## Worktree Management

```bash
git worktree list                         # See all worktrees
git worktree add ../yourproject-architect main    # Add more agents
git worktree remove ../yourproject-engineer       # Remove a worktree
```

Each agent needs its own worktree to avoid git conflicts.

---

## When Agents Stop Incorrectly

If an agent says "my work is complete" or gives a "session summary", they've violated the daemon rule. Just restart them - they should snooze and check for work, not stop.

---

## Useful Commands

```bash
# See all open PRs
gh pr list --state open

# See what each agent is working on
gh issue list --label "agent:engineer" --state open
gh issue list --label "agent:qa" --state open

# Check CI status on a PR
gh pr checks <num>

# View PR comments
gh pr view <num> --comments
```
