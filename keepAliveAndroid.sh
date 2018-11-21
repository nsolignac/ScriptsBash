# Se guarda el valor de $DEVICE
#echo "Indique el dispositivo incluyendo guion y numero: "
#read DEVICE

# Directorio donde se desea loguear
LOGDIR=/home/$USER
LOGDIR+='/$FOLDER'

# Carpeta donde se desea loguear
echo "Indique la carpeta donde desea loguear: "
read FOLDER

# Archivo de log
logWhats=logWhatsapp.txt

# Abre el Home de Whatsapp para despertar el equipo
adb -s $DEVICE shell am start -n com.whatsapp/com.whatsapp.HomeActivity | touch $LOGDIR$logWhats | ts | tee -a $LOGDIR$logWhats

# Duerme para esperar que el equipo responda
sleep 7

# Activa la key Home del equipo para minimizar la app (WhatsApp en este caso)
adb -s $DEVICE shell input keyevent 3
