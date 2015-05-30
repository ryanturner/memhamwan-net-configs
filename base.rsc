:put [/system script environment remove [find]]
:global Prompt;
:local runFunc;

# Prompt: Puts a prompt on the command line, then accepts an input from the user.
# Input array:
#   0 = prompt to display
#   1 = echo typed input (0 - default) or hide (1)
# Output array:
#   0 = input from user
:global Prompt ":local output \"\"
            :set input [:toarray \$input]
            :if ([:len \$input] > 0) do={
                :local input1 [:tostr [:pick \$input 0]]
                :local echo 0
                :if ([:len \$input] > 1) do={ 
                    :set echo [:tonum [:pick \$input 1]]
                }
                :local asciichar (\"0,1,2,3,4,5,6,7,8,9,\" . \
                                  \"a,b,c,d,e,f,g,h,i,j,k,l,\" . \
                                  \"m,n,o,p,q,r,s,t,u,v,w,x,y,z,\" . \
                                  \"A,B,C,D,E,F,G,H,I,J,K,L,\" . \
                                  \"M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,\" . \
                                  \"-,.,/\")
                :local asciival {48;49;50;51;52;53;54;55;56;57; \
                                 97;98;99;100;101;102;103;104;105;106;107;108; \
                                 109;110;111;112;113;114;115;116;117;118;119;120;121;122; \
                                 65;66;67;68;69;70;71;72;73;74;75;76; \
                                 77;78;79;80;81;82;83;84;85;86;87;88;89;90; \
                                 45;46;47}
                
                :local findindex;
                :local loop 1;
                :local key 0;
                :put \"\$input1\";
                :while (\$loop = 1) do={
                
                    :set key ([:terminal inkey])
                    
                    :if (\$key = 8) do={
                        :set output [pick \$output 0 ([:len \$output] -1)];
                        :if (\$echo != 1) do={
                            :put \"\r\$output              \";
                            /terminal cuu 0;
                        } else={
                            :local stars;
                            :if ([:len \$output] > 0) do={
                                :for x from=0 to=([:len \$output]-1) do={
                                    :set stars (\$stars . \"*\");
                                }    
                            }
                            :put \"\r\$stars                         \";
                            /terminal cuu 0;
                        }
                    }
                    
                    :if (\$key = 13) do={
                        :set loop 0;
                        put \"\";
                        } else={
                           
#                       # Convert numeric ascii value to ascii character
                        :set findindex [:find [:toarray \$asciival] \$key]
                        :if ([:len \$findindex] > 0) do={
                            :set key [:pick [:toarray \$asciichar] \$findindex]
                            :set output (\$output . \$key);
                            :if (\$echo != 1) do={
                                :put \"\r\$output                \";
                                /terminal cuu 0;
                            } else={
                                :local stars;
                                :for x from=0 to=([:len \$output]-1) do={
                                    :set stars (\$stars . \"*\");
                                    }
                                                            
                                :put \"\r\$stars                     \";
                                /terminal cuu 0;
                            }
                        }
                    }
                }
                :set output [:toarray \$output]
            };"
                


# -----------------
# End Functions







:put "Backing up your existing configuration to 'pre-hamwan'"
:put [/system backup save name=pre-hamwan]
:put "Configuring your radio for HamWAN"

:global ROSver value=[:tostr [/system resource get value-name=version]];
:global ROSverH value=[:pick $ROSver 0 ([:find $ROSver "." -1]) ];
:global ROSverL value=[:pick $ROSver ([:find $ROSver "." -1] + 1) [:len $ROSver] ];
#:if ([:len $ROSverL] < 2) do={ set $ROSverL value=("0".$ROSverL) };

:global ROSverN value=[:tonum ($ROSverL.$ROSverL)];
:if ($ROSverN < 600) do={
:put "Your RouterOS version is too old to continue!"
:put "Before we can begin, we must update your RouterOS version. Please press Y, wait for the radio to reboot, then reconnect to the router and re-run this script."
:put [/system reboot]
};


:global networks "Memphis,PSDR"
:put "The following network options are available: $networks"
    :global network;
    :set runFunc [:parse (":global network;" . \
             ":local input \"Enter network:\";" . \
                       $Prompt . \
             ":set network \$output")
         ]   
:local continue true;    
:global networkValues;
:while ($continue) do={
$runFunc
:set continue false;
:if ($network = "PSDR") do={
    :set networkValues {
        "remoteLoggingServer"=   "44.24.255.4";
        "primaryNtpServer"=      "44.24.244.4";
        "secondaryNtpServer"=    "44.24.245.4";
        "snmpCommunityAddresses"="44.24.255.0/25";
        "dnsServers"=            "44.24.244.1,44.24.245.1";
        "netAdmins"=             "eo,NQ1E,nigel,osburn,tom";
        "netDomain"=             "HamWAN.net";
        "subnetWithCidr"=        44.24.240.0/20;
        "callsign"=              "KI7WAN"
    };
} else={
:if ($network = "Memphis") do={
    :set networkValues {
        "remoteLoggingServer"=   "44.34.128.21";
        "primaryNtpServer"=      "44.34.132.3";
        "secondaryNtpServer"=    "44.34.133.3";
        "snmpCommunityAddresses"="44.34.128.0/28";
        "dnsServers"=            "44.34.132.1,44.34.133.1";
        "netAdmins"=             "ns4b,ryan_turner";
        "netDomain"=             "MemHamWAN.net";
        "subnetWithCidr"=        44.34.128.0/21;
        "callsign"=              "KM4ECM"
    };
} else={
:put "Invalid selection"
:set continue true;
}
}
} 
# Prompt for password - mask characters typed
    :global password;
    :set runFunc [:parse (":global password;" . \
             ":local input \"Enter new admin password or leave blank to skip:,1\";" . \
                       $Prompt . \
             ":set password \$output")
         ]
        
    $runFunc;
    
    if ([:len $password] > 0) do={ /user set admin password=$password }

:foreach netAdmin in [:toarray ($networkValues->"netAdmins")] do={
    :put [/user remove [find name=$netAdmin]]
    :put [/user add group=full name=$netAdmin password=$password]
    :local keyFile ("key-dsa-" . $netAdmin . ".txt")
    :do {
        :put [/user ssh-keys import public-key-file=$keyFile user=$netAdmin]
    } on-error={
        :put "Failed to import net admin user certificate for $netAdmin; most likely the files are missing? Looking for $keyFile"
    }
};

:put [/system logging action set 3 bsd-syslog=no name=remote remote=($networkValues->"remoteLoggingServer") remote-port=514 src-address=0.0.0.0 syslog-facility=daemon syslog-severity=auto target=remote]
:put [/system logging add action=remote disabled=no prefix="" topics=!debug,!snmp]
:put [/snmp set enabled=yes contact="#HamWAN on irc.freenode.org"]
:put [/snmp community set name=hamwan addresses=($networkValues->"snmpCommunityAddresses") read-access=yes write-access=no numbers=0]
:put [/ip dns set servers=($networkValues->"dnsServers")]
:put [/system ntp client set enabled=yes primary-ntp=($networkValues->"primaryNtpServer") secondary-ntp=($networkValues->"secondaryNtpServer")]
:put [/ip firewall filter remove [find]]
:put [/ip dhcp-server remove [find]]
:put [/ip dhcp-server network remove [find]]
:put [/ip dhcp-client remove [find]]
:put [/ip address remove [find]]
:put [/ip dns set allow-remote-requests=no]

:put "Done with base HamWAN configuration"
