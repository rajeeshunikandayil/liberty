echo "Adding nodes for virtual host proxies - $1"
python3.9 ../python/update_wlp_server_variables.py "$1" proxies
echo "Server xml for $1 virtual host nodes have been updated"