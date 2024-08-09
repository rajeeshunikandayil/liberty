echo "Create controller for $1"
collective create $1 --keystorePassword=$2 --createConfigFile=$WLP_USER_DIR/servers/$1/controller.xml
echo "Updating controller configuration file within server.xml"
python3.9 ../python/update_wlp_server_variables.py $1 controller add
echo "Controller element added to server.xml"