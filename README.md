# iocage-plugin-zoneminder

Artifact repo for iocage zoneminder plugin.

## SSL/TLS Settings
This version of the Zoneminder plugin allows for customisation of SSL/TLS options. It also automatically generates a self-signed SSL certificate and a private key during its first installation so that the initial connection can be secured. As this is a self-signed certificate it will cause _security warnings_ to be thrown by the browser. Ideally, you would provide your own certificate and key using the plugin settings to avoid the warnings, as soon as possible. The self-signed certificate will expire after 366 days.

A possible scheme to do that efficiently on a host such as FreeNAS is to copy a valid certificate and private key file from the host's `/etc/certificates/mycert.pem` into the plugin at `/mnt/YourDataset/iocage/jails/YourJail/root/usr/local/etc/ssl/mycert.pem` directory and specify `/usr/local/etc/ssl/mycert.pem` for the plug in to use. You need to do that for the private key, too. You can set-up a Tasks/Cron Job on the FreeNAS host to copy them regularly, especially if using an automated certificate renewal tool like ACME LetsEncrypt. This way there is no need for the plugin to have to manage its certificate renewal and you will achieve a reasonable level of network security.

Please note that the Manage admin UI defaults to HTTPS and its specified port if configured, but only upon installation.

### Settings
All the configurable settings are configured in settings.json. They are:
- `httpport`
- `httpsport`
- `sslcert`
- `sslkey`

Assuming your plugin jail is called "zoneminder" you can set them by calling something along the lines of:
```
iocage set -P httpport 8349 zoneminder
```
