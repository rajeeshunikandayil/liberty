echo "Starting the update host process"
#echo "updateHost params - $1, $2, $3, $4, $5, $6"
collective updateHost "$1" --autoAcceptCertificates --host="$1" --port=$2 --user="$3" --password="$4" --hostReadPath="$WLP_USER_DIR/servers" --hostWritePath="$WLP_USER_DIR/servers" --rpcUser="$5" --rpcUserPassword="$6"
echo "Host updated"