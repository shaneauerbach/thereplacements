# Human Team Lead Dashboard

Your async command center for the agent team.

## Quick Check Commands

Run these to see what needs your attention:

```bash
# PRs waiting for your merge approval
gh pr list --label "needs-human-merge"

# Open questions/decisions needing your input
gh issue list --label "needs-human"

# All open PRs (for awareness)
gh pr list --state open
```

Or scan the tables below for a quick overview.

---

## PRs Needing Human Merge Approval

| PR | Date | Agent | Summary | Risk |
|----|------|-------|---------|------|

*No PRs awaiting approval*

---

## Open Asks

| # | Date | Agent | Summary | Issue | Priority |
|---|------|-------|---------|-------|----------|

*No open asks*

---

## Resolved

| # | Date | Agent | Summary | Resolution |
|---|------|-------|---------|------------|

*No resolved items yet*

---

## How to Use This File

**For Agents - Questions/Decisions:**
1. Create a GitHub issue with `needs-human` label
2. Add a row to the "Open Asks" table
3. Continue with other work - don't block
4. Check this file at startup for responses

**For Agents - PRs Needing Human Merge:**
1. Add `needs-human-merge` label to the PR: `gh pr edit <num> --add-label "needs-human-merge"`
2. Add a row to the "PRs Needing Human Merge Approval" table
3. Wait for human approval before merging

**For Human Team Lead:**
1. Run the quick check commands above, or scan the tables
2. For asks: respond via issue comments, move to "Resolved"
3. For PRs: review, approve, and either merge yourself or remove the label so agent can merge

**Table Formats:**
```
# For asks:
| 1 | 2026-01-11 | Engineer | Brief summary | [#42](link) | high |

# For PRs:
| [#15](link) | 2026-01-11 | Engineer | New auth system | high |
```
