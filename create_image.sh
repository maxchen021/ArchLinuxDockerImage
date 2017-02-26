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

current_date=`date +%Y.%m.%d`

#download the archlinux image creation scripts
wget https://github.com/docker/docker/raw/master/contrib/mkimage-arch.sh

arch="$(uname -m)"
case "$arch" in
	armv*)
        pacman -S --noconfirm --needed archlinuxarm-keyring
		wget https://github.com/docker/docker/raw/master/contrib/mkimage-archarm-pacman.conf		
		version="$(echo $arch | cut -c 5)"
		orig_docker_image_name="armv${version}h/archlinux"
		new_docker_image_name="archlinux:${current_date}-armv${version}"
		;;
	*)
		wget https://github.com/docker/docker/raw/master/contrib/mkimage-arch-pacman.conf
		orig_docker_image_name="archlinux"
		new_docker_image_name="archlinux:${current_date}"
		;;
esac

chmod u+x mkimage-arch.sh

#execute the script to create the image
./mkimage-arch.sh

#rename the docker image with today's date
docker tag ${orig_docker_image_name} ${new_docker_image_name}

#display the new image name
echo "The following docker image has been created:"
echo "${new_docker_image_name}"

#cleanup
rm mkimage-arch.sh
if [ -f mkimage-arch-pacman.conf ]; then
    rm mkimage-arch-pacman.conf
fi
if [ -f mkimage-archarm-pacman.conf ]; then
    rm mkimage-archarm-pacman.conf
fi