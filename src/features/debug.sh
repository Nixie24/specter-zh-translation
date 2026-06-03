#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/../lib/common.sh"
. "$MODDIR/../lib/paths.sh"

LOG_DIR="$SPECTER_DIR/log"
echo "========================================"
echo "  Specter Debug Summary"
echo "========================================"
echo ""

echo "=== Boot Log (last 30 lines) ==="
if [ -f "$LOG_DIR/boot.log" ]; then
  tail -30 "$LOG_DIR/boot.log" 2>/dev/null
else
  echo "(no boot.log)"
fi
echo ""

echo "=== Action Log (last 15 lines) ==="
if [ -f "$LOG_DIR/action.log" ]; then
  tail -15 "$LOG_DIR/action.log" 2>/dev/null
else
  echo "(no action.log)"
fi
echo ""

echo "=== Scheduler Status ==="
if [ -f "$SPECTER_DIR/scheduler.pid" ]; then
  _pid=$(cat "$SPECTER_DIR/scheduler.pid" 2>/dev/null)
  if kill -0 "$_pid" 2>/dev/null; then
    echo "  Running (PID $_pid)"
  else
    echo "  Stale PID $_pid (not running)"
  fi
else
  echo "  Not running"
fi
echo ""

echo "=== Log Directory ==="
ls -lh "$LOG_DIR" 2>/dev/null || echo "(empty)"
echo ""

echo "=== Feature Logs (errors only) ==="
for _f in "$LOG_DIR"/boot_*.log "$LOG_DIR"/sched_*.log; do
  [ -f "$_f" ] || continue
  _errors=$(grep -ciE '(error|fail|warn)' "$_f" 2>/dev/null || echo "0")
  [ "$_errors" -gt 0 ] && echo "  $(basename "$_f"): $_errors issues"
done
echo ""

echo "=== logcat (last 20 Specter lines) ==="
if command -v logcat >/dev/null 2>&1; then
  logcat -d -s Specter 2>/dev/null | tail -20 || echo "  (logcat unavailable)"
else
  echo "  (logcat not available)"
fi
echo ""
echo "========================================"
