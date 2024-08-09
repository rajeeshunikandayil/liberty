echo "Updating yum"
yum update
echo "Yum updated"
echo "Setting up pre-requisites for Python 3.9"
dnf install wget yum-utils make gcc openssl-devel bzip2-devel libffi-devel zlib-devel 
echo "Pre-requisites completed...downloading Python 3.9"
wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz 
echo "Python 3.9 archive downloaded...extracting tar"
tar xzf Python-3.9.16.tgz 
echo "Configuring python installation..."
cd Python-3.9.16
./configure --with-system-ffi --with-computed-gotos --enable-loadable-sqlite-extensions
make -j ${nproc}
make altinstall
echo "Python 3.9 has been installed. Clearing out install files"
cd ..
rm -rf Python-3.9.16
rm Python-3.9.16.tgz
echo python3.9 -V
echo pip3.9 -V