#!/bin/bash

#update pacman database in arch linux
pacman -Sy

#install docker
pacman -S --noconfirm --needed docker

#start docker service if it's not running
if [ `ps -ef | grep docker | grep -v grep | wc -l` -eq "0" ]; then 
    systemctl start docker
fi

#install the dependency programs
pacman -S --noconfirm --needed wget
pacman -S --noconfirm --needed arch-install-scripts
pacman -S --noconfirm --needed expect

#download the archlinux image creation scripts
wget https://github.com/docker/docker/raw/master/contrib/mkimage-arch.sh
wget https://github.com/docker/docker/raw/master/contrib/mkimage-arch-pacman.conf
chmod u+x mkimage-arch.sh

#execute the script to create the image
./mkimage-arch.sh

#rename the docker image with today's date'
current_date=`date +%Y.%m.%d`
docker tag archlinux archlinux:${current_date}

#display the new image name
echo "The following docker image has been created:"
echo "archlinux:${current_date}"

#cleanup
rm mkimage-arch.sh
rm mkimage-arch-pacman.conf