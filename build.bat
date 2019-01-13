@echo off

echo Building rawOS

del flp\rawOS.flp
del iso\rawOS.iso

echo Building bootloader...
nasm -O0 -w+orphan-labels -f bin -o src\bootloader\bootloader.bin src\bootloader\bootloader.asm
echo -> src\bootloader\bootloader.bin

echo Building kernel...
cd src
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm
cd ..
echo -> src\kernel.bin

echo Building programs...
cd src\programs
 for %%i in (*.asm) do nasm -O0 -f bin %%i
 for %%i in (*.bin) do del %%i
 for %%i in (*.) do ren %%i %%i.bin
cd ..
cd ..

echo Adding bootloader to floppy image...
partcopy src\bootloader\bootloader.bin 0 200 flp\rawOS.flp 0

echo Copying kernel and programs...
imdisk -a -f flp/rawOS.flp -s 1440K -m B:

copy src\kernel.bin b:\
