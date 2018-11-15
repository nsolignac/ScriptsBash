#Lista todos los dispositivos corriendo
adb devices

# Mapea variable con nombre del dispositivo
echo "Indique el dispositivo: "
echo "Defaults ID's : emulator-5554 (Tandem)"
echo "Defaults ID's : emulator-5556 (Argenpesos)"
read DEVICE

echo "Indique el nombre de la app: "
read APP

# Lista los paquetes por nombre
adb -s $DEVICE shell pm list packages -f | grep -i $APP

# Lista nombre del paquete y actividad actual,
# de la app que se encuentra abierta actualmente
# en el equipo

adb -s $DEVICE shell dumpsys window windows | grep -E 'mCurrentFocus'

# 
