#this flow will implement the cluster controller
echo "Reading server installation json"
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
    #grab the collector host value and set it
    host=$(echo $(python3.9 ../python/get_collector_host.py "$name"))
    echo "Found collector...updating host variable with $host"
    jq -c '.servers[]' ../servers.json | while read server; do
        #accumulate all required variables
        name=$(jq --raw-output '.name' <<< "$server")
        active=$(jq --raw-output '.active' <<< "$server")
        type=$(jq --raw-output '.type' <<< "$server")
        echo "Checking if the current selected server is a member"
        if [ $active == true ] && [ $type == 'member' ]; then
            echo "Removing member..."
            ./wlp_remove_collective_member.sh "$name" "$host" $port "$controller_user" "$ENV_CONTROLLER_PASSWORD"
        fi
    done
    ./wlp_update_host.sh "$host" $port "$controller_user" "$ENV_CONTROLLER_PASSWORD" "$rpc_user" "$ENV_RPC_USER_PASSWORD"
  fi
done