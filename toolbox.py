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
        print("未Ping到 8.8.8.8")
        return2=os.system('ping 8.8.4.4 -c 2')
        if return2:
            print("无法连接到互联网")
        else:
            os.system(getfile)
    else:
         os.system(getfile)

def sys_info():
    print("系统详情:")
    os.system("neofetch") #Use:neofetch
    os.system("date")

def main():
	#need check "/code" exist
    nmapScan = ""
    
    try:
        opts, args = getopt.getopt(sys.argv[1:],"heVUP:",\
["sysver","update","install","Nvuln=","module","netcard",\
"info","IEEE","checkNet","wireless","scapy"])
    except getopt.GetoptError:
    	printUsage()
    	print("[!] 未知选项")
    	sys.exit(-1)
    
    for opt ,arg in opts:
        if opt == '-h':
                 os.system("cat code/help.txt")
        elif opt in ("-V", "--sysver"):
                 print("此功能需要下载软件,\
use toolbox.py -i or toolbox.py -install")
                 sys_info()
        elif opt == '--IEEE':
                 os.system("bash code/IEEE.sh")
        elif opt in ("-i","--install"):
                 getpath = "bash code/install_module.sh"
                 CheckNet(getpath)
        elif opt in ("-U","--update"):
                 updata = "sudo apt update && sudo apt upgrade \
&& sudo apt autoremove && sudo apt autoclean"
                 CheckNet(updata)
        elif opt == "--Nvuln" :
                 nmapScan = arg
                 print ("需要时间去扫描: " + nmapScan)
                 os.system("sudo nmap -sV -p --script vuln --script-args unsafe " + nmapScan)
        elif opt == "--info" :
                 os.system("cat code/readme.txt")
        elif opt == "--scapy" :
                 os.system("bash code/scapy.sh")
        elif opt == "--netcard" :
                 os.system("bash code/netcard.sh")


if __name__=="__main__":
     print('使用选项 "-h" 了解更多')
     main()