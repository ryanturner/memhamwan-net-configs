# HamWAN Memphis Metro Easy Config
1. Download the contents of this branch using the following URL: https://github.com/ryanturner/memhamwan-net-configs/archive/client.zip
2. Open Winbox
2. Click on the "Neighbors" tab in the lower part of the Addresses window
3. Look for the entry labeled RB Metal 5SHPn under Board, and double click the MAC Address for it.
4. Click on the "Connect" button
5. Click on "Files" in the left hand menu
5. Extract the contents of the easy config zip file to a directory on your local machine, then drag and drop those files into the "Files" window
5. Click "New Terminal" and enter ```/import part-1.rsc```, then hit Y when prompted. The radio will disconnect and reboot.
6. Once you hear the device finish booting, as indicated by two short beeps, reconnect using the same procedure as before.
7. Click "New Terminal" and enter ```/import part-2.rsc```
