echo "Checking the base IBM directory is found"
if [ ! -d /opt/IBM ] ; then
    echo "Creating the base IBM directory"
    mkdir /opt/IBM
fi
echo "Checking for the plugins directory"
if [ ! -d /opt/IBM/Plugins ] ; then
    echo "Creating the WLP plugins directory"
    mkdir /opt/IBM/Plugins
fi
echo "Checking if the HTTPServer directory exists"
if [ ! -d /opt/IBM/HTTPServer ] ; then
    echo "Creating the HTTPServer directory"
    mkdir /opt/IBM/HTTPServer
fi
echo "Switching to the HTTP Server directory..."
cd /opt/IBM/HTTPServer
if [ ! -d /opt/IBM/HTTPServer/IHS ] ; then
    echo "Downloading IBM HTTP Server"
    wget https://ak-delivery04-mul.dhe.ibm.com/sdfdl/v2/sar/CM/WS/0bv0e/0/Xa.2/Xb.jusyLTSp44S04g_hyyciCrPjDiGQSx9ZcXMfRagGwvZmYWh_2Gbx6g1jdx8/Xc.CM/WS/0bv0e/0/9.0.5-WS-IHS-ARCHIVE-linux-x86_64-FP018.zip/Xd./Xf.LPR.D1vk/Xg.12945196/Xi.habanero/XY.habanero/XZ.z96bSneZY9oZvBCl9VIEMt1n-6DsD2JR/9.0.5-WS-IHS-ARCHIVE-linux-x86_64-FP018.zip
    echo "HTTP Server downloaded...unpacking compressed file"
    unzip 9.0.5-WS-IHS-ARCHIVE-linux-x86_64-FP018.zip
    echo "Deleting zip file"
    rm -rf 9.0.5-WS-IHS-ARCHIVE-linux-x86_64-FP018.zip
    echo "Running IHS post install..."
    cd ./IHS
    chmod a+x ./postinstall.sh
    ./postinstall.sh
    echo "IBM apps installation completed..."
fi
