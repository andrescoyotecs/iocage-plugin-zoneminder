#!/bin/sh
logger -t pluginrcset "Setting $1 to $2"
sysrc -f /etc/rc.conf -n "plugin_$1=$2"
