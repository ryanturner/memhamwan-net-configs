/ip address add address=74.221.14.82 netmask=255.255.255.252 interface=[SFP however I do that]
/routing filter add chain=Ritter-HamWAN-In prefix=0.0.0.0/0 action=accept
/routing filter add chain=Ritter-HamWAN-In prefix=44.0.0.0 prefix-length=8-24 
/routing filter add chain=Ritter-HamWAN-In action=discard
/routing filter add chain=Ritter-HamWAN-Out prefix=44.34.128.0/21 action=accept
/routing filter add chain=Ritter-HamWAN-Out action=discard
/routing bgp instance add as=64522 name=Ritter-Private disabled=no redistribute-static=yes router-id=74.221.14.82
/routing bgp peer add default-originate=never in-filter=Ritter-HamWAN-In out-filter=Ritter-HamWAN-Out name=Ritter-Private instance=Ritter-Private remote-address=74.221.14.81 remote-as=23404
/routing bgp network add network=44.34.128.0/21
