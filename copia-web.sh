#!/bin/bash

# script para copiar webs con BD MySQL
# 0.1 160517 version inicial
# 0.2 160523 soporte wordpress com BD automatica
# 0.3 160523 si no se especifica el segundo parametro, comprueba si es un wordpress
# 0.3.1 160524 solucionado bug en el grep del wp-config.php

WEBROOT='/var/www/htdocs'
DIRCOPIAS='/root/copias-web'
FICHNAME=$1-`date +%y%m%d`-`date +%R`
DBNAME='nodb'
MYPASS='mypass'

## Colores
AZUL='\033[0;34m'
PURPLE='\033[0;35m'
VERDE='\033[0;32m'
RESETCOLOR='\033[0m'

echo -e "$VERDE\nComprimiendo web $PURPLE$FICHNAME.tgz $VERDE..."
tar -C $WEBROOT -czf $DIRCOPIAS/$FICHNAME.tgz $1

if [ -z $2 ]
then   # Si es un wordpress averiguar el nombre de la BD del wp-config.php
   if [ -f $WEBROOT/$1/wp-config.php ]
   then
      echo -e "Es un WordPress."
      DBNAME=`grep 'DB_NAME' $WEBROOT/$1/wp-config.php |cut -d "'" -f 4`
   else
      echo -e "No es un WordPress. No se copia la BD porque no se ha especificado."
   fi
else
   echo -e "Se copia la BD especificada."
   DBNAME=$2
fi

if [ "$DBNAME" != "nodb" ]
then
   echo -e "Comprimiendo BD  $PURPLE$FICHNAME-$DBNAME.sql.gz $VERDE..."
   mysqldump -p$MYPASS --opt $DBNAME |gzip -c > $DIRCOPIAS/$FICHNAME-$DBNAME.sql.gz
fi

echo -e "$VERDE\nFicheros resultado:\n$AZUL"
ls -lh $DIRCOPIAS/$FICHNAME*
echo -e "$RESETCOLOR"
