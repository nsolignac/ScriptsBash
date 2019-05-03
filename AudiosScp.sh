#VARIABLES
ROOTDIR="/appuser/mara.csv"
SCP_TARGET="t1000@192.168.87.29"
SCP_DIR="/tmp"

#PERMISOS
chown appuser:appuser -R $ROOTDIR
chmod 777 $ROOTDIR

#CD TO ROOTDIR
cd $ROOTDIR
cd CSVs/

#LIMPIAMOS EL AMBIENTE
rm -r soporte*
rm *.zip

#ZIP
zip -r "Audios-$(date +%m%Y).zip" *

#SCP AL DESTINATARIO
/usr/bin/scp Audios* $SCP_TARGET:$SCP_DIR
