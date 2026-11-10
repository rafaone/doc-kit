#!/usr/bin/env bash
# Runs opencode in short sessions: one fresh session per PLAN.md item.
# Usage: ./doc-loop.sh /path/to/repo [--pre-manual]
#   default       developer docs   (agent doc,        state in docs/_doc/dev/)
#   --pre-manual  user pre-manual  (agent pre-manual, state in docs/_doc/manual/)
# Optional variables:
#   STRATA_URL   (default http://127.0.0.1:8080)
#   STRATA_KEY   (api_key from the strata json; default: $STRATA_API_KEY)
#   RESTART_CMD  (e.g. "systemctl --user restart strata") — used if the server goes down
#   ITEM_TIMEOUT (default 45m)
#   MAX_STALL    (default 3) — consecutive attempts without progress before giving up
set -u

REPO="${1:?pass the repository folder}"
STRATA_URL="${STRATA_URL:-http://127.0.0.1:8080}"
ITEM_TIMEOUT="${ITEM_TIMEOUT:-45m}"
MAX_STALL="${MAX_STALL:-3}"

if [ "${2:-}" = "--pre-manual" ]; then
  AGENT=pre-manual; STATE_DIR=docs/_doc/manual; PLAN_CMD=/doc-pre-manual-plan
else
  AGENT=doc; STATE_DIR=docs/_doc/dev; PLAN_CMD=/doc-plan
fi
PLAN="$REPO/$STATE_DIR/PLAN.md"
LOG="$REPO/$STATE_DIR/loop.log"

cd "$REPO" || exit 1
[ -f "$PLAN" ] || { echo "Run $PLAN_CMD in opencode first."; exit 1; }

done_count() { grep -c '\[x\]' "$PLAN"; }
pending()    { grep -q '^- \[ \]' "$PLAN"; }

server_ok() {
  curl -sf -m 10 -H "Authorization: Bearer ${STRATA_KEY:-${STRATA_API_KEY:-}}" "$STRATA_URL/v1/models" >/dev/null
}

wait_server() {
  for i in $(seq 1 30); do
    server_ok && return 0
    if [ "$i" -eq 3 ] && [ -n "${RESTART_CMD:-}" ]; then
      echo "$(date '+%F %T') server down, restarting" | tee -a "$LOG"
      sh -c "$RESTART_CMD"
    fi
    sleep 20
  done
  return 1
}

PROMPT="Follow the \"Mandatory cycle\" from your instructions for ONE item.
Read $STATE_DIR/STATE.md, $STATE_DIR/PLAN.md and $STATE_DIR/NOTES.md first.
If STATE.md shows an item in progress, continue from the step it names without starting over.
When the item is done, update PLAN.md, STATE.md and NOTES.md and stop."

stall=0
while pending; do
  wait_server || { echo "Server did not come back. Stopping." | tee -a "$LOG"; exit 1; }
  before=$(done_count)
  echo "$(date '+%F %T') new session (done: $before)" | tee -a "$LOG"

  timeout "$ITEM_TIMEOUT" opencode run --agent "$AGENT" "$PROMPT" </dev/null >>"$LOG" 2>&1

  after=$(done_count)
  if [ "$after" -gt "$before" ]; then
    stall=0
  else
    stall=$((stall + 1))
    echo "$(date '+%F %T') no progress ($stall/$MAX_STALL)" | tee -a "$LOG"
    [ "$stall" -ge "$MAX_STALL" ] && { echo "Stuck on the same item. Check STATE.md." | tee -a "$LOG"; exit 2; }
  fi
done
echo "$(date '+%F %T') plan complete" | tee -a "$LOG"
