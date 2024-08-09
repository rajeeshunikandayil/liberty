echo "Installing collectiveController-1.0 in wlp"
featureManager install collectiveController-1.0 --when-file-exists=ignore
installUtility install collectiveController-1.0
echo "collectiveController-1.0 installed"

echo "Installing collectiveMember-1.0 in wlp"
featureManager install collectiveMember-1.0 --when-file-exists=ignore
installUtility install collectiveMember-1.0
echo "collectiveMember-1.0 installed"

echo "Installing clusterMember-1.0 in wlp"
featureManager install clusterMember-1.0 --when-file-exists=ignore
installUtility install clusterMember-1.0
echo "clusterMember-1.0 installed"

echo "Installing websocket-1.1 in wlp"
featureManager install websocket-1.1 --when-file-exists=ignore
installUtility install websocket-1.1
echo "websocket-1.1 installed"

echo "Installing restConnector-2.0 in wlp"
featureManager install restConnector-2.0 --when-file-exists=ignore
installUtility install restConnector-2.0
echo "restConnector-2.0 installed"

echo "Installing ssl-1.0 in wlp"
featureManager install ssl-1.0 --when-file-exists=ignore
installUtility install ssl-1.0
echo "ssl-1.0 installed"

echo "Installing localConnector-1.0 in wlp"
featureManager install localConnector-1.0 --when-file-exists=ignore
installUtility install localConnector-1.0
echo "localConnector-1.0 installed"

echo "Installing adminCenter-1.0 in wlp"
featureManager install adminCenter-1.0 --when-file-exists=ignore
installUtility install adminCenter-1.0
echo "adminCenter-1.0 installed"

echo "Installing dynamicRouting-1.0 in wlp"
featureManager install dynamicRouting-1.0 --when-file-exists=ignore
installUtility install dynamicRouting-1.0
echo "dynamicRouting-1.0 installed"