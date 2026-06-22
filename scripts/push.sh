#!/bin/bash
# Build and push module directly to device
# Usage: ./scripts/push.sh

ZIP=$(ls /home/dpejoh/code/specter/module/Specter-*.zip 2>/dev/null | sort | tail -1)
if [ -z "$ZIP" ]; then
  echo "No zip found. Run 'npm run build' first."
  exit 1
fi

echo "Pushing: $ZIP"
SDIR="/storage/emulated/0/specter-update"
adp_push() {
  adb push "$1" /data/local/tmp/ 2>/dev/null || return 1
  adb shell "su -c \"mkdir -p $SDIR && cp /data/local/tmp/$(basename "$1") $SDIR/ && rm /data/local/tmp/$(basename "$1")\"" 2>/dev/null
}
adp_push "$ZIP" || { echo "adb push failed"; exit 1; }
adp_push "scripts/deploy-module.sh" 2>/dev/null || true

echo "Deploying..."
adb shell su -c sh "$SDIR/deploy-module.sh" "$SDIR/$(basename "$ZIP")"
echo "Done. Hard-refresh the webui page."
