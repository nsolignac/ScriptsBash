# SOURCE
# DATE:
# https://unix.stackexchange.com/questions/49053/linux-add-x-days-to-date-and-get-new-virtual-date
# https://www.geeksforgeeks.org/date-command-linux-examples/

DATEI=`date -d "-60 days" "+%Y-%m-%d %H:%M:%S"`
DATEF=`date "+%Y-%m-%d %H:%M:%S"`
COMM='apt-install -y cosas'
i=0

echo "$DATEI"
echo "$DATEF"

$COMM

while [ $? -ne 1 ]
do
    $COMM
    if [ i -ne 0 ]
        echo "Esto es un test de reemplazo de variables donde $i cambia"
        i=$(( $i + 1 ))
    else
        break
done
