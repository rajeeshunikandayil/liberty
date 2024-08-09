echo "Reading server installation json"
#transform the file to make sure it is clean 

#init features installation for wlp 
echo "Installing features"
./wlp_features_install.sh

jq -c '.servers[]' ../servers.json | while read server; do
  #accumulate all required variables
  name=$(jq --raw-output '.name' <<< "$server")
  active=$(jq --raw-output '.active' <<< "$server")
  type=$(jq --raw-output '.type' <<< "$server")
  apps=$(jq --raw-output '.apps[]' <<< "$server")
  http=$(jq --raw-output '.http_port' <<< "$server")
  https=$(jq --raw-output '.https_port' <<< "$server")
  echo "Check if we need to install or uninstall a server"
  if [ $active == true ]; then
    echo "looks like we need to install...checking to see if the server already exists - $WLP_USER_DIR/servers/$name"
    if [ ! -d "$WLP_USER_DIR/servers/$name" ] ; then
        echo "Creating server - $name"
        ./wlp_create_server.sh "$name"
        echo "Updating http and https ports"
        ./wlp_update_server_ports.sh "$name" "$http" "$https"
        echo "Updating server features within server.xml - applicable"
        if [ "$type" == "member" ]; then 
          echo "Installing member features into $name"
          ./wlp_update_member_features.sh "$name"
        fi
    fi
    echo "Checking if there are apps needed for installation within $name"
    if [[ $(jq '.apps[] | length' <<< "$server") > 0 ]]; then
      echo "Found a list of apps to install"
      for a in "${apps[@]}"; do
        #get the variables from the json object
        paths=$(jq --raw-output '.path' <<< "$apps[$a]")
        files=$(jq --raw-output '.file' <<< "$apps[$a]")
        while IDS= read -r file; do
          if test -f "$file"; then
            echo "It appears that the file exists...copying file to apps directory of $name"
            cp "$file" "$WLP_USER_DIR/servers/$name/apps"
          fi
        done <<<"$files"
      done
      echo "Updating application nodes"
      ./wlp_add_application_nodes.sh "$name"
      ./wlp_add_virtual_host_nodes.sh "$name"
    fi
    echo "Re-starting server - $name"
    ./wlp_recycle_server.sh "$name"
  else
    echo "look like we need to remove...stopping server"
    ./wlp_stop_server.sh "$name"
    echo "Removing server directory"
    rm -rf $WLP_USER_DIR/servers/$name
  fi
done