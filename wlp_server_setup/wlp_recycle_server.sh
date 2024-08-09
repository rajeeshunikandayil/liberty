echo "Restarting server - $1"
server stop $1
echo "$1 stopped"
server start $1 --clean
echo "$1 restarted"