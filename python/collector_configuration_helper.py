#require pip frameworks 
import sys
import os
from xml.etree import ElementTree as ET
import json

#global variables
cluster_nodes = []
template_created = False


#main program launch
if __name__ == '__main__':
    print('Launching config.xml parser')
    #check for the test/prod argument
    if len(sys.argv) > 1:
        print('Checking if (' + sys.argv[0] + ') actually exists...')
        if os.path.exists(sys.argv[1]):
            #cycle through the list of files 
            if os.path.exists(sys.argv[1] + '/plugin-cfg.xml'):
                os.remove(sys.argv[1] + '/plugin-cfg.xml')
            for file in os.listdir(sys.argv[1]):
                if '.xml' in file and file != 'config.xml':
                    #read the server xml
                    xml = ET.parse(sys.argv[1] + '/' + file)
                    doc = xml.getroot()
                    print('Checking for the Intelligent Management Node')
                    if len(doc.findall('IntelligentManagement')) > 0:
                        im = doc.findall('IntelligentManagement')[0]
                        print('Checking for the ConnectorCluster node')
                        if len(im.findall('ConnectorCluster')) > 0:
                            cluster_nodes.append(im.findall('ConnectorCluster')[0])
                    if template_created is False:
                        #create the new template xml 
                        ET.indent(xml, space="\t", level=0)
                        xml.write(sys.argv[1] + '/plugin-cfg.xml',encoding='utf-8')
                        template_created = True
            #read the server xml
            xml = ET.parse(sys.argv[1] + '/plugin-cfg.xml')
            doc = xml.getroot()
            print('Checking for the Intelligent Management Node in template')
            if len(doc.findall('IntelligentManagement')) > 0:
                im = doc.findall('IntelligentManagement')[0]
                #remove all childen from the im node
                for child in im.findall('ConnectorCluster'):
                    im.remove(child)
                #re-populate all of the cluster nodes into the xml
                for node in cluster_nodes:
                    im.append(node)
                #create the new template xml 
                ET.indent(xml, space="\t", level=0)
                xml.write(sys.argv[1] + '/plugin-cfg.xml',encoding='utf-8')

