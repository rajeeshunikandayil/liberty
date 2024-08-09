echo "Cluster combining script launching..."
PLUGINS="/opt/IBM/Plugins"
if [ -d "$PLUGINS" ] ; then
    echo "Grouping clusters within plugin-cfg.xml"
    python3.9 ../python/collector_configuration_helper.py "$PLUGINS"
    echo "The file plugin-cfg.xml was created...converting all pkcs keystores to cms libraries"
    echo "Iterating through all pkcs files"
    for FILE in "$PLUGINS"/* ; do
        #check if the file variable is a p12
        PKCS=".p12"
        if [[ "$FILE" == *"$PKCS"* ]]; then
            #IFS="."
            #read -ra file_segments <<< "$FILE"
            #remove the last part of the file string 
            truncated_file=${FILE:0:-4}
            #check if the kdb file already exists 
            if [ -d "$truncated_file".kdb ]; then
                #delete the old file 
                rm "$truncated_file".kdb
                echo "Old kdb file deleted"
            fi
            gskcmd -keydb -convert -pw "$ENV_KEYSTORE_PASSWORD" -db "$FILE" -old_format pkcs12 -target "$truncated_file".kdb -new_format cms -stash
            gskcmd -cert -setdefault -pw "$ENV_KEYSTORE_PASSWORD" -db "$truncated_file".kdb -label default
        fi
    done
fi
echo "Cluster combining completed"



