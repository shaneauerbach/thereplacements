# Design Principles

This document explains the key design decisions behind the multi-agent collaboration framework.

## Core Philosophy

**Autonomous but accountable.** Agents work independently but leave a clear trail via GitHub Issues and PRs. Humans can step in at any time but don't need to micromanage.

---

## 1. Daemon Model

### Why Agents Never Stop

Traditional AI assistants wait for input, do a task, and stop. This framework uses a different model: **agents are daemons**. They run continuously, checking for work, executing, and looping.

```
┌─────────────────────────────────────────┐
│              Work Loop                   │
│                                         │
│  ┌─────────┐    ┌─────────┐    ┌─────┐ │
│  │ Check   │───►│  Work   │───►│Snooze│ │
│  │for work │    │         │    │2 min │ │
│  └─────────┘    └─────────┘    └──┬──┘ │
│       ▲                           │     │
│       └───────────────────────────┘     │
└─────────────────────────────────────────┘
```

### Benefits
- **No human intervention needed** to start work
- **Self-healing** - if an agent gets stuck, the snooze loop eventually recovers
- **Parallel execution** - multiple agents work simultaneously

### The Snooze Pattern
```bash
for i in $(seq 4 -1 1); do
  echo "Snoozing... $((i * 30))s remaining"
  sleep 30
done
git pull origin main
```

This gives:
- Visual feedback that the agent is alive
- Regular git pulls to get new work
- 2 minutes between cycles (adjustable)

### The Reality: Agents Forget

Despite the daemon design, agents eventually:
- Forget they're supposed to loop forever
- Summarize their session and stop
- Declare "all work is complete" when it isn't
- Get confused after many cycles

**Why this happens:** LLMs have finite context windows. After enough work, earlier instructions (like "never stop") get pushed out or lose salience. This is similar to how humans lose focus after long work sessions.

**Mitigations built into the framework:**

1. **Forbidden phrases** - CLAUDE.md lists phrases like "session summary" that signal an agent is about to stop incorrectly. These act as guardrails.

2. **Snooze countdown** - The visible countdown (`Snoozing... 150s remaining`) keeps the loop prominent in context.

3. **Git state persistence** - All work is committed to branches, so nothing is lost when an agent stops.

4. **Label-based coordination** - Work state lives in GitHub labels, not agent memory. A restarted agent can pick up where it left off.

5. **Cheap restarts** - Because state is external, restarting an agent is trivial. Just run the launch command again.

**Practical expectation:** Plan for agents to run for hours, not days. Check on them periodically. When they stop incorrectly, restart them. This is normal.

---

## 2. Label-Based Coordination

### Why GitHub Labels Instead of Chat

Most team coordination happens via Slack, Teams, or similar chat tools. This framework uses **GitHub labels** instead:

| Traditional | This Framework |
|-------------|----------------|
| "@engineer please look at this" | Add `needs-review:engineer` label |
| "I'm done, @qa can you test?" | Add `needs-review:qa` label |
| "This PR is approved" | Add `approved:qa` label |

### Benefits
- **Searchable** - `gh pr list --label "needs-review:qa"` instantly finds all pending reviews
- **Atomic** - Labels are binary state, no ambiguity
- **Persistent** - Unlike chat, labels don't scroll away
- **Queryable** - Build dashboards, automation, metrics

### Label Categories

| Prefix | Purpose | Example |
|--------|---------|---------|
| `agent:` | Work assignment | `agent:engineer` |
| `needs-review:` | Review requests | `needs-review:qa` |
| `approved:` | Approvals | `approved:architect` |
| `status:` | Work status | `status:needs-changes` |
| `priority:` | Prioritization | `priority:high` |
| `needs-human` | Escalation | `needs-human-merge` |

---

## 3. Git Worktrees for Parallelism

### The Problem
If multiple agents share a repo, they'll conflict:
- Agent A: `git checkout feature-a`
- Agent B: `git checkout feature-b`
- Result: Agent A is now on feature-b's branch

### The Solution: Worktrees
Each agent gets its own worktree - a separate working directory that shares the same git history:

```bash
# Main repo
~/github/myproject/

# Agent worktrees
~/github/myproject-engineer/   # Engineer's workspace
~/github/myproject-qa/         # QA's workspace
~/github/myproject-pm/         # PM's workspace
```

### Benefits
- **No git conflicts** between agents
- **Shared history** - all worktrees see the same commits
- **Independent state** - each agent can be on different branches

---

## 4. Identity Files

### Why Separate Identity, Context, and Feedback

Each agent has multiple files that serve different purposes:

| File | Purpose | Changes |
|------|---------|---------|
| `identity.md` | Core role, responsibilities, workflow | Rarely |
| `context.md` | Project-specific knowledge | Per project |
| `feedback.md` | Self-improvement notes | After major work |
| `received-feedback.md` | Peer feedback | After reviews |

### Benefits
- **Reusable roles** - `identity.md` works across projects
- **Project customization** - `context.md` holds specifics
- **Learning system** - feedback files create memory

### The Self-Improvement Loop

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│  Agent does work ──► Receives feedback ──► Records  │
│                                                      │
│  After 3+ similar feedbacks:                        │
│                                                      │
│  Proposes update to identity.md ──► Human reviews   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## 5. Human Escalation

### When Agents Need Humans

Not everything should be autonomous. The framework provides clear escalation paths:

| Situation | Mechanism |
|-----------|-----------|
| Sensitive code (auth, config) | `needs-human-merge` label |
| Product/strategy decisions | `needs-human` label + issue |
| Process feedback | Update to `asks/human.md` |

### The Human Dashboard (`asks/human.md`)

Centralizes human attention:
- Quick commands to check what needs attention
- Tables for pending PRs and questions
- History of resolved items

### Benefits
- **Async** - humans don't need to be online
- **Batched** - check once a day, handle all asks
- **Tracked** - nothing falls through cracks

---

## 6. Review Flow

### Why Multiple Review Types

Different changes need different expertise:

```
┌─────────────────────────────────────────────────────────┐
│                    Review Matrix                         │
│                                                         │
│  Change Type          │ Primary Review  │ Optional      │
│  ─────────────────────│─────────────────│──────────     │
│  Implementation       │ QA              │               │
│  Architecture change  │ Architect       │ QA            │
│  New feature          │ QA + Architect  │ PM            │
│  Auth/security        │ QA              │ Human         │
│  User-facing copy     │ PM              │ Human         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### The Review Handoff

```bash
# Engineer finishes, requests review
gh pr create --title "[#42] Feature"
gh pr edit 1 --add-label "needs-review:qa"

# QA approves, removes request
gh pr review 1 --comment --body "LGTM"
gh pr edit 1 --add-label "approved:qa" --remove-label "needs-review:qa"

# Engineer can now merge (if no other reviews pending)
gh pr merge 1 --squash
```

---

## 7. VS Code Tasks

### Why VS Code Tasks for Launching

The `.vscode/tasks.json` provides one-click agent launching:

```
Cmd+Shift+P → "Run Task" → "Launch Engineer Agent"
```

### Benefits
- **Consistent startup** - same command every time
- **Parallel launch** - "Launch All Agents" starts all at once
- **IDE integration** - output in dedicated terminals

### Customization Points

```json
{
  "command": "cd ~/github/yourproject-engineer && claude ..."
}
```

Update the path (`yourproject-engineer`) for your project.

---

## 8. Skills

### What Are Skills?

Skills are reusable prompts that agents (or humans) can invoke with `/skillname`. They provide:
- Consistent execution of common tasks
- Domain knowledge injection
- Multi-step workflows

### Current Skills

| Skill | Purpose |
|-------|---------|
| `/human` | Help human process pending asks |
| `/kill` | Graceful agent shutdown |

### Creating New Skills

Add a file to `.claude/skills/<name>/skill.md` with:
- YAML frontmatter (name, description)
- Instructions for Claude to follow

---

## Extending the Framework

### Adding New Agents

1. Create directory: `agents/newrole/`
2. Add files: `identity.md`, `context.md`, `feedback.md`, `received-feedback.md`
3. Add labels: `agent:newrole`, `needs-review:newrole`, `approved:newrole`
4. Add VS Code task in `.vscode/tasks.json`
5. Update documentation

### Modifying Workflows

The framework is intentionally flexible. Modify:
- `CLAUDE.md` for global rules
- `identity.md` files for role-specific behavior
- Label names and workflows in `docs/workflow-reference.md`

### Scaling

For larger projects:
- Add more engineer instances (engineer-1, engineer-2)
- Add specialized roles (security, docs, devops)
- Create sub-teams with dedicated review flows
