---
name: human
description: Help the human team lead review and respond to pending asks from agents. Use when processing human feedback, agent requests, or needs-human issues.
---

# Human Feedback Assistant

Help the human team lead review and respond to pending asks from agents.

## Instructions

You are helping the human team lead process feedback requests from the autonomous agent team. Walk through each pending ask one at a time.

### Step 1: Gather Pending Asks

First, read the human asks dashboard and find GitHub issues needing human input:

```bash
cat asks/human.md
gh issue list --label "needs-human" --state open
```

Also check for PRs awaiting human merge approval:

```bash
gh pr list --label "needs-human-merge" --state open
```

### Step 2: Walk Through Each Ask

For each pending item:

1. **Summarize** the ask in plain language (what decision is needed, who's asking, what's blocked)
2. **Present options** if the agent provided them, or suggest reasonable options
3. **Ask the human** for their decision
4. **Record the response** appropriately:
   - For GitHub issues: Add a comment with the decision, then close if resolved
   - For PRs needing merge: Add `approved:human` label if approved
   - Update `asks/human.md` to move resolved items to the Resolved section

### Step 3: Commit Updates

After processing asks, commit any changes to `asks/human.md`:

```bash
git add asks/human.md
git commit -m "Human: Process feedback asks"
git push origin main
```

### Response Format

When presenting each ask, use this format:

```
## Ask #[number]: [Brief Title]

**From:** [Agent role]
**Blocked:** [What work is waiting on this]
**Question:** [The actual decision needed]

**Options:**
1. [Option A]
2. [Option B]
...

What's your decision?
```

### Important

- Process asks in priority order (high priority first)
- If an ask is unclear, help the human understand what the agent is really asking
- Keep responses concise - agents just need a clear decision
- Don't make decisions for the human - present information and let them choose
