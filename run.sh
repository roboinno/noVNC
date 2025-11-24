#!/bin/bash
set -e

echo "[1] Removing stale lock"
rm -f /tmp/.X1-lock

echo "[2] Starting Xvfb..."
Xvfb :1 -screen 0 1920x1080x16 &

echo "[3] Waiting for Xvfb to become ready..."
for i in {1..50}; do
    if xdpyinfo -display :1 >/dev/null 2>&1; then
        echo "    Xvfb is ready."
        break
    fi
    sleep 0.1
done

if ! xdpyinfo -display :1 >/dev/null 2>&1; then
    echo "ERROR: Xvfb did not start properly."
    exit 1
fi

echo "[4] Starting x11vnc..."
x11vnc -display :1 -forever -nopw -rfbport 5900 -logfile /tmp/x11vnc.log &

echo "[5] Waiting for x11vnc to start listening on port 5900..."
for i in {1..50}; do
    if nc -z localhost 5900; then
        echo "    x11vnc is ready."
        break
    fi
    sleep 0.1
done

if ! nc -z localhost 5900; then
    echo "ERROR: x11vnc did not start properly."
    echo "x11vnc log:"
    cat /tmp/x11vnc.log
    exit 1
fi

echo "[6] Starting noVNC..."
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 8082 &

echo "[7] Launching app..."
export DISPLAY=:1
mousepad
