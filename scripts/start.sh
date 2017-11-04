#!/bin/bash

if [ "$(cat /root/billing/installed.txt)" != 1 ]
then
  echo "1" > /root/billing/installed.txt
  cp /usr/local/billing/billing.conf /root/billing/conf/
  cp /usr/local/billing/lbcore.log /root/billing/logs/
fi
exec "$@"
