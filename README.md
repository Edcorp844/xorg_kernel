# xorg_kernel
This is an open source hybrid kernel that was created by [Frost Edson](https://edcorp844.github.io/FrostEdson) under the bachelors degree research in kampala International university in Uganda in 2023. It started as [xcorp kernel](https://github.com/Edcorp844/xcorp_kernel.git) which letter was integrated with the [MIT xv6](https://github.com/mit-pdos/xv6-public.git) to form the xorg kernel which is used by the Xos.
It remains open source unitl further notice..Feel free to use it for research work and study purposes.

## Install depandencies
* MacOs
```sh
#install homebrew first if you dont have it already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#THen Install Tools
brew install qemu build-essential gcc-multilib 
```
* Linux
  
```sh
# Ubuntu Or Debian:
sudo apt-get install qemu-system build-essential gcc-multilib 

#Fedora:
sudo dnf install qemu-system build-essential gcc-multilib 

# Arch & Arch-based:
paru -S qemu-system build-essential gcc-multilib 
```
### NOTE: to install all the required packages on Arch, you need an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers).

## BUILDING.

```sh
$ git clone "https://github.com/Edcorp844/xorg_kernel.git" 
$ cd xorg_kernel
$ make
```
## Running.
```sh
$ make qemu
```

