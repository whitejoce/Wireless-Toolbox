#!/usr/bin/python
# -*- coding: utf-8 -*-

import optparse
from scapy.all import *

probeReqs = []
def sniffProbe(p):
    if p.haslayer(Dot11ProbeReq):
         netName = p.getlayer(Dot11ProbeReq).info
         if netName not in probeReqs:
            probeReqs.append(netName)
            if netName:
                 print(' [+] 嗅探到Probe请求包: ' + netName)
            else:
                 print(' [-] 探测到隐藏SSID(只显示一次)Probe包.') 

def main():
    parser = optparse.OptionParser('usage '+'-i<interface>')
    parser.add_option('-i', dest='interface', \
type='string', help='网卡要切换到监听模式')
    (options, args) = parser.parse_args()
    
    if options.interface == None:
        print(parser.usage)
        exit(0)
    else:
        interface = options.interface
    
    try:
        print(" [=] 嗅探Probe中...")
        sniff(iface=interface, prn=sniffProbe)
    except KeyboardInterrupt:
        exit(0)


if __name__ == '__main__':
    main()