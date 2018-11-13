#!/bin/sh

env
LOCAL_CONFIG_DIR=/config/shibboleth
SHIBBOLETH_CONF_DIR=/etc/shibboleth

. shibboleth-setup-loader.sh
. initialise-shibboleth-config.sh

/usr/sbin/shibd -f -c /etc/shibboleth/shibboleth2.xml -p /var/run/shibboleth/shibd.pid -w 30
httpd-foreground