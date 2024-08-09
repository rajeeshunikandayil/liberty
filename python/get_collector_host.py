#require pip frameworks 
import sys
import os
from xml.etree import ElementTree as ET


#main program launch
if __name__ == '__main__':
    #check for the test/prod argument
    if len(sys.argv) > 0:
        #get the wlp user directory
        wlp_user_dir = os.getenv('WLP_USER_DIR')
        if os.path.exists(wlp_user_dir) and (os.path.exists(wlp_user_dir + '/servers/' + sys.argv[1] + '/server.xml') or os.path.exists(wlp_user_dir + '/servers/' + sys.argv[1] + '/collector.xml') or os.path.exists(wlp_user_dir + '/servers/' + sys.argv[1] + '_include.xml')):
            #refresh the source xml 
            xml = ET.parse(wlp_user_dir + '/servers/' + sys.argv[1] + '/controller.xml')
            doc = xml.getroot()
            if len(doc.findall('variable')) > 0:
                if doc.findall('variable')[0].attrib['name'] == 'defaultHostName':
                    #print out the host name attribute
                    print(doc.findall('variable')[0].attrib['value'])