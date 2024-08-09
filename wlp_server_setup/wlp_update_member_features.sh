echo "Updating member server.xml with cluster required features - $1"
python3.9 ../python/update_wlp_server_variables.py "$1" features member
echo "Server xml for $1 has been updated"