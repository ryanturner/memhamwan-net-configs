# dec/31/2001 19:32:43 by RouterOS 6.20
# software id = BX80-PIQ0
#
/interface bridge
add disabled=yes mtu=1500 name=bridge1 protocol-mode=none
/interface ethernet
set [ find default-name=ether1 ] comment=WAN
set [ find default-name=ether2 ] comment=retkvm1
set [ find default-name=ether3 ] master-port=ether2
set [ find default-name=ether4 ] master-port=ether2
set [ find default-name=ether5 ] master-port=ether2
set [ find default-name=ether6 ] comment="Slow infrastructure"
set [ find default-name=ether7 ] master-port=ether6
set [ find default-name=ether8 ] master-port=ether6
set [ find default-name=ether9 ] master-port=ether6
set [ find default-name=ether10 ] master-port=ether6
/interface ipip
add clamp-tcp-mss=no comment=\
    "K0RET - HamWAN - Seattle. MTU set for ESP+NAT-T." dscp=0 local-address=\
    10.0.5.2 mtu=1418 name=ipip1 remote-address=209.189.196.68
/ip neighbor discovery
set ether1 comment=WAN
set ether2 comment=retkvm1
set ether6 comment="Slow infrastructure"
set ipip1 comment="K0RET - HamWAN - Seattle. MTU set for ESP+NAT-T." \
    discover=no
/ip ipsec proposal
add auth-algorithms=null name=vpn-esp
add auth-algorithms=md5 enc-algorithms=null name=vpn-ah
/ip pool
add name=pool1 ranges=44.34.129.2-44.34.129.254
/port
set 0 name=serial0
/routing ospf instance
set [ find default=yes ] distribute-default=if-installed-as-type-1 in-filter=\
    Ham-default out-filter=Ham-default redistribute-bgp=as-type-1 \
    redistribute-connected=as-type-1 redistribute-other-ospf=as-type-1 \
    router-id=44.34.128.1
/snmp community
set [ find default=yes ] addresses=44.34.128.16/28 name=hamwan
/system logging action
set 1 disk-file-name=log
set 2 remember=yes
set 3 src-address=0.0.0.0
/interface bridge port
add bridge=bridge1 interface=ether6
add bridge=bridge1 interface=ether2
/ip address
add address=44.34.128.1/32 interface=ipip1 network=44.34.128.2
add address=44.34.128.17/28 interface=ether2 network=44.34.128.16
/ip dhcp-client
add default-route-distance=100 dhcp-options=hostname,clientid disabled=no \
    interface=ether1 use-peer-dns=no use-peer-ntp=no
/ip dns
set cache-max-ttl=1h cache-size=8192KiB max-udp-packet-size=8192 servers=\
    44.34.132.1,44.34.133.1
/ip firewall address-list
add address=10.0.0.0/8 list=RFC1918
add address=172.16.0.0/12 list=RFC1918
add address=192.168.0.0/16 list=RFC1918
add address=66.240.192.138 list=ssh_blacklist
add address=218.77.79.34 list=ssh_blacklist
add address=2.134.11.27 list=ssh_blacklist
/ip firewall filter
add action=drop chain=input comment="drop ftp brute forcers" disabled=yes \
    dst-port=21 protocol=tcp src-address-list=ftp_blacklist
add chain=output content="530 Login incorrect" disabled=yes dst-limit=\
    1/1m,9,dst-address/1m protocol=tcp
add action=add-dst-to-address-list address-list=ftp_blacklist \
    address-list-timeout=3h chain=output content="530 Login incorrect" \
    disabled=yes protocol=tcp
add action=drop chain=input comment="drop ssh brute forcers" disabled=yes \
    dst-port=22 protocol=tcp src-address-list=ssh_blacklist
add action=add-src-to-address-list address-list=ssh_blacklist \
    address-list-timeout=1w3d chain=input connection-state=new disabled=yes \
    dst-port=22 protocol=tcp src-address-list=ssh_stage3
add action=add-src-to-address-list address-list=ssh_stage3 \
    address-list-timeout=1m chain=input connection-state=new disabled=yes \
    dst-port=22 protocol=tcp src-address-list=ssh_stage2
add action=add-src-to-address-list address-list=ssh_stage2 \
    address-list-timeout=1m chain=input connection-state=new disabled=yes \
    dst-port=22 protocol=tcp src-address-list=ssh_stage1
add action=add-src-to-address-list address-list=ssh_stage1 \
    address-list-timeout=1m chain=input connection-state=new disabled=yes \
    dst-port=22 protocol=tcp
add action=drop chain=output comment=\
    "drop mikrotik neighbor discovery protocol going out" disabled=yes \
    dst-port=5678 out-interface=ipip1 protocol=udp
add action=drop chain=output comment=\
    "Stop non-44net packets getting out of IPIP1" disabled=yes log-prefix=\
    "non-44net traffic to tunnel" out-interface=ipip1 src-address=\
    !44.34.128.0/21
add action=drop chain=forward comment=\
    "Stop non-44net packets getting out of IPIP1" disabled=yes out-interface=\
    ipip1 src-address=!44.34.128.0/21
add action=drop chain=input src-address=152.19.88.132
/ip firewall mangle
add action=mark-connection chain=input disabled=yes in-interface=ipip1 \
    new-connection-mark=ipip1-in
add action=mark-connection chain=prerouting disabled=yes in-interface=ipip1 \
    new-connection-mark=ipip1-in
/ip firewall nat
add action=masquerade chain=srcnat disabled=yes out-interface=ether1
/ip ipsec peer
add address=209.189.196.68/32 auth-method=rsa-signature certificate=K0RET \
    enc-algorithm=aes-128 hash-algorithm=md5 remote-certificate=HamWAN
/ip ipsec policy
add dst-address=209.189.196.68/32 proposal=vpn-esp protocol=ipencap \
    sa-dst-address=209.189.196.68 sa-src-address=10.0.5.2 src-address=\
    10.0.5.2/32 tunnel=yes
/ip proxy
set cache-path=web-proxy1
/ip route
add distance=2 gateway=44.34.128.2
add distance=1 dst-address=10.0.0.0/8 gateway=10.0.5.1
add disabled=yes distance=200 dst-address=44.34.128.0/21 type=unreachable
add comment=HamWAN-Seattle-ER1 distance=1 dst-address=209.189.196.68/32 \
    gateway=10.0.5.1
add disabled=yes distance=1 dst-address=216.66.22.2/32 gateway=107.129.140.1
/ip upnp
set allow-disable-external-interface=no
/ipv6 address
add address=2001:470:7:f6a::2
/ipv6 route
add distance=1 gateway=2001:470:7:f6a::1
add comment="HamWAN IPv6 Tunnel" distance=1 dst-address=2000::/3 gateway=\
    2001:470:7:f6a::1
/lcd interface pages
add interfaces="sfp1,ether1,ether2,ether3,ether4,ether5,ether6,ether7,ether8,e\
    ther9,ether10"
/routing filter
add action=accept chain=Ham-default
/routing ospf interface
add authentication=md5 authentication-key=[KEY-HERE] interface=ether2 \
    network-type=broadcast
add authentication=md5 authentication-key=[KEY-HERE] interface=ether3 \
    network-type=broadcast
/routing ospf network
add area=backbone network=44.34.128.16/28
add area=backbone network=44.34.128.0/28
/snmp
set enabled=yes
/system clock
set time-zone-name=America/Chicago
/system identity
set name=er1.ret
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
set sfp1 disabled=yes display-time=5s
set ether1 disabled=yes display-time=5s
set ether2 disabled=yes display-time=5s
set ether3 disabled=yes display-time=5s
set ether4 disabled=yes display-time=5s
set ether5 disabled=yes display-time=5s
set ether6 disabled=yes display-time=5s
set ether7 disabled=yes display-time=5s
set ether8 disabled=yes display-time=5s
set ether9 disabled=yes display-time=5s
set ether10 disabled=yes display-time=5s
set ipip1 disabled=yes display-time=5s
/system logging
add action=echo disabled=yes topics=ipsec
/system ntp client
set enabled=yes mode=broadcast primary-ntp=44.34.132.2 secondary-ntp=\
    44.34.133.2
/system script
add name=station-id policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive source=\
    "/tool e-mail send to=k0ret"
/tool e-mail
set address=44.24.240.1 from=k0ret
/tool sniffer
set filter-interface=ipip1 memory-limit=1024KiB
/tool traffic-generator packet-template
add header-stack=raw name=hamwan-id raw-header=k
/tool user-manager database
set db-path=user-manager1
