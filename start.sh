#!/bin/bash
set -e

Xvfb :99 -screen 0 1024x768x24 -ac &
export DISPLAY=:99

for i in {1..5}; do
    if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
        break
    fi
    sleep 0.5
done

fluxbox -display :99 &
sleep 1

x11vnc -display :99 -forever -shared -nopw -bg -quiet &
websockify --web=/usr/share/novnc/ --wrap-mode=ignore 6080 localhost:5900 &
sleep 1

export SDL_AUDIODRIVER=dummy

exec chocolate-doom -noxkb -iwad /usr/share/games/doom/freedoom1.wad
