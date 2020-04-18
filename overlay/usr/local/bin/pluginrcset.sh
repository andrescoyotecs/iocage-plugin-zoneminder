#!/bin/sh
sysrc -f /etc/rc.conf -n "plugin_$1=$2"
