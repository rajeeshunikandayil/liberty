echo "Starting setup..."
#check if the type of install is found
if [[ ! -z "$1" ]] && [[ ! -z "$2" ]]; then 
    echo "Installing required java versions"
    ./ibm_java_install.sh
    echo "IBM java installed..."
    echo "---------------------"
    echo "Installing required utilities"
    ./ibm_yum_utilities_install.sh
    echo "Utilities installed"
    echo "---------------------"
    echo "Check if we are going to do a full setup of IHS and WLP or just one specific app"
    . ./ibm_setup_instances.sh $1 $2
    echo "$1 apps installed"
else 
    if [[ ! -z "$1" ]]; then 
        echo "Installing required java versions"
        ./ibm_java_install.sh
        echo "IBM java installed..."
        echo "---------------------"
        echo "Installing required utilities"
        ./ibm_yum_utilities_install.sh
        echo "Utilities installed"
        echo "---------------------"
        echo "Check if we are going to do a full setup of IHS and WLP or just one specific app"
        . ./ibm_setup_instances.sh $1
        echo "$1 apps installed"
    fi
fi


