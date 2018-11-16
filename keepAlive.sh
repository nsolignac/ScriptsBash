#Lista todos los dispositivos corriendo
adb devices

# Mapea variable con nombre del dispositivo
echo "Indique el dispositivo: "
echo "Default ID : emulator-5554 (Tandem)"
echo "Default ID : emulator-5556 (Argenpesos)"
read DEVICE

# Mapea variable con nombre de la app
echo "Indique el nombre de la app: "
read APP

# Lista los paquetes por nombre
adb -s $DEVICE shell pm list packages -f | grep -i $APP

# Lista nombre del paquete y actividad actual,
# de la app que se encuentra abierta actualmente
# en el equipo
adb -s $DEVICE shell dumpsys window windows | grep -E 'mCurrentFocus'
# Eg. "WhatsApp" - mCurrentFocus=Window{c371bb4 u0 com.whatsapp/com.whatsapp.HomeActivity}
# En el caso anterior, {package.name}="com.whatsapp"
# {com.package.name.ActivityName}="com.whatsapp.HomeActivity"

# Ejecuta Activity de una app
adb -s $DEVICE shell am start -n com.package.name/com.package.name.ActivityName

# Espera por la response del equipo
sleep 7

# KeyEvent Home de Android para enviar WhatsApp de nuevo al background
adb -s $DEVICE shell input keyevent 3 # "KEYCODE_HOME"
