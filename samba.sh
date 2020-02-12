!/bin/bash

# Description: Script to install and configure Samba in Ubuntu.
# Author: Gustavo Salazar L.
# Date: 2013-03-27

#
# How to use:
#   chmod +x samba-access.sh
#   ./samba-access.sh PATH_TO_SHARED_DIRECTORY  PERMISSIONS
#
#
# $1 = path , e.g. /home/myuser/publicdir
# $2 = permissions  ,  e.g  755
#


if [ -z "$1" ];then
  echo "How to use this script?"
  echo "./samba-acess.sh  PATH_TO_SHARED_DIRECTORY  PERMISSIONS"
  exit 0
fi

if [ -z "$2" ];then
  echo "Pass the persmissions of the directory you want to share as the second parameter."
  exit 0
fi



# Install Samba

samba_not_installed=$(dpkg -s samba 2>&1 | grep "not installed")
if [ -n "$samba_not_installed" ];then
  echo "Installing Samba"
  sudo apt-get install samba -y
fi

# Configure directory that will be accessed with Samba

echo "
[public]
comment = My Public Folder
path = $1
public = yes
writable = yes
create mast = 0$2
force user = nobody
force group = nogroup
guest ok = yes
security = SHARE
" | sudo tee -a /etc/samba/smb.conf

 
#systemctl enable smb
sudo /etc/init.d/smbd enable

# Restart Samba service

sudo /etc/init.d/smbd restart

# Give persmissions to shared directory

sudo chmod -R $2 $1

# Message to the User
 echo "To access the shared machine from Windows :"
 echo "\\\\$(ifconfig eth0 | sed -n 's/.*dr:\(.*\)\s Bc.*/\1/p')"
