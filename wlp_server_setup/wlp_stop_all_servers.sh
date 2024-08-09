echo "Reading server installation json"
#transform the file to make sure it is clean 

jq -c '.servers[]' ../servers.json | while read server; do
  #accumulate all required variables
  name=$(jq --raw-output '.name' <<< "$server")
  echo "Stopping server - $name"
  ./wlp_stop_server.sh "$name"
  echo "Removing server directory"
  rm -rf $WLP_USER_DIR/servers/$name
done 