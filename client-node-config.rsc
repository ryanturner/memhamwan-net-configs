# memhamwan-net-configs
# Execute with /import client-node-config.rsc
# This script assumes that you've transferred a full set of RouterOS software and all appropriate user certificates
# after you execute this script, you need to do three things
# /system identity set name=YourCallsign
# /interface wireless set 0 radio-name="YourCallsign"
# /user set admin password=put-your-password-here!
# /console clear-history
:put "Configuring your radio for HamWAN"

:global ROSver value=[:tostr [/system resource get value-name=version]];
:global ROSverH value=[:pick $ROSver 0 ([:find $ROSver "." -1]) ];
:global ROSverL value=[:pick $ROSver ([:find $ROSver "." -1] + 1) [:len $ROSver] ];
:if ([:len $ROSverL] < 2) do={ set $ROSverL value=("0".$ROSverL) };

:global ROSverN value=[:tonum ($ROSverL.$ROSverL)];
:if ($ROSverN < 600) do={
:error "Please update RouterOS to at least major version 6 to continue"
};

:put [/user add group=full name=ryan_turner password=]
:put [/user ssh-keys import public-key-file=ryan_turner_dsa_public.txt user=ryan_turner]
:put [/user add group=full name=ns4b password=]
:put [/user ssh-keys import public-key-file=ns4b_dsa_public.txt user=ns4b]
:put [/system logging action set 3 bsd-syslog=no name=remote remote=44.34.128.21 remote-port=514 src-address=0.0.0.0 syslog-facility=daemon syslog-severity=auto target=remote]
:put [/system logging add action=remote disabled=no prefix="" topics=!debug,!snmp]
:put [/snmp set enabled=yes contact="#HamWAN on irc.freenode.org"]
:put [/snmp community set name=hamwan addresses=44.34.128.0/28 read-access=yes write-access=no numbers=0]
:put [/ip dns set servers=44.34.132.1,44.34.133.1]
:put [/system ntp client set enabled=yes primary-ntp=44.34.132.3 secondary-ntp=44.34.133.3]
:put [/ip firewall filter remove [find]]
:put [/ip dhcp-server remove [find]]
:put [/ip dhcp-server network remove [find]]
:put [/ip address remove [find]]
:put [/ip dns set allow-remote-requests=no]
:put [/ip firewall mangle add action=change-mss chain=output new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378]
:put [/ip firewall mangle add action=change-mss chain=forward new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5900 list=HamWAN name=Sector2-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5880 list=HamWAN name=Sector3-10 width=10]
:put [/interface wireless set 0 disabled=no frequency-mode=superchannel scan-list=HamWAN ssid=HamWAN wireless-protocol=nv2]
:put [/ip dhcp-client add add-default-route=yes dhcp-options=hostname,clientid disabled=no interface=wlan1]
:put [/system reboot]
