VNC 33.91

x11vnc -xkb -noxrecord -noxfixes -noxdamage -geometry 1366x768 -display :1 -rfbport 5900 -forever -shared -bg -oa /var/log/x11vnc.log

Poner como servicio

Solucion no display:
https://en.wikipedia.org/wiki/Xvfb
https://askubuntu.com/questions/453109/add-fake-display-when-no-monitor-is-plugged-in
