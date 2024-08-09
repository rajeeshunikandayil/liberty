#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <IHS Key DB password>"
    exit 1
fi

IHS_root=/opt/IBM/HTTPServer/IHS

# stop IHS
$IHS_root/bin/apachectl -k stop
echo "All IHS servers stopped."

# create key DB for SSL
$IHS_root/bin/gskcapicmd -keydb -create -db $IHS_root/conf/key.kdb -pw $1 -stash
echo "Key DB for SSL created."

# create self signed cert
host=$(hostname)
dn="cn=${host}"
$IHS_root/bin/gskcapicmd -cert -create -db $IHS_root/conf/key.kdb -stashed -label selfSignedCert -dn "$dn" -size 2048 -sigalg sha512WithRSA
echo "Self siged cert created."

# add SSL configs to httpd.conf
config="$IHS_root/conf/httpd.conf"
echo "LoadModule ibm_ssl_module modules/mod_ibm_ssl.so" >> "$config"
echo "Listen 9443" >> "$config"
echo "<VirtualHost *:9443>" >> "$config"
echo " ServerName $host" >> "$config"
echo " SSLEnable" >> "$config"
echo "</VirtualHost>" >> "$config"
echo "KeyFile $IHS_root/conf/key.kdb" >> "$config"
echo "Finished adding SSL configs to httpd.conf"

# start IHS
$IHS_root/bin/apachectl -k start -f $IHS_root/conf/httpd.conf
echo "IHS servers started."
