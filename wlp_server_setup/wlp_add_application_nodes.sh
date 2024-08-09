echo "Updating member server.xml with applicatin nodes - $1"
python3.9 ../python/update_wlp_server_variables.py "$1" applications
echo "Server xml for $1 application nodes have been updated"