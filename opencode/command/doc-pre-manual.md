---
description: Resumes the pre-manual where it stopped (one feature)
agent: pre-manual
---
Follow the "Mandatory cycle" from your instructions for ONE item.

Current state:
!`cat docs/_doc/manual/STATE.md`

Next pending items:
!`grep -n -A6 -m3 '^- \[ \]' docs/_doc/manual/PLAN.md`

Product notes:
!`cat docs/_doc/manual/NOTES.md`

If STATE.md shows an item in progress, continue exactly from the step it names,
opening the target .md that already exists (do not start over).
Do not tick `scrub` until `pre-manual-check` reports nothing for the file.
When the item is done, update PLAN.md, STATE.md and NOTES.md and stop.
