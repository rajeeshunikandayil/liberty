#init features installation for wlp 
echo "Installing features"
#./wlp_features_install.sh

#this flow will implement the cluster controller
echo "Reading server installation json for cluster setup"
jq -c '.servers[]' ../servers.json | while read server; do
  #accumulate all required variables
  name=$(jq --raw-output '.name' <<< "$server")
  active=$(jq --raw-output '.active' <<< "$server")
  type=$(jq --raw-output '.type' <<< "$server")
  controller_username=$(jq --raw-output '.controller_username' <<< "$server")
  echo "Checking if the current selected server is a collector"
  if [ $active == true ] && [ $type == 'collector' ]; then
    echo "Found collector value in servers.json. Creating a WLP collector..."
    ./wlp_create_collective_controller.sh "$name" "$ENV_KEYSTORE_PASSWORD"
    echo "Updating collector controller security"
    ./wlp_update_collector_security.sh "$name" "$controller_username" "$ENV_CONTROLLER_PASSWORD"
    echo "Updating cluster collector features within server.xml"
    ./wlp_update_controller_features.sh "$name"
    echo "Recycling controller - $name"
    ../wlp_server_setup/wlp_recycle_server.sh "$name"
  fi
done