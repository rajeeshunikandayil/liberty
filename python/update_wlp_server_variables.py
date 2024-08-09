#require pip frameworks 
import sys
import os
from xml.etree import ElementTree as ET
import json


#global variables 
collective_member_features = ['restConnector-2.0', 'localConnector-1.0', 'ssl-1.0', 'adminCenter-1.0']
collective_controller_features = ['restConnector-2.0', 'localConnector-1.0', 'adminCenter-1.0', 'websocket-1.1', 'dynamicRouting-1.0', 'ssl-1.0']

#main program launch
if __name__ == '__main__':
    print('Launching server.xml parser...checking for passed arguments - ' + str(sys.argv))
    #check for the test/prod argument
    if len(sys.argv) > 2:
        #get the wlp user directory
        wlp_user_dir = os.getenv('WLP_USER_DIR')
        print('Checking if ' + sys.argv[1] + ' exists within WLP')
        if os.path.exists(wlp_user_dir) and (os.path.exists(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml') or os.path.exists(wlp_user_dir + '/servers/' + sys.argv[1] + '/collector.xml') or os.path.exists(wlp_user_dir + '/servers/' + sys.argv[1] + '_include.xml')):
            print('Path exists. Setting up features for ' + sys.argv[1])
            #read the server xml
            xml = ET.parse(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml')
            doc = xml.getroot()
            #check the type of update needed 
            if sys.argv[2] == 'host':
                print('Getting collector host name')
                #refresh the source xml 
                xml = ET.parse(wlp_user_dir + '/servers/' + sys.argv[1] + '/controller.xml')
                doc = xml.getroot()
                print('Finding hostname variable - ' + sys.argv[1])
                if len(doc.findall('variable')) > 0:
                    if doc.findall('variable')[0].attrib['name'] == 'defaultHostName':
                        #print out the host name attribute
                        print(doc.findall('variable')[0].attrib['value'])
            elif sys.argv[2] == 'ports':
                print('Adding ports to server.xml')
                #update all ports within the httpEndpoint nodes
                doc.findall('httpEndpoint')[0].attrib['httpPort'] = sys.argv[3]
                doc.findall('httpEndpoint')[0].attrib['httpsPort'] = sys.argv[4]
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding="utf-8")
            elif sys.argv[2] == 'applications':
                print("Getting apps information from servers.json")
                f = open('../servers.json')
                servers = json.load(f)
                #get the server that matches the server name 
                server = [s for s in servers['servers'] if s['name'] == sys.argv[1]]
                if len(server) > 0:   
                    #check for length on the list of apps 
                    for app in server[0]['apps']:
                        fileName = app['file'].split('/')[(len(app['file'].split('/')) - 1)]
                        #delimite the second parameters
                        print('Checking application list for existing names of ' + app['path'] + ' and ' + fileName)
                        #get all the application nodes 
                        installed_applications = [a for a in doc.findall('application') if a.attrib['context-root'] == app['path'] or a.attrib['id'] == app['path'] or a.attrib['name'] == app['path'] and a.attrib['location'] == fileName]
                        if len(installed_applications) == 0:
                            print('Adding application node - ' + app['path'])
                            #check the type of file 
                            type = 'war'
                            if '.ear' in fileName or '.EAR' in fileName:
                                type = 'ear'
                            #create the new application sub-element 
                            new_application_element = ET.SubElement(doc, 'application')
                            new_application_element.attrib['context-root'] = app['path']
                            new_application_element.attrib['id'] = app['path']
                            new_application_element.attrib['name'] = app['path']
                            new_application_element.attrib['type'] = type
                            new_application_element.attrib['location'] = fileName
                            #write out the completed xml 
                            ET.indent(xml, space="\t", level=0)
                            xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding="utf-8")
            elif sys.argv[2] == 'proxies':
                print("Getting host proxy information from servers.json")
                f = open('../servers.json')
                servers = json.load(f)
                #get the server that matches the server name 
                server = [s for s in servers['servers'] if s['name'] == sys.argv[1]]
                if len(server) > 0:
                    # check if there is a virtual host node within the xml 
                    virtualHostNodes = doc.findall('virtualHost')
                    #check if there are virtual host nodes already 
                    if len(virtualHostNodes) == 0 and len(server[0]['proxies']) > 0:
                        #create the virtual host nodes 
                        new_include_element = ET.SubElement(doc, 'virtualHost')
                        new_include_element.attrib['id'] = 'proxiedRequests'
                        #write out the completed xml 
                        ET.indent(xml, space="\t", level=0)
                        xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding="utf-8")
                        #refresh the xml
                        xml = ET.parse(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml')
                        doc = xml.getroot()
                        virtualHostNodes = doc.findall('virtualHost')
                    #check for length on the list of apps 
                    for proxy in server[0]['proxies']:                     
                        #check to see if the current host name in servers.json already exists
                        hostAliasNodes = [n for n in virtualHostNodes[0].findall('hostAlias') if n.text.lower() == proxy.lower()]
                        if len(hostAliasNodes) == 0:
                            print('Adding new host alias value - ' + proxy)
                            #create the new application sub-element 
                            new_application_element = ET.SubElement(virtualHostNodes[0], 'hostAlias')
                            new_application_element.text = proxy
                            #write out the completed xml 
                            ET.indent(xml, space="\t", level=0)
                            xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding="utf-8")
            elif sys.argv[2] == 'member' and sys.argv[3] == 'join':
                print('Adding join include node for ' + sys.argv[1])
                #get all the application nodes 
                installed_includes = [a for a in doc.findall('include') if a.attrib['location'] == '${server.config.dir}/' + sys.argv[1] + '_include.xml']
                if len(installed_includes) == 0:
                    print('Adding member join include')
                    #create the new application sub-element 
                    new_include_element = ET.SubElement(doc, 'include')
                    new_include_element.attrib['location'] = '${server.config.dir}/' + sys.argv[1] + '_include.xml'
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding='utf-8')
                #//////////////////////////////////////////////////////////////////////////////////////
                #update the include xml for the member 
                xml = ET.parse(wlp_user_dir + '/servers/' + sys.argv[1] + '/' + sys.argv[1] + '_include.xml')
                doc = xml.getroot()
                featureManager = doc.findall('featureManager')[0]
                #iterate through the list of member features and check to see if they are installed already 
                print('Checking if we need to install - clusterMember-1.0')
                installed_features = [f for f in featureManager.findall('feature') if f.text == 'clusterMember-1.0']
                if len(installed_features) == 0:
                    ET.SubElement(doc.findall('featureManager')[0], 'feature').text = 'clusterMember-1.0'
                if len(doc.findall('remoteFileAccess')) > 0:
                    #check for remoteFileAccessNode
                    remoteFileAccess = doc.findall('remoteFileAccess')[0]
                    #iterate through the list of member features and check to see if they are installed already 
                    print('Checking if we need to remote file access')
                    installed_accesses_write = [f for f in remoteFileAccess.findall('writeDir') if f.text == '${server.config.dir}']
                    if len(installed_accesses_write) == 0:
                        ET.SubElement(doc.findall('remoteFileAccess')[0], 'writeDir').text = '${server.config.dir}'
                else:
                    remoteFileAccess = ET.SubElement(doc, 'remoteFileAccess')
                    ET.SubElement(remoteFileAccess, 'writeDir').text = '${server.config.dir}'
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/' + sys.argv[1] + '_include.xml',encoding='utf-8')
            elif sys.argv[2] == 'member' and sys.argv[3] == 'leave':
                print('Removing join include node for ' + sys.argv[1])
                #get all the application nodes 
                installed_includes = [a for a in doc.findall('include') if a.attrib['location'] == '${server.config.dir}/' + sys.argv[1] + '_include.xml']
                if len(installed_includes) > 0:
                    print('Found a list of server includes...deleting')
                    #remove all includes
                    for include in installed_includes:
                        doc.remove(include)
                        print('Removing include')
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding='utf-8')
                print('Removing server include xml from server directory')
                os.remove(wlp_user_dir + '/servers/' + sys.argv[1] + '/' + sys.argv[1] + '_include.xml')
            elif sys.argv[2] == 'controller' and sys.argv[3] == 'add':
                print('Adding controller node for ' + sys.argv[1] + ' to server.xml')
                #get all the application nodes 
                installed_includes = [a for a in doc.findall('include') if a.attrib['location'] == '${server.config.dir}/controller.xml']
                if len(installed_includes) == 0:
                    print('Adding controller location')
                    #create the new application sub-element 
                    new_include_element = ET.SubElement(doc, 'include')
                    new_include_element.attrib['location'] = '${server.config.dir}/controller.xml'
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding='utf-8')
            elif sys.argv[2] == 'controller' and sys.argv[3] == 'remove':
                print('Removing controller node for ' + sys.argv[1] + ' in server.xml')
                #get all the application nodes 
                installed_includes = [a for a in doc.findall('include') if a.attrib['location'] == '${server.config.dir}/controller.xml']
                if len(installed_includes) > 0:
                    print('Removing controller location')
                    #remove all includes
                    for include in installed_includes:
                        doc.remove(include)
                        print('Removing include')
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding='utf-8')
            elif sys.argv[2] == 'controller' and len(sys.argv) > 3:
                #refresh the source xml 
                xml = ET.parse(wlp_user_dir + '/servers/' + sys.argv[1] + '/controller.xml')
                doc = xml.getroot()
                print('Updating quick security username and password - ' + sys.argv[1])
                for child in doc.findall('quickStartSecurity'):
                    child.attrib['userName'] = sys.argv[3]
                    child.attrib['userPassword'] = sys.argv[4]
                #update the collector name 
                if len(doc.findall('variable')) > 0:
                    if doc.findall('variable')[0].attrib['name'] == 'defaultHostName':
                        #get ths host name
                        host_name = doc.findall('variable')[0].attrib['value']
                        #populate the dynamic routing node 
                        dynamic_routing_element = ET.SubElement(doc, 'dynamicRouting')
                        dynamic_routing_element.attrib['connectorClusterName'] = host_name
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/controller.xml',encoding="utf-8")
            elif len(doc.findall('featureManager')) > 0 and sys.argv[2] == 'features' and sys.argv[3] == 'member':
                print('Processing features for members')
                #iterate through the parent server node
                featureManager = doc.findall('featureManager')[0]
                #iterate through the list of member features and check to see if they are installed already 
                for feature in collective_member_features:
                     print('Checking if we need to install - ' + feature)
                     installed_features = [f for f in featureManager.findall('feature') if f.text == feature]
                     print('Current matching features - ' + str(len(installed_features)))
                     if len(installed_features) == 0:
                        print('Adding ' + feature + ' to the list of features')
                        ET.SubElement(doc.findall('featureManager')[0], 'feature').text = feature
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding="utf-8")
            elif len(doc.findall('featureManager')) > 0 and sys.argv[2] == 'features' and sys.argv[3] == 'controller':
                print('Processing features for controllers')
                #iterate through the parent server node
                featureManager = doc.findall('featureManager')[0]
                #iterate through the list of member features and check to see if they are installed already 
                for feature in collective_controller_features:
                     print('Checking if we need to install - ' + feature)
                     installed_features = [f for f in featureManager.findall('feature') if f.text == feature]
                     print('Current matching features - ' + str(len(installed_features)))
                     if len(installed_features) == 0:
                        print('Adding ' + feature + ' to the list of features')
                        ET.SubElement(doc.findall('featureManager')[0], 'feature').text = feature
                #write out the completed xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml',encoding="utf-8")
