#Lista todos los dispositivos corriendo
adb devices

# Mapea variable con nombre del dispositivo
echo "Indique el dispositivo: "
echo "Defaults ID's : emulator-5554 (Tandem)"
echo "Defaults ID's : emulator-5556 (Argenpesos)"
read DEVICE

echo "Indique el nombre de la app: "
read APP

adb -s $DEVICE shell pm list packages -f | grep -i $APP
