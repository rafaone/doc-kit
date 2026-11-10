---
description: Code change in small steps; with text starts a task, without text continues it
agent: small-steps
---
Follow the "Cycle" from your instructions.

Requested task (empty = continue the active one): $ARGUMENTS

Active task:
!`cat .small-steps/TASK.md 2>/dev/null || echo "no active task"`

Docs index:
!`ls docs/dev/*.md 2>/dev/null || echo "no docs/ folder"`

- If there is a requested task and the active task is not `done`, do NOT replace
  it: show its status in 2 lines and ask whether to drop it or finish it first.
- If there is no requested task and no active task, ask what to do.
- Otherwise do exactly one thing from the cycle (plan, or one step) and stop.
