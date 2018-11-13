# List ports and protocol

echo 'Indique el protocolo'
read PROTOCOL

echo 'Indique el puerto'
read PORT

lsof -i $PROTOCOL | grep -i $PORT

#List all user using a port

fuser $PORT/$PROTOCOL
