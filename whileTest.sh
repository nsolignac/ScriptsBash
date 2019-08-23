# SOURCE
# DATE:
# https://unix.stackexchange.com/questions/49053/linux-add-x-days-to-date-and-get-new-virtual-date
# https://www.geeksforgeeks.org/date-command-linux-examples/

DATEI=`date -d "-60 days" "+%Y-%m-%d %H:%M:%S"`
DATEF=`date "+%Y-%m-%d %H:%M:%S"`
d=0

echo "$DATEI"
echo "$DATEF"

while [ $d -le 4 ]
do
    echo "Esto es un test de reemplazo de variables donde $d cambia"
    d=$(( $d + 1 ))
done
