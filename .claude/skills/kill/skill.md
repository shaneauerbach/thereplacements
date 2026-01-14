---
name: kill
description: Gracefully wrap up current work before agent shutdown. Use when you need to kill and restart agents.
---

# Graceful Shutdown

The human wants to kill and restart agents. Wrap up your work as quickly and cleanly as possible.

## Instructions

Do these steps quickly - don't deliberate:

### 1. Stop Current Work
- Stop whatever you're doing immediately
- Don't start any new tasks

### 2. Save Your Progress

```bash
# Check what's uncommitted
git status

# If you have changes, commit them with a WIP message
git add -A
git commit -m "WIP: [brief description of what you were working on]"

# Push to your branch (not main) if possible
git push origin HEAD 2>/dev/null || echo "Could not push - that's OK"
```

### 3. Update Status (if applicable)

If you were working on an issue:
- Do NOT remove any labels - leave the state as-is for when you restart
- The "Picking this up" comment already shows you claimed it

If you have a PR with `status:needs-changes`:
- Leave it - you'll address it after restart

### 4. Report Status

Briefly tell the human:
1. What you were working on
2. Current state (committed/uncommitted, PR status if any)
3. What you'll pick up on restart

### 5. Confirm Ready

Say: "Ready for shutdown."

## Important

- Be FAST - the human is waiting
- Don't overthink - just save state and report
- It's OK to leave work incomplete - you'll resume after restart
