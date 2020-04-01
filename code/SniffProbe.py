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
                 print('[+] Detected New Probe Request: ' + netName)
            else:
                 print('[-] Detected Hidden SSID Probe.') 

def main():
    parser = optparse.OptionParser('usage '+'-i<interface>')
    parser.add_option('-i', dest='interface', \
type='string', help='specify interface to listen on')
    (options, args) = parser.parse_args()
    
    if options.interface == None:
        print(parser.usage)
        exit(0)
    else:
        interface = options.interface
    
    try:
        print("[=] Probe Sniffing...")
        sniff(iface=interface, prn=sniffProbe)
    except KeyboardInterrupt:
        exit(0)


if __name__ == '__main__':
    main()