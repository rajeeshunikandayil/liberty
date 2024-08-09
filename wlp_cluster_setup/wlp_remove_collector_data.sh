echo "Removing collector resource files"
rm -rf /opt/IBM/WebSphere/Liberty/wlp/usr/servers/$1/resources/collective/*
echo "Collector data removed. Removing controller.xml and controller nodes from server.xml"
python3.9 ../python/update_wlp_server_variables.py "$1" controller remove
echo "Controller nodes removed from server.xml...next, deleting controller.xml"
rm -rf /opt/IBM/WebSphere/Liberty/wlp/usr/servers/$1/controller.xml
echo "Collective controller.xml was deleted"