#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import optparse
from scapy.all import *

hiddenNets = []
unhiddenNets = []

def sniffDot11(p):
    if p.haslayer(Dot11ProbeResp):
        addr2 = p.getlayer(Dot11).addr2
        if (addr2 in hiddenNets) & (addr2 not in unhiddenNets):
            netName = p.getlayer(Dot11ProbeResp).info
            print('[+] Decloaked Hidden SSID : ' + \
netName + ' for MAC: ' + addr2)
            unhiddenNets.append(addr2)
    
    if p.haslayer(Dot11Beacon):
        if p.getlayer(Dot11Beacon).info == '':
            addr2 = p.getlayer(Dot11).addr2
            if addr2 not in hiddenNets:
                print('[-] Detected Hidden SSID: ' + \
'with MAC: ' + addr2)
                hiddenNets.append(addr2)

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
        print("[=] Hidden SSID Sniffing... ")
        sniff(iface=interface, prn=sniffDot11)
    except KeyboardInterrupt:
        exit(0)


if __name__ == '__main__':
    main()
