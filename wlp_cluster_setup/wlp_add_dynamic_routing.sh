echo "Creating dynamic routing to be used for IHS"
dynamicRouting setup --port=$1 --host=$2 --autoAcceptCertificates --user=$3 --password=$4 --keystorePassword=$5 --pluginInstallRoot=/opt/IBM/HTTPServer/IHS/plugin --webServerNames=webserver1
echo "Dynamic routing created"