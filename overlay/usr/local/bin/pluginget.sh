#!/bin/sh

# Get configuration settings directly from config files, some recursively.

case $1 in
    httpport)
        # If multiple non-SSL ports are configured, return the first one only
        sed -En -e '/listen/Is/.*listen[[:blank:]]*([[:digit:]]+)[[:blank:]]*;.*/\1/Ip;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf | head -n 1
        ;;
    httpsport)
        # If multiple SSL ports are configured, return the first one only
        sed -En -e '/listen/Is/.*listen[[:blank:]]*([[:digit:]]+)[[:blank:]]*ssl[[:blank:]]*;.*/\1/Ip;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf | head -n 1
        ;;
    sslcert)
        # If multiple certificates have been set, return the last one
        sed -En -e '/ssl_certificate/Is/.*ssl_certificate[[:blank:]]*([^; ]+)[[:blank:]]*;.*/\1/Ip;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf | tail -n 1
        ;;
    sslkey)
        # If multiple private key files have been set, return the last one
        sed -En -e '/ssl_certificate_key/Is/.*ssl_certificate_key[[:blank:]]*([^; ]+)[[:blank:]]*;.*/\1/Ip;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf | tail -n 1
        ;;
    adminprotocol)
        if [ "$(pluginget.sh httpsport)" -a -e "$(pluginget.sh sslcert)" -a -e "$(pluginget.sh sslkey)" ]; then
            echo "https"
        else
            echo "http"
        fi
        ;;
    adminport)
	# Return :port_number only if the port is non-default, ie. not 80 or 443 for the
	# respective protocol (http or https)
	# Please note, using printf to avoid adding a newline as per iocage 1.2 bug, see
	# https://github.com/iocage/iocage/issues/1163
        if [ "$(pluginget.sh httpsport)" -a -e "$(pluginget.sh sslcert)" -a -e "$(pluginget.sh sslkey)" ]; then
            if [ ! "$(pluginget.sh httpsport)" = "443" ]; then
                echo ":$(pluginget.sh httpsport)"
            fi
        else
            if [ ! "$(pluginget.sh httpport)" = "80" ]; then
                echo ":$(pluginget.sh httpport)"
            fi
        fi
        ;;
    *)
        echo "Unknown option">&2
        exit 1
        ;;
esac
