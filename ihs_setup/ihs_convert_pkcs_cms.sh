#this flow will implement the pkcs12 conversion
echo "Converting default plugin keystore"
gskcmd -keydb -convert -pw "$ENV_KEYSTORE_PASSWORD" -db /opt/IBM/HTTPServer/IHS/plugin/config/webserver1/plugin-key.p12 -old_format pkcs12 -target /opt/IBM/HTTPServer/IHS/plugin/config/webserver1/plugin-key.kdb -new_format cms -stash
gskcmd -cert -setdefault -pw "$ENV_KEYSTORE_PASSWORD" -db /opt/IBM/HTTPServer/IHS/plugin/config/webserver1/plugin-key.kdb -label default

