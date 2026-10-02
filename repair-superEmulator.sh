#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT" || exit 1
echo "=== superEmulator repair / diagnostic ==="
fail=0
for f in index.html libv86.js v86.wasm seabios.bin vgabios.bin; do
  if [ -f "$f" ]; then printf '[OK] %-16s %s bytes\n' "$f" "$(wc -c < "$f")"; else echo "[NG] $f"; fail=1; fi
done
if [ -f "./debug-linux/debian.iso" ]; then echo '[OK] debug-linux/debian.iso'; else echo '[INFO] debug-linux/debian.iso not found'; fi
if command -v sha256sum >/dev/null 2>&1; then echo; echo '[SHA256]'; sha256sum libv86.js v86.wasm seabios.bin vgabios.bin 2>/dev/null || true; fi
echo; echo '[HTTP]'; if command -v python3 >/dev/null 2>&1; then echo '[OK] python3'; echo 'Start with: python3 -m http.server 8000'; else echo '[NG] python3 not found'; fail=1; fi
echo; echo '[TIP] Do not open with file://; use http://localhost:8000/ or GitHub Pages.'
if [ "$fail" -eq 0 ]; then echo '=== basic repair check: OK ==='; else echo '=== basic repair check: SOME FILES ARE MISSING ==='; fi
exit "$fail"
