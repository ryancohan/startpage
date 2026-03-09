#!/usr/bin/env bash
# setup.sh — installs dependencies, configures location, and sets up autostart
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_JS="$SCRIPT_DIR/js/config.js"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        startpage setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── 1. Python dependencies ────────────────────────────────────────────────────
echo "[ 1/4 ] Installing Python dependencies..."
if command -v pacman &>/dev/null; then
  sudo pacman -S --needed --noconfirm python-websockets python-psutil
elif command -v pip3 &>/dev/null; then
  pip3 install websockets psutil --break-system-packages -q
elif command -v pip &>/dev/null; then
  pip install websockets psutil --break-system-packages -q
else
  echo "        ✗ Could not find pacman or pip — install python-websockets and python-psutil manually."
  exit 1
fi
echo "        ✓ websockets, psutil installed"

# ── 2. playerctl check ────────────────────────────────────────────────────────
echo ""
echo "[ 2/4 ] Checking playerctl..."
if ! command -v playerctl &>/dev/null; then
  echo "        ⚠  playerctl not found — install with: sudo pacman -S playerctl"
else
  echo "        ✓ playerctl $(playerctl --version)"
fi

# ── 3. Location setup ─────────────────────────────────────────────────────────
echo ""
echo "[ 3/4 ] Weather location"
echo "        The weather widget uses Open-Meteo (no API key needed)."
echo "        You can:"
echo "          [1] Let the browser ask for your location automatically (recommended)"
echo "          [2] Enter coordinates manually"
echo ""
read -rp "        Choice [1/2]: " LOC_CHOICE

case "$LOC_CHOICE" in
  2)
    echo ""
    echo "        Find your coordinates at: https://www.latlong.net"
    read -rp "        Latitude  (e.g. 41.9175): " USER_LAT
    read -rp "        Longitude (e.g.  3.1631): " USER_LON

    if ! [[ "$USER_LAT" =~ ^-?[0-9]+(\.[0-9]+)?$ ]] || \
       ! [[ "$USER_LON" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
      echo ""
      echo "        ✗ Invalid coordinates — falling back to browser geolocation."
      LOC_MODE="geo"
    else
      LOC_MODE="manual"
      echo "        ✓ Using ($USER_LAT, $USER_LON)"
    fi
    ;;
  *)
    LOC_MODE="geo"
    echo "        ✓ Browser geolocation will be used on first load."
    ;;
esac

# ── 4. Write / patch config.js ────────────────────────────────────────────────
echo ""
echo "[ 4/4 ] Writing config..."

if [ "$LOC_MODE" = "manual" ]; then
  python3 - "$CONFIG_JS" "$USER_LAT" "$USER_LON" <<'PYEOF'
import sys, re, pathlib
path = pathlib.Path(sys.argv[1])
lat, lon = sys.argv[2], sys.argv[3]
content = path.read_text()
new_block = (
    "// \u2500\u2500\u2500 Location \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\n"
    f"// Manually configured by setup.sh\n"
    f"const LOCATION = {{ lat: {lat}, lon: {lon} }};\n"
)
content = re.sub(r'// \u2500{3} Location.*?(?=// \u2500{3})', new_block + "\n", content, count=1, flags=re.DOTALL)
path.write_text(content)
print("        \u2713 config.js updated with manual coordinates")
PYEOF
else
  python3 - "$CONFIG_JS" <<'PYEOF'
import sys, re, pathlib
path = pathlib.Path(sys.argv[1])
content = path.read_text()
new_block = (
    "// \u2500\u2500\u2500 Location \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\n"
    "// null = use browser geolocation (weather.js will prompt the user)\n"
    "const LOCATION = null;\n"
)
content = re.sub(r'// \u2500{3} Location.*?(?=// \u2500{3})', new_block + "\n", content, count=1, flags=re.DOTALL)
path.write_text(content)
print("        \u2713 config.js updated \u2014 browser geolocation enabled")
PYEOF
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup complete!"
echo ""
echo "  Add these lines to your hyprland.conf:"
echo ""
echo "    exec-once = python3 $SCRIPT_DIR/scripts/media-bridge.py"
echo "    exec-once = python3 $SCRIPT_DIR/scripts/stats-bridge.py"
echo ""
echo "  Then open index.html in your browser."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
