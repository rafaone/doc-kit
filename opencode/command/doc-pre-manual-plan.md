---
description: Creates the pre-manual plan (checklist of user features)
agent: pre-manual
---
Create the `docs/_doc/manual/` and `docs/manual/` folders and the files
`docs/_doc/manual/PLAN.md`, `STATE.md` and `NOTES.md`.

Build the plan from the developer docs and from where the UI lives.
Developer docs available:
!`ls docs/dev/*.md 2>/dev/null`

Likely UI and user-text files (names only, do not read them now):
!`find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path './docs/*' | grep -iE '(page|screen|view|form|menu|route|template|component|i18n|locale|lang|messages|strings|resources)' | head -200`

Read the developer docs (not the code) to list what a USER can do.

PLAN.md rules:
- One item per user feature or screen (e.g. "Create an order", "Reset password"),
  NOT per code module. Name items the way a user would.
- First item: `docs/manual/overview.md` (what the product is, main menu), placed LAST.
- For each item, note which dev docs and UI files to read, so the next session knows.
- Format of each item:

```
- [ ] <id> <Feature name> -> docs/manual/<feature>.md
  sources: <dev docs and UI files for this feature>
  - [ ] read
  - [ ] draft
  - [ ] complete
  - [ ] scrub
```

STATE.md starts with the line `idle`. NOTES.md starts with the title `# Product notes`.
Extra focus (optional): $ARGUMENTS
Save the files and stop.
