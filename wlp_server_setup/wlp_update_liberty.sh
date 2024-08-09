#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <Liberty zip URL. ex. https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/24.0.0.2/wlp-webProfile8-java8-linux-x86_64-24.0.0.2.zip>"
    exit 1
fi

cd /opt

liberty_root=/opt/IBM/WebSphere/Liberty

# stop all started servers
started_servers=$(ps -ef | grep "ws-server.jar" | grep -v grep | awk '{print $NF}')

for server in $started_servers; do
  $liberty_root/wlp/bin/server stop $server
done

echo "All Liberty servers stopped."

echo "backup existing Liberty install"
liberty_backup_dir=wlp_Backup_$(date '+%Y_%m_%d_%H_%M_%S')
mv $liberty_root/wlp $liberty_root/$liberty_backup_dir

echo "Downloading Websphere Liberty Profile"
url=$1
cd $liberty_root
wget $url

echo "WebSphere Liberty Profile downloaded...unpacking compressed file"
unzip ${url##*/}
echo "Websphere Liberty Profile downloaded and unpacked"
echo "Deleting zip file"
rm -rf ${url##*/}

echo "Copy usr directory from liberty backup to new install"
cp -r $liberty_root/$liberty_backup_dir/usr $liberty_root/wlp/
