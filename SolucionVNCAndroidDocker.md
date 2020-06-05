VNC 33.91

-- Opcion normal (Xvfb corre por separadpo)
   x11vnc -xkb -noxrecord -noxfixes -noxdamage -geometry 1366x768 -display :1 -rfbport 5900 -forever -shared -bg -oa /var/log/x11vnc.log

-- Opcion con "-create" para crear session de X11 con Xvfb:
   x11vnc -xkb -noxrecord -noxfixes -noxdamage -geometry 1366x768 -create -rfbport 5900 -forever -shared -bg -oa /var/log/x11vnc.log


-- Para saber que motor grafico estamos usando:
   https://unix.stackexchange.com/questions/236498/how-to-get-information-about-which-display-server-is-running/283936


-- Solucion no display (Xvfb) (Parametro "-create" para usar Xvfb):
   https://en.wikipedia.org/wiki/Xvfb
   https://askubuntu.com/questions/453109/add-fake-display-when-no-monitor-is-plugged-in

!! Poner como servicio Xvfb y VNC !!
