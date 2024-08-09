#init features installation for wlp 
echo "Installing features"
#./wlp_features_install.sh

#this flow will implement the cluster controller
echo "Reading server installation json in prep for cluster member creation"
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
    #echo "Checking to see if host ($host) has been registered in collective"
    #./wlp_register_host.sh "$host" $port "$controller_user" "$ENV_CONTROLLER_PASSWORD"
    #grab the collector host value and set it
    #get the collector host assigned host name 
    host=$(echo $(python3.9 ../python/get_collector_host.py "$name"))
    echo "Found collector...updating host variable with $host"
    jq -c '.servers[]' ../servers.json | while read member; do
        #accumulate all required variables
        member_name=$(jq --raw-output '.name' <<< "$member")
        member_active=$(jq --raw-output '.active' <<< "$member")
        member_type=$(jq --raw-output '.type' <<< "$member")
        echo "Checking if the current selected server is a member"
        if [ $member_active == true ] && [ $member_type == 'member' ]; then
            echo "Binding member to $host in collective"
            #join the server into the collective 
            ./wlp_join_collective_member.sh "$member_name" "$host" $port "$controller_user" "$ENV_CONTROLLER_PASSWORD" "$ENV_KEYSTORE_PASSWORD"
            echo "Restarting member server..."
            ../wlp_server_setup/wlp_recycle_server.sh "$member_name"
        fi
    done
    #update the host 
    ./wlp_update_host.sh "$host" $port "$controller_user" "$ENV_CONTROLLER_PASSWORD" "$rpc_user" "$ENV_RPC_USER_PASSWORD"
  fi
done
