#!/bin/sh
logger -t pluginrcget "Reading $1"
sysrc -f /etc/rc.conf -n "plugin_$1"
