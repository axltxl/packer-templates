#!/bin/bash

YUM_CRON_FILE=/etc/yum/yum-cron.conf

#
#
#
yum -y install yum-cron

#
#
#
mv /tmp/yum-cron.conf $YUM_CRON_FILE
chown root:root $YUM_CRON_FILE
chmod 644 $YUM_CRON_FILE