#import required modules
import requests
import threading
import sys
import os
import time
import xlsxwriter
from datetime import datetime
from urllib.parse import urlparse
import urllib3
urllib3.disable_warnings()

#init global vars
threads = []
responses = []

#this function will create the excel export 
def createResponsesExport(url):
    #create the excel file based on current date/time
    hostname = urlparse(url).hostname
    now = datetime.now()
    export_file_name = hostname + '_emulation_export_' + now.strftime("%m-%d-%Y-%H%M%S") + '.xlsx'
    workbook = xlsxwriter.Workbook(export_file_name)
    worksheet = workbook.add_worksheet('user emulation results')

    #iterate over the responses array
    row = 0
    col = 0
    for response in responses:
        #write the date 
        worksheet.write(row, col, response['status_code'])
        worksheet.write(row, col + 1, response['reason'])
        worksheet.write(row, col + 2, response['time_elapsed'])
        worksheet.write(row, col + 3, response['is_redirect'])
        worksheet.write(row, col + 4, response['response_url'])
        worksheet.write(row, col + 5, response['headers'])
        #update the row index
        row = row + 1
    #close the sheet 
    workbook.close()

#this function will perform the required http request
def emulateUser(url):
    #make the request
    x = requests.get(url,verify=False)
    #check if the status code is 200
    #add an item to the responses list 
    responses.append({'status_code':x.status_code,'reason':x.reason,'time_elapsed':x.elapsed,'is_redirect':x.is_redirect,'response_url':x.url,'headers':str(x.headers)})

#main program launch
if __name__ == '__main__':
    #check for passed in arguments 
    if len(sys.argv) > 3:
        print('Starting traffic emulation for ' + sys.argv[1])
        #init a constant loop to continue until it is force closed 
        iteration_count = 1
        #add initial exel header 
        responses.append({'status_code':'STATUS CODE','reason':'STATUS REASON','time_elapsed':'REQUEST->RESPONSE TIME ELAPSED','is_redirect':'IS A REDIRECT?','response_url':'RESPONSE URL','headers':'RESPONSE HEADERS'})
        while iteration_count <= int(sys.argv[3]):
            #create another embedded loop using the amount of threads as reference
            thread_count = 1
            for r in range(int(sys.argv[2])):
                #fire off a thread to make a request 
                t = threading.Thread(target=emulateUser, args=(sys.argv[1],))
                #start the thread
                t.start()
                threads.append(t)
                print('New emulation thread launched - ' + str(thread_count))
                thread_count = thread_count + 1
            #check if there are active threads and stall the main loop if so 
            print("Checking for active threads")
            active_threads = [at for at in threads if at.is_alive()]
            while len(active_threads) > 0:
                print('Found active threads...going to sleep for 1 second')
                time.sleep(1)
                active_threads = [at for at in threads if at.is_alive()]
            #update the iteration count
            print('Updating iteration count - ' + str(iteration_count))
            iteration_count = iteration_count + 1
            threads = []
        print('Emulation complete...exporting results')
        createResponsesExport(sys.argv[1])
