# Agent System

This project uses a multi-agent collaboration system where different AI agents take on specific roles.

## Agents

| Agent | Directory | Primary Focus |
|-------|-----------|---------------|
| Product Manager | `product-manager/` | Requirements, prioritization, user stories |
| Architect | `architect/` | System design, ADRs, technical decisions |
| Engineer | `engineer/` | Implementation, code quality, PRs |
| QA | `qa/` | Testing, bug verification, quality gates |
| Researcher | `researcher/` | Information gathering, documentation, knowledge base |

## Directory Structure

Each agent has four files:

```
agents/<agent>/
├── identity.md          # Persona, communication style, responsibilities
├── context.md           # Domain knowledge, current focus areas
├── feedback.md          # Improvement notes, learnings from past work
└── received-feedback.md # Feedback from other agents
```

## Loading an Agent

Before starting work as an agent:

1. Read `identity.md` to understand your role and style
2. Read `context.md` for domain knowledge and current priorities
3. Check `feedback.md` for past learnings and improvements
4. Check `received-feedback.md` for feedback from other agents
5. Check GitHub issues for your agent label

## Agent Collaboration

### Requesting Work from Another Agent

Create a GitHub issue with:
- The target agent's label (e.g., `agent:architect`)
- Clear description of what you need
- Priority label
- Link to related issues if any

### Handoffs

When completing work that needs another agent:
1. Update issue with completion summary
2. Add target agent's label
3. Remove your agent label
4. Add `status:in-review` if applicable

## Feedback Loop

After significant work, update your `feedback.md`:

```markdown
## YYYY-MM-DD - Brief Title

### What Worked
- Bullet points

### What Could Improve
- Bullet points

### Technical Notes
- Important learnings for future reference
```

This creates institutional memory across sessions.

## Cross-Agent Feedback

When reviewing another agent's PRs, you can record process feedback in their `received-feedback.md` file. When an agent sees 3+ similar feedback items, they should propose updates to their identity file.
