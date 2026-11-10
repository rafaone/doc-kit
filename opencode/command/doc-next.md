---
description: Resumes the documentation where it stopped (one item)
agent: doc
---
Follow the "Mandatory cycle" from your instructions for ONE item.

Current state:
!`cat docs/_doc/dev/STATE.md`

Next pending items:
!`grep -n -A4 -m3 '^- \[ \]' docs/_doc/dev/PLAN.md`

Global notes:
!`cat docs/_doc/dev/NOTES.md`

If STATE.md shows an item in progress, continue exactly from the step it names,
opening the target .md that already exists (do not start over).
When the item is done, update PLAN.md, STATE.md and NOTES.md and stop.
