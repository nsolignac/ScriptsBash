echo "Memory: "
echo "                  "
free -m
echo "                  "


echo "                  "
echo "Processor: "
echo "                  "
lscpu
echo "                  "


echo "                  "
echo "Desea salir o usar otro programa?"
echo "(s) para salir, (c) para continuar"

read OPTION

if [ $OPTION = s ]
then    
        exit
else    
		echo "                                        					 "
        echo "(t) para invocar Top, (d) para DmiDecode y (s) para salir: "
        echo "                                        					 "
fi

read PROGRAM

case $PROGRAM in
	t)
		top
		;;
	d)
		echo "Indique el parametro para DmiDecode: "
		echo "(memory) para Memoria, (processor) para Procesador, (bios) para Bios: "

		read PARAMETER

		sudo dmidecode -t $PARAMETER
		;;
esac