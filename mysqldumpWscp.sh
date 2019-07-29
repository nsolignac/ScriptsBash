#!/bin/bash

# SOURCE: https://dev.mysql.com/doc/mysql-replication-excerpt/5.7/en/replication-howto-mysqldump.html
# CFG TO FILE SOURCE: https://www.linode.com/docs/databases/mysql/use-mysqldump-to-back-up-mysql-or-mariadb/#automate-backups-with-cron
DBNAME='{NOMBRE DE LA DB}'
SVD='{IP SERVER DESTINO}'


USER='$(echo $USER)'

mysqldump -u$USER -p --opt --routines --triggers --events --single-transaction --no-tablespaces --master-data=2 --databases $DBNAME

gzip > $DBNAME.sql.gz

du -hs $DBNAME.sql.gz

scp $DBNAME.sql.gz $USER@$SVD:/tmp
