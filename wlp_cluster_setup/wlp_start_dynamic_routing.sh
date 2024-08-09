#this flow will implement the dynamic routing
echo "Reading server installation json in prep for dynamic routing"
jq -c '.servers[]' ../servers.json | while read server; do
  #accumulate all required variables
  name=$(jq --raw-output '.name' <<< "$server")
  active=$(jq --raw-output '.active' <<< "$server")
  type=$(jq --raw-output '.type' <<< "$server")
  port=$(jq --raw-output '.https_port' <<< "$server")
  controller_user=$(jq --raw-output '.controller_username' <<< "$server")
  rpc_user=$(jq --raw-output '.rpc_user' <<< "$server")
  echo "Checking if the current selected server is a collector"
  if [ $active == true ] && [ $type == 'collector' ]; then
    host=$(echo $(python3.9 ../python/get_collector_host.py "$name"))
    echo "Checking if wlp plugin directory is found"
    if [ ! -d "/opt/IBM/HTTPServer_Plugins" ] ; then
        echo "Creating http server plugins directory"
        mkdir /opt/IBM/HTTPServer_Plugins
    fi
    echo "Implementing dynamic routing"
    ./wlp_add_dynamic_routing.sh $port "$host" "$controller_user" "$ENV_CONTROLLER_PASSWORD" "$ENV_KEYSTORE_PASSWORD"
    echo "Renaming completed configuration file..."
    mv plugin-cfg.xml plugin_cfg_"$host".xml
  fi
done