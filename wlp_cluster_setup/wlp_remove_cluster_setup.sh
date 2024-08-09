#this flow will implement the cluster controller
echo "Reading server installation json for cluster removal"
jq -c '.servers[]' ../servers.json | while read server; do
  #accumulate all required variables
  name=$(jq --raw-output '.name' <<< "$server")
  active=$(jq --raw-output '.active' <<< "$server")
  type=$(jq --raw-output '.type' <<< "$server")
  controller_username=$(jq --raw-output '.controller_username' <<< "$server")
  echo "Checking if the current selected server is a collector"
  if [ $active == true ] && [ $type == 'collector' ]; then
    echo "Found collector value in servers.json. Removing collector data...."
    ./wlp_remove_collector_data.sh "$name"
  fi
done