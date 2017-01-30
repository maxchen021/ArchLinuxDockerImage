# ArchLinuxDockerImage

Since there's no official Arch Linux docker image, I've decided to build my own using the script in the official docker github repo.
This is basically a wrapper script for creating the Arch Linux docker image. It takes care of installing all the necessary tools to create the docker image.

### Prerequisite

Arch Linux system

### Usage

clone the repo and run the following commands:

```sh
$ chmod 755 create_image.sh
$ sudo ./create_image.sh
```

