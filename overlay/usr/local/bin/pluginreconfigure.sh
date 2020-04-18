#!/bin/sh
set -x

# Reconfigures nginx zoneminder config file then restarts nginx
# Settings used: httpport, httpsport, sslcert, sslkey, ssloption
# Settings adminport and adminprotocol are only used in ui.json

httpport=/usr/local/bin/pluginrcget.sh httpport
httpsport=/usr/local/bin/pluginrcget.sh httpsport
sslcert=/usr/local/bin/pluginrcget.sh sslcert
sslkey=/usr/local/bin/pluginrcget.sh sslkey
ssloption=/usr/local/bin/pluginrcget.sh ssloption

# Remove prior config
sed -E -i '' -e '/listen/Id; /ssl_certificate/Id;' \
    /usr/local/etc/nginx/conf.d/zoneminder.conf

if [ "$ssloption" = "tlsdisable" -o "$ssloption" = "tlsallow" ]; then
    sed -E -i '' -e "/server/Ia \
    listen $httpport;" \
        /usr/local/etc/nginx/conf.d/zoneminder.conf
fi

if [ "$ssloption" = "tlsrequire" -o "$ssloption" = "tlsallow" ]; then
    if [ -e "$sslcert" -a -e "$sslkey" ]; then
        sed -E -i '' -e "/server/Ia \
    listen $httpsport ssl;
    ssl_certificate $sslcert;
    ssl_certificate_key $sslkey;" \
            /usr/local/etc/nginx/conf.d/zoneminder.conf

    else
        echo "Incorrect settings: SSL requested but no certificate or key files present"
        exit 1
    fi
fi

service nginx restart
