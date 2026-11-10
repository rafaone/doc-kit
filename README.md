# doc-kit

Source-code documentation in Markdown with opencode + Strata, in short sessions
that resume where they stopped. In each repository: `docs/dev/` (developer docs), `docs/manual/` (pre-manual) and `docs/_doc/` (the agents' state, one folder per kind).

## Install (once)

1. Strata running (`/opt/Strata/run-iq2_xs.sh`) and the key in your environment
   (`STRATA_API_KEY` in `~/.zshrc`).
2. `./install.sh`, which copies:
   - `opencode/agent/doc.md` → `~/.config/opencode/agent/` (the `doc` agent)
   - `opencode/command/*.md` → `~/.config/opencode/command/` (`/doc-plan`, `/doc-next`)
   - `doc-loop.sh` → `~/.local/bin/doc-loop`
   - `opencode/opencode.json` only if you have none. To replace yours (with a backup): `./install.sh --json`
3. Test: `opencode run "say hi" < /dev/null`

## Use in a project

1. `cd` into the repository and open `opencode`.
2. Tab to the `doc` agent and run `/doc-plan`. Review the generated `docs/_doc/dev/PLAN.md`.
3. One item at a time, inside opencode: `/doc-next`.
   Or unattended, in another terminal: `doc-loop /path/to/repo`
4. Follow along: `tail -f docs/_doc/dev/loop.log` and `cat docs/_doc/dev/STATE.md`.

If the loop stops with "Stuck on the same item", read `STATE.md`, split the item
into smaller pieces in `PLAN.md` and run it again.

## Pre-manual (user-facing, no code)

Feature docs for the user manual: only what the user sees and does, no file,
function, variable or endpoint names. Safe to share outside the company once
the checker is clean. Run it after the developer docs exist, since it reads them.

1. In opencode: `/doc-pre-manual-plan`. Review `docs/_doc/manual/PLAN.md`
   (items are user features, not code modules).
2. One feature at a time: `/doc-pre-manual`.
   Or unattended: `doc-loop /path/to/repo --pre-manual`
3. Output goes to `docs/manual/`. Before sharing anything, run
   `pre-manual-check docs/manual` and read every file yourself. The checker
   catches code-shaped text (backticks, file names, snake_case, camelCase,
   paths, URLs); it cannot catch internal product names or business secrets.

## small-steps (code changes, easy on the machine)

For changing code with a local model: plan first, then one small step per turn,
with the plan saved in `.small-steps/TASK.md` so any session can resume it.
It uses `docs/dev/README.md` and the module doc as a map instead of reading the code.

1. `/small-steps <what to change>` — reads the docs, writes the plan, waits.
2. Review `.small-steps/TASK.md`. To approve, run `/small-steps` (or say ok).
3. `/small-steps` again for each next step. New session? Same command: it resumes.
4. Finished tasks move to `.small-steps/done/`. Add `.small-steps/` to `.gitignore`.

There is no unattended loop for this on purpose: review each code step.

The generated docs are written in English. To change that, edit the
"Write the documentation in English" line in `opencode/agent/doc.md` and reinstall.

## Migrating a project from the old layout

Projects documented before `docs/dev/` existed have the docs loose in `docs/`.
`doc-migrate /path/to/repo --dry-run` shows what would move; run it without
`--dry-run` to move. Only the files listed in the old PLAN.md are moved.
