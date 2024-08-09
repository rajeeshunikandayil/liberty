echo "Checking the base IBM directory is found"
if [ ! -d /opt/IBM ] ; then
    echo "Creating the base IBM directory"
    mkdir /opt/IBM
fi
echo "Checking if the WebSphere directory exists"
if [ ! -d /opt/IBM/WebSphere ] ; then
    echo "Creating the WebSphere directory"
    mkdir /opt/IBM/WebSphere
fi
echo "Checking if the WebSphere Liberty directory exists"
if [ ! -d /opt/IBM/WebSphere/Liberty ] ; then
    echo "Creating the Liberty directory"
    mkdir /opt/IBM/WebSphere/Liberty
fi
echo "Navigating to Liberty directory within IBM folder"
cd /opt/IBM/WebSphere/Liberty
if [ ! -d /opt/IBM/WebSphere/Liberty/wlp ] ; then
    if [ $1 == "web" ]; then
        echo "Downloading Websphere Liberty Profile"
        wget https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/24.0.0.2/wlp-webProfile8-java8-linux-x86_64-24.0.0.2.zip
        echo "WebSphere Liberty Profile downloaded...unpacking compressed file"
        unzip ./wlp-webProfile8-java8-linux-x86_64-24.0.0.2.zip
        echo "Websphere Liberty Profile downloaded and unpacked...deleting zip file"
        rm -rf ./wlp-webProfile8-java8-linux-x86_64-24.0.0.2.zip
        echo "IBM apps installation completed..."
    fi
    if [ $1 == "nd" ]; then
        echo "Downloading Websphere Liberty ND Profile"
        wget https://ak-delivery04-mul.dhe.ibm.com/sdfdl/v2/sar/CM/WS/0bvit/0/Xa.2/Xb.jusyLTSp44S04g_hTiqiDGOLwLLlbr6J6y00W4LJ6NMnITJJdggw5pY4PkA/Xc.CM/WS/0bvit/0/wlp-nd-all-23.0.0.12.jar/Xd./Xf.LPR.D1vk/Xg.12943978/Xi.habanero/XY.habanero/XZ.X6GlM-I-2xSaBb3wsdVBtr2HHS5UIyRP/XX.application/java-archive/wlp-nd-all-23.0.0.12.jar
        echo "WebSphere Liberty Profile ND Jar downloaded...executing jar file"
        /usr/lib/jvm/ibm-java-x86_64-80/jre/bin/java -jar ./wlp-nd-all-23.0.0.12.jar
        echo "Websphere Liberty Profile downloaded and executed...deleting jar file"
        rm -rf ./wlp-nd-all-23.0.0.12.jar
        echo "IBM apps installation completed..."
    fi
fi

