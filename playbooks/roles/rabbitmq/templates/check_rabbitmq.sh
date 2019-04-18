#!/bin/sh

# script for auto restart of RabbitMQ service then service hangs (faugh)
# please reffer - https://youtrack.raccoongang.com/issue/HARAMBEE-77

if ! test -x /etc/zabbix/scripts/check_rabbitmq.sh ; then
        echo "ERROR: zabbix 'check_rabbitmq.sh' script not installed" >&2
        echo "Please investigate!" >&2
        logger "$0: ERROR: zabbix 'check_rabbitmq.sh' script not installed"
        exit 1
fi
RANDOM=`od -An -N1 -i /dev/urandom | tr -d ' '`
sleep `expr 0${RANDOM} % 30`
STATUS=`/etc/zabbix/scripts/check_rabbitmq.sh status`
if test "${STATUS}" != "1"; then
        logger "$0: status=${STATUS} RabbitMQ is down, restarting..."
        systemctl restart rabbitmq-server
fi
