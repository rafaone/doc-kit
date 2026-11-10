---
description: Creates the repository's documentation plan (checklist)
agent: doc
---
Create the `docs/_doc/dev/` folder and the files `PLAN.md`, `STATE.md` and `NOTES.md`.

To build the plan, do NOT read file contents. Use only the structure:
!`find . -type f \( -name '*.py' -o -name '*.ts' -o -name '*.js' -o -name '*.go' -o -name '*.java' -o -name '*.cs' -o -name '*.rs' \) -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/vendor/*' | xargs wc -l 2>/dev/null | sort -k2 | tail -400`

PLAN.md rules:
- Include an item for `docs/dev/README.md` (overview and index of all module docs), placed LAST in the list.
- One item per folder/module with up to ~10 files and ~3000 lines; split larger ones.
- Format of each item:

```
- [ ] <id> <folder or files> -> docs/dev/<target>.md
  - [ ] read
  - [ ] draft
  - [ ] complete
  - [ ] review
```

STATE.md starts with the line `idle`. NOTES.md starts empty with the title `# Global notes`.
Extra focus (optional): $ARGUMENTS
Save the three files and stop.
