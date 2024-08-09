echo "Starting install process for $1"
#check what type of app we are going to install
if [ $1 == "all" ] && [[ ! -z "$2" ]]; then 
    echo "Installing all app instances"
    . ./ibm_install_apps.sh $2
else 
    if [ $1 == "web" ] || [ $1 == "nd" ]; then 
    echo "Installing wlp instance"
    . ./ibm_install_wlp.sh $1
    fi
    if [ $1 == "ihs" ]; then 
        echo "Installing wlp instance"
        . ./ibm_install_ihs.sh
    fi
fi
echo "Setup completed"