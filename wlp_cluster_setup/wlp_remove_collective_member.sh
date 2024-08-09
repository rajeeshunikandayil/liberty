echo "Removing member - $1"
collective remove "$1" --autoAcceptCertificates --host="$2" --port=$3 --user="$4" --password="$5"
echo "Removing include nodes within server.xml"
python3.9 ../python/update_wlp_server_variables.py $1 member leave
echo "Member removed"