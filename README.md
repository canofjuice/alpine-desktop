> [!CAUTION]
> This script currently doesn't work and causes XFCE to crash upon logging in. Rewrite in progress... FML

```
     ####################    
    ######################   
   ########   ###  ########         _    _       _              ____            _    _              
  #######   #   #    #######       / \  | |_ __ (_)_ __   ___  |  _ \  ___  ___| | _| |_ ___  _ __  
 ######   #####   #    ######     / _ \ | | '_ \| | '_ \ / _ \ | | | |/ _ \/ __| |/ / __/ _ \| '_ \ 
  ###      ######   #    ###     / ___ \| | |_) | | | | |  __/ | |_| |  __/\__ \   <| || (_) | |_) |
   ########################     /_/   \_\_| .__/|_|_| |_|\___| |____/ \___||___/_|\_\\__\___/| .__/ 
    ######################                |_|                                                |_|    
     ####################    
```
![Screenshot of the custom desktop layout.](/media/screenshot.png)

Straight forward script that installs the XFCE desktop, extra software and tweaks for a usable desktop Alpine experience.

## How to?

First, make sure you're logged in as the <ins>**root**</ins> user, created a regular user and have git installed:

```
apk add git
```
Change into the /tmp directory, git clone the repository and enter the repo's directory:
```
cd /tmp ; git clone https://github.com/canofjuice/alpine-desktop ; cd alpine-desktop
```
Finally, execute the script:
```
sh alpine-desktop.sh
```
From there, you will be asked some questions while the script is running until it's done.
