#!/bin/bash

# SOURCE
# DATE:
# https://unix.stackexchange.com/questions/49053/linux-add-x-days-to-date-and-get-new-virtual-date
# https://www.geeksforgeeks.org/date-command-linux-examples/

DATEI=`date -d "-60 days" "+%Y-%m-%d %H:%M:%S"`
DATEF=`date "+%Y-%m-%d %H:%M:%S"`
COMM='apt-get install -y cosas'
I=0

echo "$DATEI"
echo "$DATEF"

echo "Instalando Whatsapp ..."
$COMM && echo -n "Whatsapp Installation OK"
I=$(echo $?)

while [ $I -ne 0 ]
do
    echo "Instalando Whatsapp ..."
    $COMM
    I=$(echo $?)
    if [ $I -ne 0 ]; then
        sleep 120
        echo -n "Whatsapp Installation FAIL"
        echo -n "Retrying in 2 minutes"
    else
        echo -n "Whatsapp Installation OK"
        break
    fi
done
