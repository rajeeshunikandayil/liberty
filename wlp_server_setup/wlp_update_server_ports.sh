echo "Updating server ports for - $1"
python3.9 ../python/update_wlp_server_variables.py "$1" ports $2 $3
echo "Server xml for $1 has been updated"