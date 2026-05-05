#!/system/bin/sh
# shellcheck shell=sh
set -e
MODDIR=${0%/*}

# shellcheck disable=SC3040
set +o standalone
unset ASH_STANDALONE

. "$MODDIR/lib/common.sh"

log "ACTION" "Running full integrity pipeline"

sh "$MODDIR/orchestrator.sh" full_integrity || exit $?

run_device_info "$MODDIR"

log "ACTION" "Meets Strong Integrity with Specter"

[ "${0##*/}" = "action.sh" ] && exit 0 || return 0
