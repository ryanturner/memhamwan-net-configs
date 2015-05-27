# HamWAN Memphis Metro Easy Config
1. Download the contents of this branch by clicking [here](https://github.com/ryanturner/memhamwan-net-configs/archive/client.zip), and download [Winbox](http://download2.mikrotik.com/routeros/winbox/3.0rc9/winbox.exe)
3. Open winbox.exe
4. Click on the "Neighbors" tab in the lower part of the Addresses window
5. Look for the entry labeled RB Metal 5SHPn under Board, and double click the MAC Address for it
6. Check the box "Open In New Window"
7. Click on the "Connect" button; don't worry, the pre-filled settings for user "admin" and no password are the default
8. Click on "Files" in the left hand menu
9. Extract the contents of the easy config zip file to a directory on your local machine, then drag and drop those files into the "Files" window
10. Click "New Terminal" and enter ```/import part-1.rsc```, then hit Y when prompted; the radio will disconnect and reboot
11. Once you hear the device finish booting, as indicated by two short beeps, reconnect by repeating step 7
12. Click "New Terminal" and enter ```/import part-2.rsc```
