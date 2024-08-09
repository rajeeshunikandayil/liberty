echo "Joining $1 to collective"
collective join $1 --autoAcceptCertificates --host=$2 --port=$3 --user=$4 --password=$5 --keystorePassword=$6 --createConfigFile=$WLP_USER_DIR/servers/$1/$1_include.xml
echo "Joined $1 to collective...adding member include to server.xml"
python3.9 ../python/update_wlp_server_variables.py $1 member join
echo "Include node added to server.xml for $1...updating include xml"

