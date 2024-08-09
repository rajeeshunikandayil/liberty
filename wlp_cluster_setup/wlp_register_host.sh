echo "Registering host $1"
collective registerHost --autoAcceptCertificates --host="$1" --port=$2 --user="$3" --password="$4"
echo "Host registered"