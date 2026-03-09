#!/usr/bin/env python3
"""
media-bridge.py
───────────────
WebSocket server on ws://localhost:7071
- Pushes currently playing track to the startpage every 1.5s
- Accepts POST /cmd { "cmd": "play-pause" | "next" | "previous" }

Requirements:
  pip install websockets --break-system-packages
  sudo pacman -S playerctl

Add to hyprland.conf:
  exec-once = python3 ~/startpage/scripts/media-bridge.py
"""

import asyncio
import json
import subprocess
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer
import websockets

WS_PORT   = 7071
HTTP_PORT = 7072  # control commands come in here
POLL_INTERVAL = 1.5


def run(cmd):
    try:
        r = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=2)
        return r.stdout.strip()
    except Exception:
        return ""


def get_state():
    status = run("playerctl status 2>/dev/null")
    if not status or "No players" in status:
        return {"status": "stopped", "title": "", "artist": "", "art": ""}
    return {
        "status": status,
        "title":  run("playerctl metadata title  2>/dev/null"),
        "artist": run("playerctl metadata artist 2>/dev/null"),
        "art":    run("playerctl metadata mpris:artUrl 2>/dev/null"),
    }


# ── Control HTTP server (for play/pause/next/prev from the page) ──────────────
class ControlHandler(BaseHTTPRequestHandler):
    def log_message(self, *args): pass

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        body   = self.rfile.read(length)
        try:
            data = json.loads(body)
            cmd  = data.get("cmd", "")
            if cmd in ("play-pause", "next", "previous", "stop"):
                run(f"playerctl {cmd}")
        except Exception:
            pass
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()


def start_control_server():
    HTTPServer(("localhost", HTTP_PORT), ControlHandler).serve_forever()


# ── WebSocket broadcast ───────────────────────────────────────────────────────
CLIENTS = set()


async def handler(websocket):
    CLIENTS.add(websocket)
    print(f"[media] Client connected ({len(CLIENTS)} total)")
    try:
        await websocket.send(json.dumps(get_state()))
        await websocket.wait_closed()
    finally:
        CLIENTS.discard(websocket)


async def broadcast_loop():
    last = {}
    while True:
        state = get_state()
        if state != last:
            last = state
            if CLIENTS:
                msg = json.dumps(state)
                await asyncio.gather(
                    *[c.send(msg) for c in list(CLIENTS)],
                    return_exceptions=True,
                )
        await asyncio.sleep(POLL_INTERVAL)


async def main():
    # Start control HTTP server in a background thread
    t = threading.Thread(target=start_control_server, daemon=True)
    t.start()
    print(f"[media] WebSocket on ws://localhost:{WS_PORT}")
    print(f"[media] Controls on http://localhost:{HTTP_PORT}/cmd")
    async with websockets.serve(handler, "localhost", WS_PORT):
        await broadcast_loop()


if __name__ == "__main__":
    asyncio.run(main())
