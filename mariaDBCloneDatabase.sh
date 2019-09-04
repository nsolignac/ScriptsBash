#!/bin/bash

# SOURCE: https://dev.mysql.com/doc/mysql-replication-excerpt/5.7/en/replication-howto-mysqldump.html
# CFG TO FILE SOURCE: https://www.linode.com/docs/databases/mysql/use-mysqldump-to-back-up-mysql-or-mariadb/#automate-backups-with-cron

# Seteamos algunas variables
echo "NOMBRE DE LA DB ORIGEN:"
read DBO
echo "NOMBRE DE LA DB DESTINO:"
read DBD
echo "IP SERVER DESTINO:"
read SVD
echo "IP SERVER ORIGEN:"
read SVO
echo "USUARIO DB:"
read USERDB

# START
echo "=== START ==="

# Realizo el BACKUP
mysqldump --host=$SVO -u$USERDB -p --opt --routines --triggers --events --single-transaction --no-tablespaces --database=${DBO} | gzip > ./${DBO}.sql.gz

# Print del peso de la DB
DBSIZE=$(du -hs ./$DBO.sql.gz)
echo "El archivo dump de la DB $DBO, pesa: $DBSIZE MB"

# Creo la DB para restaurar el BACKUP
mysql --host=$SVD -u$USERDB -p -e "CREATE DATABASE $DBD CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';"

# Restauro el BACKUP
gzip -d ./${DBO}.sql.gz
mysql --host=$SVD -u$USERDB -p $DBO < ./${DBO}.sql

# Generamos usuario para administracion
echo "Indique el nombre del Usuario Administrador:"
read ADMINUSER
echo "Indique la password del Usuario Administrador:"
read MPWD
MDBD=$(echo $DBD | cut -b 1-7)

mysql --host=$SVD -u$USERDB -p -e "CREATE USER $ADMINUSER@'$MDBD.%' IDENTIFIED BY '$MPWD';"
mysql --host=$SVD -u$USERDB -p -e "GRANT SELECT, SHOW VIEW ON $DBD.* TO $ADMINUSER@'$MDBD.%';"

# Recargamos los permisos
mysql --host=$SVD -u$USERDB -p -e "FLUSH PRIVILEGES;"

# DONE
echo "=== DONE ==="
