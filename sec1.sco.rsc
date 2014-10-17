/interface ethernet
set [ find default-name=ether1 ] name=ether1-local
/interface wireless
set [ find default-name=wlan1 ] band=5ghz-onlyn channel-width=10mhz disabled=\
    no frequency=5920 frequency-mode=superchannel l2mtu=2290 mode=ap-bridge \
    name=wlan1-gateway nv2-cell-radius=100 radio-name=KM4ECM/SEC1.SCO \
    scan-list=5920 ssid=HamWAN tdma-period-size=4 wireless-protocol=nv2
/interface wireless channels
add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" \
    frequency=5920 list=HamWAN name=Sector1 width=10
add band=5ghz-onlyn comment=\
    "Cell sites radiate this at 120 degrees (south-east)" frequency=5900 \
    list=HamWAN name=Sector2 width=10
add band=5ghz-onlyn comment=\
    "Cell sites radiate this at 240 degrees (south-west)" frequency=5880 \
    list=HamWAN name=Sector3 width=10
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity="HamWAN Memphis Metro, Inc"
/ip firewall filter
remove [find]
/ip firewall nat
remove [find]
/ip firewall mangle
remove [find]
add action=change-mss chain=output new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378
add action=change-mss chain=forward new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378
/ip pool
add name=hamwan ranges=44.34.128.50-44.34.128.62
/ip dhcp-server
remove [find]
add address-pool=hamwan disabled=no interface=wlan1-gateway name=dhcp1
/routing ospf instance
set [ find default=yes ] in-filter=Ham-default out-filter=Ham-default \
    redistribute-bgp=as-type-1 redistribute-connected=as-type-1 \
    redistribute-other-ospf=as-type-1 router-id=44.34.128.34
/snmp community
set [ find default=yes ] addresses=44.34.128.0/21 name=hamwan
/ip address
remove [find]
add address=44.34.128.34/28 interface=ether1-local network=44.34.128.32
add address=44.34.128.49/28 interface=wlan1-gateway network=44.34.128.48
/ip dhcp-client
remove [find]
/ip dhcp-server network
add address=44.34.128.48/28 dns-server=44.34.132.1,44.34.133.1 domain=\
    memhamwan.net gateway=44.34.128.49 ntp-server=44.34.132.3,44.34.133.3
/ip dns
set servers=44.34.132.1,44.34.133.1
set allow-remote-requests=no
/ip route
add distance=1 gateway=44.34.128.37
/routing ospf interface
add authentication=md5 authentication-key=[KEY-HERE] interface=\
    ether1-local network-type=broadcast
add authentication=md5 authentication-key=[KEY-HERE] interface=\
    wlan1-gateway network-type=broadcast
/routing ospf network
add area=backbone network=44.34.128.32/28
add area=backbone network=44.34.128.48/28
/snmp
set contact="#HamWAN on irc.freenode.org" enabled=yes
/system identity
set name=sec1.sco
/system ntp client
set enabled=yes primary-ntp=44.34.132.3 secondary-ntp=44.34.133.3
