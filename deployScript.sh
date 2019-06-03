#!/bin/bash

#Definimos la ruta de trabajo
ROOTDIR="/appuser/multichannel"

#Limpiamos la carpeta de los binarios obsoletos
cd $ROOTDIR
rm *.jar_* || true
rm nohup.bkp || true

#Guardamos el nombre del archivo de BACKUP
FILENAME=$(ls . | grep -i "multichannel" | cut -d '-' -f 1 | sort -u)
echo $FILENAME

#Realizo el BACKUP
mv nohup.out nohup.bkp || true
cp ${FILENAME}-*.jar ${FILENAME}_$(date +%d-%m-%Y).bkp || true

#DEPLOY
echo "DEPLOY"
FILENAME=$FILENAME.jar
cp ${WORKSPACE}/build/libs/*.jar $FILENAME && echo "Se realizo el DEPLOY"

#Permisos
chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

#Path to pgrep command
PGREP="/usr/bin/pgrep"

#Find process pid
pgrep $(echo $FILENAME) || true
ps aux | grep -v grep | grep $FILENAME
