#init JAVA_HOME setup
JAVA_HOME="/usr/lib/jvm/ibm-java-x86_64-80/jre"
export JAVA_HOME
echo "Setting JAVA_HOME"
if grep "JAVA_HOME" ~/.bashrc; then
    echo "JAVA_HOME is already set in .bashrc"
else
    # If not set, append it to .bashrc
    echo "JAVA_HOME=/usr/lib/jvm/ibm-java-x86_64-80/jre" >> ~/.bashrc
    echo "export JAVA_HOME" >> ~/.bashrc
    echo "JAVA_HOME is set in .bashrc"
fi

#check what type of app we are going to install
if [ $1 == "all" ]; then 
    #start setting up bash variables for ihs
    echo "Setting IHS bin into path of .bashrc"
    IHS_BIN_DIR="/opt/IBM/HTTPServer/IHS/bin"
    if [[ ":$PATH:" != *":$IHS_BIN_DIR:"* ]]; then
        # If IHS_BIN_DIR not yet in PATH, add it
        export PATH="$IHS_BIN_DIR:$PATH"
        echo "Added IHS bin to PATH."
        echo "PATH=\"$IHS_BIN_DIR:\$PATH\"" >> ~/.bashrc
        echo "export PATH" >> ~/.bashrc
        echo "Added IHS bin to PATH in .bashrc"    
    else
        echo "IHS bin is already in PATH."
    fi
    #start setting up bash variables for wlp
    echo "Setting WLP_USER_DIR bin into path of .bashrc"
    WLP_USER_DIR="/opt/IBM/WebSphere/Liberty/wlp/usr"
    export WLP_USER_DIR
    echo "Setting WLP_USER_DIR"
    if grep "WLP_USER_DIR" ~/.bashrc; then
        echo "WLP_USER_DIR is already set in .bashrc"
    else
        # If not set, append it to .bashrc
        echo "WLP_USER_DIR=/opt/IBM/WebSphere/Liberty/wlp/usr" >> ~/.bashrc
        echo "export WLP_USER_DIR" >> ~/.bashrc
        echo "WLP_USER_DIR is set in .bashrc"
    fi
    echo "Setting Liberty bin into path of .bashrc"
    WLP_BIN_DIR="/opt/IBM/WebSphere/Liberty/wlp/bin"
    export WLP_BIN_DIR
    if [[ ":$PATH:" != *":$WLP_BIN_DIR:"* ]]; then
        # If WLP_BIN_DIR not yet in PATH, add it
        export PATH="$WLP_BIN_DIR:$PATH"
        echo "Added WLP bin to PATH."
        echo "PATH=\"$WLP_BIN_DIR:\$PATH\"" >> ~/.bashrc
        echo "export PATH" >> ~/.bashrc
        echo "Added WLP bin to PATH in .bashrc"    
    else
        echo "WLP bin is already in PATH."
    fi
    echo "Setting KEYTOOL bin into path of .bashrc"
    KEYTOOL_BIN_DIR="/usr/lib/jvm/ibm-java-x86_64-80/bin"
    export KEYTOOL_BIN_DIR
    if [[ ":$PATH:" != *":$KEYTOOL_BIN_DIR:"* ]]; then
        # If WLP_BIN_DIR not yet in PATH, add it
        export PATH="$KEYTOOL_BIN_DIR:$PATH"
        echo "Added KEYTOOL_BIN_DIR bin to PATH."
        echo "PATH=\"$KEYTOOL_BIN_DIR:\$PATH\"" >> ~/.bashrc
        echo "export PATH" >> ~/.bashrc
        echo "Added KEYTOOL_BIN_DIR bin to PATH in .bashrc"    
    else
        echo "KEYTOOL_BIN_DIR bin is already in PATH."
    fi
    #check for the existence of the various passwords
    if grep "ENV_CONTROLLER_PASSWORD" ~/.bashrc && grep "ENV_KEYSTORE_PASSWORD" ~/.bashrc && grep "ENV_RPC_USER_PASSWORD" ~/.bashrc; then
        echo "Password variables in .bashrc already"
    else
        # If not set, append it to .bashrc
        echo "ENV_CONTROLLER_PASSWORD=" >> ~/.bashrc
        echo "export ENV_CONTROLLER_PASSWORD" >> ~/.bashrc
        echo "ENV_KEYSTORE_PASSWORD=" >> ~/.bashrc
        echo "export ENV_KEYSTORE_PASSWORD" >> ~/.bashrc
        echo "ENV_RPC_USER_PASSWORD=" >> ~/.bashrc
        echo "export ENV_RPC_USER_PASSWORD" >> ~/.bashrc
        echo "Password variables setup in .bashrc"
    fi
fi
if [ $1 == "wlp" ]; then 
    #start setting up bash variables
    WLP_USER_DIR="/opt/IBM/WebSphere/Liberty/wlp/usr"
    export WLP_USER_DIR
    echo "Setting WLP_USER_DIR"
    if grep "WLP_USER_DIR" ~/.bashrc; then
        echo "WLP_USER_DIR is already set in .bashrc"
    else
        # If not set, append it to .bashrc
        echo "WLP_USER_DIR=/opt/IBM/WebSphere/Liberty/wlp/usr" >> ~/.bashrc
        echo "export WLP_USER_DIR" >> ~/.bashrc
        echo "WLP_USER_DIR is set in .bashrc"
    fi
    WLP_BIN_DIR="/opt/IBM/WebSphere/Liberty/wlp/bin"
    if [[ ":$PATH:" != *":$WLP_BIN_DIR:"* ]]; then
        # If WLP_BIN_DIR not yet in PATH, add it
        export PATH="$WLP_BIN_DIR:$PATH"
        echo "Added WLP bin to PATH."
        echo "PATH=\"$WLP_BIN_DIR:\$PATH\"" >> ~/.bashrc
        echo "export PATH" >> ~/.bashrc
        echo "Added WLP bin to PATH in .bashrc"    
    else
        echo "WLP bin is already in PATH."
    fi
    echo "Setting KEYTOOL bin into path of .bashrc"
    KEYTOOL_BIN_DIR="/usr/lib/jvm/ibm-java-x86_64-80/bin"
    export KEYTOOL_BIN_DIR
    if [[ ":$PATH:" != *":$KEYTOOL_BIN_DIR:"* ]]; then
        # If WLP_BIN_DIR not yet in PATH, add it
        export PATH="$KEYTOOL_BIN_DIR:$PATH"
        echo "Added KEYTOOL_BIN_DIR bin to PATH."
        echo "PATH=\"$KEYTOOL_BIN_DIR:\$PATH\"" >> ~/.bashrc
        echo "export PATH" >> ~/.bashrc
        echo "Added KEYTOOL_BIN_DIR bin to PATH in .bashrc"    
    else
        echo "KEYTOOL_BIN_DIR bin is already in PATH."
    fi
    #check for the existence of the various passwords
    if grep "ENV_CONTROLLER_PASSWORD" ~/.bashrc && grep "ENV_KEYSTORE_PASSWORD" ~/.bashrc && grep "ENV_RPC_USER_PASSWORD" ~/.bashrc; then
        echo "Password variables in .bashrc already"
    else
        # If not set, append it to .bashrc
        echo "ENV_CONTROLLER_PASSWORD=" >> ~/.bashrc
        echo "export ENV_CONTROLLER_PASSWORD" >> ~/.bashrc
        echo "ENV_KEYSTORE_PASSWORD=" >> ~/.bashrc
        echo "export ENV_KEYSTORE_PASSWORD" >> ~/.bashrc
        echo "ENV_RPC_USER_PASSWORD=" >> ~/.bashrc
        echo "export ENV_RPC_USER_PASSWORD" >> ~/.bashrc
        echo "Password variables setup in .bashrc"
    fi
fi
if [ $1 == "ihs" ]; then 
    echo "Setting IHS bin into path of .bashrc"
    IHS_BIN_DIR="/opt/IBM/HTTPServer/IHS/bin"
    if [[ ":$PATH:" != *":$IHS_BIN_DIR:"* ]]; then
        # If IHS_BIN_DIR not yet in PATH, add it
        export PATH="$IHS_BIN_DIR:$PATH"
        echo "Added IHS bin to PATH."
        echo "PATH=\"$IHS_BIN_DIR:\$PATH\"" >> ~/.bashrc
        echo "export PATH" >> ~/.bashrc
        echo "Added IHS bin to PATH in .bashrc"    
    else
        echo "IHS bin is already in PATH."
    fi
    #check for the existence of the various passwords
    if grep "ENV_KEYSTORE_PASSWORD" ~/.bashrc; then
        echo "Password variables in .bashrc already"
    else
        # If not set, append it to .bashrc
        echo "ENV_KEYSTORE_PASSWORD=" >> ~/.bashrc
        echo "export ENV_KEYSTORE_PASSWORD" >> ~/.bashrc
        echo "Password variables setup in .bashrc"
    fi
fi
