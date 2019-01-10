# rawOS
rawOS is a educational project made by me Jacob to learn more about low-level programming
# Building
The repository should already come with a floppy image and an iso image.
The repository currently only supports building with linux.
To build you'll need to be admin or root to be able to build

Building with root:
> ./build.sh
Building with sudo:

> sudo ./build.sh

# Running
The operating system runs in 16-bit. Which means it can not be ran on a 64-bit computer. You need to use a 32-bit computer or an emulator.
The emulator i recommend is qemu:

Installing on linux

> sudo apt install qemu

[On windows you need to install it through the website](https://www.qemu.org/)

On linux it pretty straight forward. In the repository folder run:

> qemu-system-i386 -fda ./flp/rawOS.flp

On windows you can use powershell

> & '%PATH TO YOUR QEMU INSTALL FOLDER%\qemu-system-i836.exe' -fda .\flp\rawOS.flp
