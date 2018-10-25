# Listamos los dispositivos virtuales
cd /home/vnc/Android/Sdk/tools/bin && ./avdmanager list avd | tee /home/vnc/logsAVDlist.txt

#Elegimos el dispositivo a utilizar
echo "Que dispositivo desea usar?"
echo "Figura bajo el nombre de %Name% %Ej:Name: Galaxy_Nexus_API_17%"
read DEVICE
echo $DEVICE "Debug stage"

#Corremos el dispositivo elegido
cd /home/vnc/Android/Sdk/tools && ./emulator -avd $DEVICE | tee /home/vnc/logsAVDdevice.txt
