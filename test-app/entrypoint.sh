#!/bin/sh

echo "Environment:"
echo $MYSQL_DATABASE
echo $MYSQL_HOST
echo $MYSQL_PORT
echo $MYSQL_USER
echo $DATABASE
echo ""

if [ "$DATABASE" = "mysql" ]
then
    echo "Waiting for mysql..."

    while ! nc -z $MYSQL_HOST $MYSQL_PORT; do
      sleep 0.1
    done

    echo "MySQL started"
fi

exec gunicorn \
     --bind 0.0.0.0:10001 \
     --workers 5 \
     --log-level=info \
     wsgi:app \
     "$@"
