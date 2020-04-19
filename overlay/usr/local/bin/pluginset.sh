#!/bin/sh
logger -t pluginset "Setting $1 to $2"

# Set configuration settings directly to the config files.

case $1 in
    httpport)
        # Delete non-ssl listen lines
        sed -E -i '' -e '/listen[[:blank:]]*[[:digit:]]+[[:blank:]]*;/Id;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        # Insert a new listen directive
        sed -E -i '' -e "/server[[:blank:]]+{/Ia \\
    listen $2;" \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        ;;
    httpsport)
        # Delete ssl listen lines
        sed -E -i '' -e '/listen[[:blank:]]*[[:digit:]]+[[:blank:]]*ssl[[:blank:]]*;/Id;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        # Insert a new listen directive
        sed -E -i '' -e "/server[[:blank:]]+{/Ia \\
    listen $2 ssl;" \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        ;;
    sslcert)
        # Delete all ssl_certificate lines
        sed -E -i '' -e '/ssl_certificate[[:blank:]]+.*;/Id;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        # Insert a new ssl_certificate line
        sed -E -i '' -e "/server[[:blank:]]+{/Ia \\
    ssl_certificate $2;" \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        ;;
    sslkey)
        # Delete all ssl_certificate_key lines
        sed -E -i '' -e '/ssl_certificate_key[[:blank:]]+.*;/Id;' \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        # Insert a new ssl_certificate_key line
        sed -E -i '' -e "/server[[:blank:]]+{/Ia \\
    ssl_certificate_key $2;" \
            /usr/local/etc/nginx/conf.d/zoneminder.conf
        ;;
    *)
        echo "Unknown option">&2
        exit 1
        ;;
esac
