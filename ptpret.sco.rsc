# jan/03/1970 03:13:57 by RouterOS 6.19
# software id = W7AZ-7ES1
#
/interface bridge
add l2mtu=2290 name=bridge1
/interface ethernet
set [ find default-name=ether1 ] name=ether1-local
/interface wireless
set [ find default-name=wlan1 ] band=5ghz-a/n channel-width=5mhz disabled=no \
    frequency=5745 ht-rxchains=0,1 ht-txchains=0,1 l2mtu=2290 mode=bridge \
    name=wlan1-gateway ssid=HamWAN wireless-protocol=nv2
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec proposal
set [ find default=yes ] enc-algorithms=3des
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/routing ospf instance
set [ find default=yes ] distribute-default=if-installed-as-type-1 \
    redistribute-connected=as-type-1 redistribute-other-ospf=as-type-1 \
    redistribute-static=as-type-1 router-id=44.34.131.129
/snmp community
set [ find default=yes ] addresses=44.34.128.0/21 name=hamwan
/system logging action
set 0 memory-lines=100
set 1 disk-lines-per-file=100
/interface bridge port
add bridge=bridge1 interface=wlan1-gateway
/ip address
add address=44.34.128.37/28 interface=ether1-local network=44.34.128.32
add address=44.34.131.129/32 interface=bridge1 network=44.34.131.128
/ip dhcp-server network
add address=192.168.88.0/24 comment="default configuration" dns-server=\
    192.168.88.1 gateway=192.168.88.1
/ip dns
set servers=44.34.132.1,44.34.133.1
/ip dns static
add address=192.168.88.1 name=router
/ip service
set api disabled=yes
/ip upnp
set allow-disable-external-interface=no
/routing ospf interface
add authentication=md5 authentication-key=[KEY-HERE] interface=bridge1 \
    network-type=point-to-point
add authentication=md5 authentication-key=[KEY-HERE] interface=\
    ether1-local network-type=broadcast
/routing ospf network
add area=backbone network=44.34.128.32/28
add area=backbone network=44.34.131.128/32
/snmp
set contact="#HamWAN on irc.freenode.org" enabled=yes
/system identity
set name=ptpret.sco
/system lcd
set contrast=0 enabled=no port=parallel type=24x4
/system lcd page
set time disabled=yes display-time=5s
set resources disabled=yes display-time=5s
set uptime disabled=yes display-time=5s
set packets disabled=yes display-time=5s
set bits disabled=yes display-time=5s
set version disabled=yes display-time=5s
set identity disabled=yes display-time=5s
set bridge1 disabled=yes display-time=5s
set wlan1-gateway disabled=yes display-time=5s
set ether1-local disabled=yes display-time=5s
/system leds
set 0 interface=wlan1-gateway
/system routerboard settings
set cpu-frequency=600MHz
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether1-local
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether1-local
