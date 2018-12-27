#sh '''

#Definimos la ruta de trabajo
ROOTDIR="/usr/CMP/servicios_cmp_backend"

#Limpiamos la carpeta de los binarios obsoletos // TODO
#rm *.jar
cd $ROOTDIR

echo "DONDE ESTOY?"
echo ${WORKSPACE}
pwd
rm *.jar_* || true

#Guardamos el nombre del archivo de BACKUP
#FILENAME=$(ls . | grep -i "servicios_cmp_backend" | cut -d '-' -f 1 | sort -u)
FILENAME=servicios_cmp_backend.jar
echo $FILENAME

#Realizo el BACKUP
cp ${FILENAME} ${FILENAME}_$(date +%d-%m-%Y) || true

#DEPLOY
echo "DEPLOY"
cp ${WORKSPACE}/target/*.jar $FILENAME && echo "Se realizo el DEPLOY"

#Artifact perms
chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

#ps aux | grep -v grep | grep $FILENAME

# Variable API
API="servicios-cmp-backend"

#Path to pgrep command
PGREP="/usr/bin/pgrep"

#Find process pid
pgrep $(echo $API.jar) || true

#Control del servicio
#START="/usr/sbin/service $API start"
#STOP="/usr/sbin/service $API stop"

##Si el proceso no esta corriendo
#if [ $? -ne 0 ]
#then
#    # Inicio el servicio
#    /usr/sbin/service $(echo $API) start
#fi

/usr/sbin/service $API stop || true
sleep 1 && /usr/sbin/service $API start
ps aux | grep -v grep | grep $FILENAME

#'''
