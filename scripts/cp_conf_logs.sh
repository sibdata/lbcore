#!/bin/bash
cp /usr/local/billing/billing.conf /root/billing/conf
cp /usr/local/billing/lbcore.log /root/billing/logs
exec "$@"
