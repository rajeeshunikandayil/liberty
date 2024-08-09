echo "Controller configuration updated"
echo "Updating userid and password within collector"
python3.9 ../python/update_wlp_server_variables.py $1 controller $2 $3
echo "Security updated within controller"
