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
                                  \".,/\")
                :local asciival {48;49;50;51;52;53;54;55;56;57; \
                                 97;98;99;100;101;102;103;104;105;106;107;108; \
                                 109;110;111;112;113;114;115;116;117;118;119;120;121;122; \
                                 65;66;67;68;69;70;71;72;73;74;75;76; \
                                 77;78;79;80;81;82;83;84;85;86;87;88;89;90; \
                                 46;47}
                
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




:import base.rsc
:put [/ip firewall mangle remove [find comment=hamwan-auto]]
:put [/ip firewall mangle add action=change-mss chain=output new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378 comment=hamwan-auto]
:put [/ip firewall mangle add action=change-mss chain=forward new-mss=1378 protocol=tcp tcp-flags=syn tcp-mss=!0-1378 comment=hamwan-auto]
:put [/interface wireless channels remove [find list=HamWAN]]

:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5915 list=HamWAN name=Sector1-20 width=20]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5885 list=HamWAN name=Sector2-20 width=20]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5855 list=HamWAN name=Sector3-20 width=20]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5900 list=HamWAN name=Sector2-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5880 list=HamWAN name=Sector3-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Extra channel" frequency=5860 list=HamWAN name=Sector4-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Extra channel" frequency=5840 list=HamWAN name=Sector5-10 width=10]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 0 degrees (north)" frequency=5920 list=HamWAN name=Sector1-5 width=5]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 120 degrees (south-east)" frequency=5905 list=HamWAN name=Sector2-5 width=5]
:put [/interface wireless channels add band=5ghz-onlyn comment="Cell sites radiate this at 240 degrees (south-west)" frequency=5890 list=HamWAN name=Sector3-5 width=5]
:put [/interface wireless channels add band=5ghz-onlyn comment="Extra channel" frequency=5875 list=HamWAN name=Sector4-5 width=5]
:put [/interface wireless channels add band=5ghz-onlyn comment="Extra channel" frequency=5875 list=HamWAN name=Sector4-5 width=5]
:put [/interface wireless channels add band=5ghz-onlyn comment="Extra channel" frequency=5860 list=HamWAN name=Sector5-5 width=5]
:put [/interface wireless channels add band=5ghz-onlyn comment="Extra channel" frequency=5845 list=HamWAN name=Sector6-5 width=5]
:put [/interface wireless set 0 disabled=no frequency-mode=superchannel scan-list=HamWAN ssid=HamWAN wireless-protocol=nv2 mode=station]
:put [/ip dhcp-client add add-default-route=yes dhcp-options=hostname,clientid disabled=no interface=wlan1]


# Prompt for callsign
    :global callsign;
    :set runFunc [:parse (":global callsign;" . \
             ":local input \"Enter your callsign:\";" . \
                       $Prompt . \
             ":set callsign \$output")
         ]

    $runFunc;

    if ([:len $callsign] > 0) do={ /interface wireless set 0 radio-name=$callsign; \
        /system identity set name=$callsign;
    }


# Prompts for y/n
:put "Now let's configure your LAN (ethernet) side of the radio"
:put "Press C to have the radio act as a DHCP client on the ethernet; use if you're integrating with an existing network"
:put "Press S to have the radio act as a DHCP server on the ethernet; use if you're running this without a separate router"
:put "Press T to configure a static IP; use if you're integrating with an existing network and you're a bit more advanced"
:put "Press N to not configure anything additionally on the LAN port"
:local prompt "Please select your option [C,S,T,N]"
:local options "c,s,t,n"

# Array of ascii values and ascii characters
# The ascii values directly correspond to a single ascii character
# asciicharlower and asciicharupper are used for character conversions
:local asciicharlower ("a,b,c,d,e,f,g,h,i,j,k,l," . \
                                  "m,n,o,p,q,r,s,t,u,v,w,x,y,z")
:local asciicharupper ("A,B,C,D,E,F,G,H,I,J,K,L," . \
                                   "M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z")
:local asciichar ("0,1,2,3,4,5,6,7,8,9," . \
                         "a,b,c,d,e,f,g,h,i,j,k,l," . \
                         "m,n,o,p,q,r,s,t,u,v,w,x,y,z," . \
                         "A,B,C,D,E,F,G,H,I,J,K,L," . \
                         "M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z," . \
                         ".,/")
:local asciival {48;49;50;51;52;53;54;55;56;57; \
                       97;98;99;100;101;102;103;104;105;106;107;108; \
                       109;110;111;112;113;114;115;116;117;118;119;120;121;122; \
                       65;66;67;68;69;70;71;72;73;74;75;76; \
                       77;78;79;80;81;82;83;84;85;86;87;88;89;90; \
                       46;47}

:local key
:local findindex
:local validoption

:set key 0
:set validoption 0

# Prompt for input
:put ($prompt)

# Wait until valid option is entered
:while ($validoption = 0) do={

   :set key ([:terminal inkey])

# Convert numeric ascii value to ascii character
   :set findindex [:find [:toarray $asciival] $key]
   :if ([:len $findindex] > 0) do={
      :set key [:pick [:toarray $asciichar] $findindex]
   }


# If key is uppercase, convert it to lowercase
   :set findindex [:find [:toarray $asciicharupper] $key]
   :if ([:len $findindex] > 0) do={
      :set key [:pick [:toarray $asciicharlower] $findindex]
   }

# Check if key is a valid option
   :set findindex [:find [:toarray $options] $key]
   :if ([:len $findindex] > 0) do={
      :set validoption 1
   }

# end while validoption = 0
}


# Evaluate input
# At this point, key is converted to lower case
:if ($key = "s") do={
:put ("Setting up a DHCP server")
:put [/ip firewall nat add chain=srcnat action=masquerade out-interface=wlan1]
:put [/ip address add address=10.0.0.1/24 interface=ether1]
:put [/ip pool remove [find name=dhcp-pool]]
:put [/ip pool add name=dhcp-pool ranges=10.0.0.10-10.0.0.254]
:put [/ip dhcp-server network add address=10.0.0.0/24 gateway=10.0.0.1]
:put [/ip dhcp-server add interface=ether1 address-pool=dhcp-pool disabled=no]
}
:if ($key = "t") do={
:put ("Setting up a static IP")
    :global staticIp;
    :set runFunc [:parse (":global staticIp;" . \
             ":local input \"Enter the desired IP in format like 192.168.0.1/24:\";" . \
                       $Prompt . \
             ":set staticIp \$output")
         ]

    $runFunc;

    if ([:len $staticIp] > 0) do={
        :put [/ip firewall nat add chain=srcnat action=masquerade out-interface=wlan1]
        :put [/ip address add address=$staticIp interface=ether1]
    }
}
:if ($key = "n") do={
   :put ("Not performing any ethernet integration config; you will need to do this yourself.")
}
:if ($key = "c") do={
    :put ("Seeting up a DHCP client")
    :put [/ip firewall nat add chain=srcnat action=masquerade out-interface=wlan1]
    :put [/ip dhcp-client add add-default-route=no disabled=no interface=ether1]
}
:put "Setup complete!"
:put [/system reboot]
