The below instructions are needed when installing the IBM HTTP Server (IHS) and Websphere Liberty (WLP) applications onto Linux (RHEL):

-- Table of Contents:

1.) General Setup

2.) Environment Setup

3.) HTTP Server Setup (IHS)

4.) Liberty Server Setup (WLP)

5.) Liberty Cluster Setup

6.) IHS/Liberty Deployment/Configuration

7.) Troubleshooting

8.) Final Thoughts


-------------------------------------------------------------------------------------------------------------------------------------------


1.) General Setup 

Navigate to the ./general_setup directory and then using 'sudo', invoke the bash shell script ./ibm_start_setup.sh. 

-- If the installation is only to be used for IBM HTTP Server (IHS), pass the parameter to the script - 'ihs'. 

-- If the installation is only to be used for WebSphere Liberty Server (WLP), pass the parameter to the script - 'wlp'.

-- If the installation will have both IHS and WLP applications installed, passe the parameter to the script - 'all'

NOTE: At this time, 9.0.5-WS-IHS-ARCHIVE-linux-x86_64-FP018.zip is the most current version of IHS. However, the download link may change which could break the IHS install script. If the url within './ibm_install_ihs.sh' is broken, please research the latest download url within IBM Fix Central using '9.0.5-WS-IHS-ARCHIVE-linux-x86_64-FP018.zip' in your search and replace the download url.


2.) Environment Setup

Navigate to the ./general_setup directory and WITHOUT using 'sudo', invoke the script './ibm_setup_environment_variables.sh

NOTE: This command requires a special invoke from the CLI to ensure that the .bashrc file is setup properly

-- Invoke the environemnt setup file as showere here: ". ./ibm_setup_environment_variables <param>"

-- To setup the environment only for IHS, pass the 'ihs' paramter to the shell script

-- To setup the environment only for WLP, pass the 'wlp' parameter to the shell scriptu

-- To setup the environment for both WLP and IHS, pass the 'all' parameter to the shell script

NOTE: In order for WLP and IHS to function properly, they must be setup within the 'wheel' group and have ownership of specific directories. All below commands must be perform as ROOT and/or in 'sudo'

-- Invoke the wheel command of the required user with commands shown here: 'usermod -aG wheel <username>'

-- Invoke the ownership of the IBM installed applications with commands shown here: 'chown -R <username> /opt/IBM'

-- Invoke the ownership of the IBM installed java JRE with commands shown here: 'chown -R <username> /usr/lib/jvm'


NOTE: The setup of applications/clusters within IHS/WLP will require specific ENV variables updated. Please note the below list that will need to be modified before starting server/cluster installation:

    1.) Configure the definition for: 'ENV_CONTROLLER_PASSWORD'.

        -- This definition is used as a password for the collecive controller login. The user name will be configured within the ./servers.json (Explained within section #4 - Liberty Server Setup (WLP))
    2.) Configure the definition for: 'ENV_KEYSTORE_PASSWORD'.

        -- This definition is used as a password for the keystores that are created for the servers and collectors. 
    3.) Configure the definition for: 'ENV_RPC_USER_PASSWORD'.

        -- This definition is used as a password for a cluster collective to communicate to a member server. The user name will be configured within the ./servers.json (Explained within section #4 - Liberty Server Setup (WLP))

NOTE: After all configurations are completed, perform 'sudo reboot' to restart the VM so the new .bashrc updates are completed. After reboot, verify that the configurations are in-place by performing this command: 'cat ~/.bashrc'


3.) HTTP Server Setup (IHS)

Navigate to the /opt/IBM/HTTPServer/IHS directory.

NOTE: By default, IBM HTTP Server is configured automatically to listen to port 80 (HTTP). Depending on Linux configuration, this port may be blocked from use. If port 80 is ulitimately required as the HTTP port, please see this url for assistance in configuration: 'https://www.ibm.com/support/pages/how-run-ibm-http-server-non-root-user-security-compliance-reasons'

NOTE: By default, IBM HTTP Server is configured automatically to listen to port 443 (HTTPS). Depending on Linux configuration, this port may be blocked from use. If port 443 is ulitimately required as the HTTPS port, please see this url for assistance in configuration: 'https://www.ibm.com/support/pages/how-run-ibm-http-server-non-root-user-security-compliance-reasons'

-- If a port change is required within IHS, please navigate to the /conf directory within already navigated /opt/IBM/HTTPServer/IHS directory. Open the ./httpd.conf file within nano and go to the 'listen' section within the file. If a port change is necessary, change the listening port.

-- After configuration is completed (if necessary), navigate to the '/ihs_setup' directory within the git repo directory. Afterward, invoke the file 'ihs_setup_https_and_start.sh' with a password that will be used to create the IHS HTTPS keystore.
-- After IHS has started, open a browser and navigate to the instance running on the configured HTTP and HTTPS port. The IHS default web page should display.


4.) Liberty Server Setup (WLP)

Navigate to the ./wlp_server_setup directory within the git repo.

NOTE: Before any of the server setup scripts are invoked, please make sure that the 'server.json' file is updated within the git repo main directory. Please note the below fields for better understanding of each json object:

    a.) name -- This text field will be used to represent the server name that WLP creates

    b.) active -- This boolean field will be used to ensure that a server is created and have apps deployed to it. If this 'active' field is false, the server will be removed.

    c.) type -- This is a text field to identify if the server will take the role as a collective or a member when being created.

    d.) http_port -- This is the required port for the server to run in HTTP. It must be unique.

    e.) https_port -- This is the required port for the server to run in HTTPS. It must be unique.

    f.) proxies -- This is a list of domain names that will be used to validate incoming requests and if they are allowed to access the particular liberty server. These values will be used to update the <virtualHost /> nodes within the server.xml. The war file will also need to be configured to reference the virtualHost nodes. Further explanation on virtual hosting within Liberty can be found on the below url:

        https://openliberty.io/docs/latest/virtual-hosts.html

    f.) apps -- This is a list of ear/war files that will be deployed into the server. Typically, collectives do not have apps deployed.

        i.) path -- This is the path that will be called to view the war/ear functionality within a browser or api.

        ii.) file -- This is the physical path to the ear/war file for bash to copy from. All ear/war files will be copied from this location to within the /apps directory of the server.

    g.) controller_username -- This is the user id to be utilized to login to the admin center of the collector

    h.) rpc_user -- This is the username for the collector to connect to the member server to illustrated the deployed server.xml contents.

-- To start the process of creating servers and deploying server applications, you will need to invoke the ./wlp_start_app_setup.sh. This file will install all features and start servers with apps installed.

NOTE: On the initial use of ./wlp_start_app_setup.sh, all server features will be installed which will require interaction with the user to accept disclaimers available from the IBM repository.

-- To test all applications, you will need to acquire the host name of the vm, set the port for the specific server and then followed by the path outlined in the 'app' object within the list of 'apps'. For collective servers, you will need to use the specific port and then add the path /adminCenter to view the members within the collective (This is further explained in #5 Liberty Cluster Setup).


5.) Liberty Cluster Setup (Three Steps)

Navigate to the ./wlp_cluster_setup directory.

-- The first setup in creating a collective cluster within WLP is setting up the collective cluster. To perform this, you will need to invoke the ./wlp_start_cluster_setup.sh. This shell script will then iterate through servers.json and check 'collector' type. Once found, this server is then setup with collector provisioning and admin center is installed. 

-- The second step in creating a collective cluster within WLP is by adding members to the cluster. To perform this step, you will need to invoke the ./wlp_start_cluster_member_setup.sh. This script will iterate through all servers identified by type 'member' and then join them to the collector. Once joined to the collector, they will be special provisioned as a member and will have a special include file setup within the server.xml. 

NOTE: After each server is setup as a member of a collective, the collective is refreshed with all servers that have been provisioned.

NOTE: If cluster members need to be cleared from a collector, the use of ./wlp_remove_all_collective_members.sh could be used. Further cleanup will be necessary of the server.xml to remove the extra nodes added for the collector membership.

-- When all members and collectives are ready, the provisioned members can be viewed by going to the https://<collective_server>:<collective_port>/adminCenter url. 

-- After all members are verified as ready for the collective, the third and final step for Libert setup is to create a config.xml to be used within IHS. To accomplish this, you will need to invoke the ./wlp_start_dynamic_routing.sh file. This file will create the configuration and pkcs certificate to be used for IHS. To deploy these files, please review #6 IHS/Liberty Deployment/Configuration


6.) IHS/Liberty Deployment/Configuration

This deployment task will require coordination between directories on IHS and WLP instances. Please see below steps:

    a.) Navigate to the /opt/IBM/Plugins directory on the IHS vm

    b.) Within the same directory that was used for step #6, pull all .xml and .p12 files to the IHS /opt/IBM/Plugins directory using scp commands. This task must be accomplished for cluster collectives that need to be exposed onto the IHS server.

    c.) When all collective collect xml and p12 files are pushed to /opt/IBM/Plugins within IHS, navigate to the git repo directory and change to the ./ihs_setup directory. Once there, invoke the ./ihs_combine_cluster_configuration_plugins.sh file. This shell script will iterate through all xml files, create one true plugin-cfg.xml and convert all pkcs files to cms libaries.

    d.) After all files are parsed and created, push all files to the respective IHS plugins directory (ie /opt/IBM/HTTPServer/IHS/plugin/config/webserver1)

    e.) Restart the IHS server within the node ('apachectl stop', 'apachectl start')

    f.) Using the servers.json file within the repo directory, open a browser with the hostname and port of the IHS server and use one of the paths defined in WLP (ie https://<ihs host>:<ihs port>/sample1). You should see the app path render similar to how it is directly rendered within WLP.


7.) Troubleshooting

For issues with WLP applications, please navigate to the respective plugin directory of IHS (ie /opt/IBM/HTTPServer/IHS/plugin/logs/webserver1) and review the http_plugin.log. 

NOTE: The default configuration setup within WLP plugin-cfg.xml files is 'Error'. If more debugging is needed, you can change the <Log /> node within the plugin-cfg.xml file to 'Trace' which will allow more verbose logging. For changes to be affective, you will need to restart IHS.

For issues with IHS, please navigate to the respective IHS directory for logging within /opt/IBM/HTTPServer/IHS/logs.


8.) Final Thoughts

The use of WLP clustering can be setup within many different use-cases within an environment. Please review the below possibilities (but not definitive):

    a.) Two collectives created within one WLP and deployed to two different IHS servers.

    b.) WLP instance deployed to a network with servers and apps installed but not connected to an IHS server.

    c.) One collective created and deployed to one IHS server.

    d.) One WLP server deployed directly to IHS server with no collective.

    e.) Two or more collectors deployed within a plugin-cfg.xml and pushed to one or more IHS servers.

NOTE: The above scenarios are examples only. Your decisions on how to use WLP and IHS together will vary depending on your anticipated architecture, the types of apps needed, and the types of traffic anticipated flowing to the applications.










