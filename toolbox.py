#!/usr/bin/python
# _*_coding: utf-8 _*_

import os
import sys
import getopt

def printUsage():
	print ('''Usage: Not Finish''')

def CheckNet(getfile): #check the Internet.
    return1=os.system('ping 8.8.8.8 -c 2')
    
    if return1:
        print("It seems like can't connect to 8.8.8.8")
        return2=os.system('ping 8.8.4.4 -c 2')
        if return2:
            print("Please connect to the Internet.")
        else:
            os.system(getfile)
    else:
         os.system(getfile)

def sys_info():
    print("System info:")
    os.system("neofetch") #Use:neofetch
    os.system("date")

def main():
	#need check "/code" exist
    nmapScan = ""
    inputarg = ""  
    
    try:
        opts, args = getopt.getopt(sys.argv[1:],"hViUd:",\
["sysver","update","install","download=","Nvuln=",\
"info","fakeAP","badAP","WEP","WAP2","checkNet"])
    except getopt.GetoptError:
    	printUsage()
    	print("Error")
    	sys.exit(-1)
    
    for opt ,arg in opts:
        if opt == '-h':
                 os.system("cat code/readme.txt")
                 printUsage()
        elif opt in ("-V", "--sysver"):
                 print("This function need install module"\
"use toolbox.py -i or toolbox.py -install")
                 sys_info()
        elif opt == '--fakeAP':
                 os.system("bash code/fakeAP.sh") #Use:aircrack-ng,mdk3
        elif opt in ("-i","--install"):
                 getpath = "bash code/install_module.sh"
                 CheckNet(getpath)
                 print("Done!")
        elif opt in ("-U","--update"):
                 updata = "sudo apt update && sudo apt upgrade && sudo apt autoremove \
&& sudo apt autoclean"
                 CheckNet(updata)
        elif opt in ("-d""--download"):
                 inputarg = arg				 
                 getpath = "sudo apt update && sudo apt install " + inputarg
                 CheckNet(getpath)
        elif opt == "--Nvuln" :
                 nmapScan = arg
                 print ("It will take some time to scan." + nmapScan)
                 os.system("sudo nmap -sV -p - --script vuln --script-args unsafe " + nmapScan)
        elif opt == "--info" :
                 os.system("cat code/readme.txt")
        elif opt == "--badAP" :
                print("Not FINISH!")

if __name__=="__main__":
     print('Use "-h" to know more.')
     main()