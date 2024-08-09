echo "Creating java jvm directory..."
echo "Checking if we have already installed java jre/sdk"
if [ ! -d /usr/lib/jvm/ibm-java-x86_64-80 ] ; then
    echo "Checking if usr/lib/jvm directory exists"
    if [ ! -d /usr ] ; then
        mkdir /usr
    fi
    if [ ! -d /usr/lib ] ; then
        mkdir /usr/lib
    fi
    if [ ! -d /usr/lib/jvm ] ; then
        mkdir /usr/lib/jvm
    fi
    echo "Switching to jvm directory"
    cd /usr/lib/jvm
    echo "Downloading IBM Java JDK/JRE..."
    wget https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/8.0.8.21/linux/x86_64/ibm-java-sdk-8.0-8.21-linux-x86_64.tgz
    echo "IBM Java JDK/JRE downloaded...unpacking gz file"
    tar -xvzf ibm-java-sdk-8.0-8.21-linux-x86_64.tgz
    echo "IBM Java JDK/JRE tgz file unpacked....deleting file"
    rm -rf ./ibm-java-sdk-8.0-8.21-linux-x86_64.tgz
    echo "IBM Java JDK/JRE installed"
fi

