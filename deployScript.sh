#!/bin/bash
#Definimos algunas variables
ROOTDIR="/appuser/multichannel"
FILENAME="multichannel"

#Limpiamos la carpeta de los binarios obsoletos
cd $ROOTDIR
rm *.bkp|| true

#Realizo el BACKUP
mv nohup.out nohup.bkp || true
mv ${FILENAME}-*.jar ${FILENAME}_$(date +%d%m%Y).bkp || true

FILENAME_TMP=$FILENAME
FILENAME=$FILENAME-$(ls ${WORKSPACE}/build/libs/ | grep 'api-[0-3]\.[0-9][0-9].jar$' | grep -o '[0-3]\.[0-9][0-9]').jar

#DEPLOY
echo "Comienzo el Deploy"
cp ${WORKSPACE}/build/libs/*.jar $FILENAME && echo "Se realizo el DEPLOY"

#Permisos
chown --reference *_$(date +%d%m%Y).bkp $FILENAME || chown appuser:appuser $FILENAME
chmod --reference *_$(date +%d%m%Y).bkp $FILENAME || chmod 775 $FILENAME

#Reiniciamos el proceso
MyPID=$(pgrep -f "java -jar -Dgrails.env=$ENVIRONMENT -Dserver.port=443 $FILENAME_TMP")
kill -9 $MyPID

#Evitamos que Jenkins mate el servicio
JENKINS_NODE_COOKIE="DontKillMe"

echo "Iniciamos el servicio: $FILENAME"
nohup java -jar -Dgrails.env=$ENVIRONMENT -Dserver.port=443 $FILENAME &
