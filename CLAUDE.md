# CLAUDE.md - Agent Instructions

You are an autonomous agent on this project. Follow these rules.

---

## CRITICAL RULES

**1. NEVER STOP. You are a daemon.**
```bash
# When no work: snooze 2 min, pull, check again. FOREVER.
for i in $(seq 4 -1 1); do echo "Snoozing... $((i * 30))s remaining"; sleep 30; done
git pull origin main
# Then restart your work loop
```

**2. Never push to another agent's branch.** Only the PR author touches their branch.

**3. Read PR comments before merging.** Check for concerns, not just labels.

**4. Work only on issues assigned to your role.**
- Check for `agent:<your-role>` label before starting work

---

## FORBIDDEN PHRASES

Never say these - they mean you're about to stop incorrectly:
- "All my work is complete"
- "Session summary" / "Session accomplishments"
- "The work loop is complete"
- "No work remains"

---

## WORK LOOP

Run this loop forever:

1. **Merge your approved PRs** - `gh pr list --author @me --state open`
2. **Fix your PRs with requested changes** - `gh pr list --author @me --label "status:needs-changes"`
3. **Review others' PRs** - `gh pr list --label "needs-review:<your-role>"`
4. **Find new work** - `gh issue list --label "agent:<your-role>"`
5. **No work? SNOOZE** - Sleep 2 min, pull, go to step 1

**Priority:** Merge ready PRs → Review others → New work → Snooze

---

## WORKFLOW BASICS

### Starting an Issue
```bash
# 1. Create branch
git checkout -b <your-role>/<issue-num>-short-description

# 2. Work on it
```

### Creating a PR
```bash
# 1. Sync with main first
git fetch origin main && git merge origin/main

# 2. Run checks (adjust for your project's test/lint commands)
# Examples: pytest, npm test, cargo test, go test, etc.

# 3. Create PR
gh pr create --title "[#<issue>] Description" --body "Summary...\n\nCloses #<issue>"

# 4. Request reviews (you decide who)
gh pr edit <num> --add-label "needs-review:qa"
```

### Merging Your PR
```bash
# 1. Check ready (no needs-review labels remaining)
gh pr view <num> --json labels --jq '[.labels[].name] | any(startswith("needs-review:"))'

# 2. Read comments for any concerns
gh pr view <num> --comments

# 3. Merge
gh pr merge <num> --squash
```

### Reviewing Others' PRs
```bash
# Approve
gh pr review <num> --comment --body "LGTM - [your feedback]"
gh pr edit <num> --add-label "approved:<your-role>" --remove-label "needs-review:<your-role>"

# Request changes
gh pr review <num> --comment --body "Changes needed: [feedback]"
gh pr edit <num> --add-label "status:needs-changes"
```

---

## LABELS

| Label | Use On | Meaning |
|-------|--------|---------|
| `agent:<role>` | Issues | Assigned to this agent |
| `needs-review:<role>` | PRs | Waiting for this agent's review |
| `approved:<role>` | PRs | This agent approved |
| `status:needs-changes` | PRs | Author must fix issues |
| `needs-human-merge` | PRs | Requires human approval |

---

## RISK PHILOSOPHY

Customize this section for your project. Examples:
- For financial projects: Set position limits, daily loss limits
- For infrastructure: Require human approval for production changes
- For consumer products: Require human approval for user-facing copy

When uncertain, choose the safer option.

---

## WHEN BLOCKED

1. **Need another agent?** Create an issue with `agent:<role>` label
2. **Need human decision?** Create issue with `needs-human` label, add to `asks/human.md`
3. **Keep working** on other tasks - don't wait

---

## PROJECT SETUP

**Run your project's setup commands.** Examples:
- Node.js: `npm install`
- Python: `pip install -e ".[dev]"`
- Rust: `cargo build`
- Go: `go mod download`

---

## REFERENCE DOCS

For detailed information, see:
- `docs/workflow-reference.md` - Full label tables, gh commands, examples
- `HUMAN.md` - Instructions for the human team lead
- `agents/<role>/identity.md` - Your role-specific instructions
