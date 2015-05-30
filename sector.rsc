:global Prompt;
:local runFunc;
:import base.rsc;

:put [/ip firewall mangle remove [find]]
:put [/interface wireless channels remove [find list=HamWAN]]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5900 list=HamWAN name=Sector2-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5880 list=HamWAN name=Sector3-10 width=10]

    :global sector;
    :set runFunc [:parse (":global sector;" . \
             ":local input \"Enter the sector number:\";" . \
                       $Prompt . \
             ":set sector \$output")
         ]

    $runFunc;

    :global site;
    :set runFunc [:parse (":global site;" . \
             ":local input \"Enter the site 3-letter identity:\";" . \
                       $Prompt . \
             ":set site \$output")
         ]

    $runFunc;

    :global vrrpPassword;
    :set runFunc [:parse (":global vrrpPassword;" . \
             ":local input \"Enter your VRRP password:\";" . \
                       $Prompt . \
             ":set vrrpPassword \$output")
         ]

    $runFunc;

    :global ospfPassword;
    :set runFunc [:parse (":global ospfPassword;" . \
             ":local input \"Enter your OSPF password:\";" . \
                       $Prompt . \
             ":set ospfPassword \$output")
         ]

    $runFunc;

    :global dhcpPoolRange;
    :set runFunc [:parse (":global dhcpPoolRange;" . \
             ":local input \"Enter your DHCP pool address range:\";" . \
                       $Prompt . \
             ":set dhcpPoolRange \$output")
         ]

    $runFunc;

    :global etherIp;
    :set runFunc [:parse (":global etherIp;" . \
             ":local input \"Enter your ethernet IP (without network):\";" . \
                       $Prompt . \
             ":set etherIp \$output")
         ]

    $runFunc;

    :global etherNetworkIp;
    :set runFunc [:parse (":global etherNetworkIp;" . \
             ":local input \"Enter your ethernet network IP:\";" . \
                       $Prompt . \
             ":set etherNetworkIp \$output")
         ]

    $runFunc;

    :global vrrpIp;
    :set runFunc [:parse (":global vrrpIp;" . \
             ":local input \"Enter your VRRP IP (without network):\";" . \
                       $Prompt . \
             ":set vrrpIp \$output")
         ]

    $runFunc;

    :global wlanIp;
    :set runFunc [:parse (":global wlanIp;" . \
             ":local input \"Enter your WLAN IP (without network):\";" . \
                       $Prompt . \
             ":set wlanIp \$output")
         ]

    $runFunc;

    :global wlanNetworkIp;
    :set runFunc [:parse (":global wlanNetworkIp;" . \
             ":local input \"Enter your WLAN network IP:\";" . \
                       $Prompt . \
             ":set wlanNetworkIp \$output")
         ]

    $runFunc;


:local etherIpWithCidr;
:set etherIpWithCidr ($etherIp . "/28");
:local etherNetworkIpWithCidr;
:set etherNetworkIpWithCidr ($etherNetworkIp . "/28");
:local wlanIpWithCidr;
:set wlanIpWithCidr ($wlanIp . "/28");
:local wlanNetworkIpWithCidr;
:set wlanNetworkIpWithCidr ($wlanNetworkIp . "/28");
:local vrrpIpWithCidr;
:set vrrpIpWithCidr ($vrrpIp . "/28");

:local name;
:set name (($networkValues->"callsign") . "/" . $site . "-S" . $sector);
:local frequency;

:if ($sector = "1") do={
    :set frequency "5920";
};
:if ($sector = "2") do={
    :set frequency "5900";
};
:if ($sector = "3") do={
    :set frequency "5880";
};

:put [/system identity set name=$name];
:put [/interface wireless set [ find default-name=wlan1 ] band=5ghz-onlyn channel-width=10mhz disabled=no frequency=$frequency frequency-mode=superchannel l2mtu=2290 mode=ap-bridge nv2-cell-radius=100 radio-name=$name ssid=HamWAN tdma-period-size=4 wireless-protocol=nv2]
:put [/interface vrrp remove [find name=vrrp1]]
:put [/interface vrrp add authentication=ah interface=ether1 name=vrrp1 password=$vrrpPassword version=2]
:put [/ip pool remove [find name=pool1]]
:put [/ip pool add name=pool1 ranges=$dhcpPoolRange]
:put [/ip dhcp-server remove [find name=dhcp1]]
:put [/ip dhcp-server add address-pool=pool1 disabled=no interface=wlan1 lease-time=1h name=dhcp1]
:put [/routing ospf instance set [ find default=yes ] distribute-default=if-installed-as-type-1 in-filter=AMPR-default out-filter=AMPR-default redistribute-connected=as-type-1 redistribute-other-ospf=as-type-1 redistribute-static=as-type-1 router-id=$etherIp]
:put [/ip address add address=$etherIpWithCidr interface=ether1 network=$etherNetworkIp]
:put [/ip address add address=$wlanIpWithCidr interface=wlan1 network=$wlanNetworkIp]
:put [/ip address add address=$vrrpIpWithCidr interface=vrrp1 network=$etherNetworkIp]
:put [/ip dhcp-server network remove [find]]
#:put [/ip dhcp-server network add address=$wlanNetworkIpWithCidr dns-server=($networkValues->"dnsServers") domain=($networkValues->"netDomain") gateway=$wlanIp netmask=28 ntp-server=($networkValues->"primaryNtpServer")]
:put [/ip dhcp-server network add address=$wlanNetworkIpWithCidr domain=($networkValues->"netDomain") gateway=$wlanIp netmask=28]

:put [/ip firewall mangle add action=change-mss chain=output new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378]
:put [/ip firewall mangle add action=change-mss chain=forward new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378]

:local hamwanSubnet
:set hamwanSubnet ($networkValues->"subnetWithCidr")
:put $hamwanSubnet
:put [/routing filter remove [find]]
:put [/routing filter add action=accept chain=HamWAN prefix=$hamwanSubnet prefix-length=20-32]
:put [/routing filter add action=reject chain=HamWAN]
:put [/routing filter add action=accept chain=HamWAN-default prefix=$hamwanSubnet prefix-length=20-32]
:put [/routing filter add action=accept chain=HamWAN-default prefix=0.0.0.0/0]
:put [/routing filter add action=reject chain=HamWAN-default]
:put [/routing filter add action=accept chain=AMPR-default prefix=44.0.0.0/8 prefix-length=8-32]
:put [/routing filter add action=accept chain=AMPR-default prefix=0.0.0.0/0]
:put [/routing filter add action=reject chain=AMPR-default]
:put [/routing filter add action=accept chain=AMPR prefix=44.0.0.0/8 prefix-length=8-32]
:put [/routing filter add action=reject chain=AMPR]
:put [/routing ospf interface remove [find]]
:put [/routing ospf interface add authentication=md5 authentication-key=$ospfPassword interface=ether1 network-type=broadcast]
:put [/routing ospf network remove [find]]
:put [/routing ospf network add area=backbone network=$etherNetworkIpWithCidr]


:put "Setup complete!"
