
if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi

rm flp/rawOS.flp

echo ">>> Creating new floppy image..."
mkdosfs -C flp/rawOS.flp 1440 || exit


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o src/bootloader/bootloader.bin src/bootloader/bootloader.asm || exit


echo ">>> Assembling kernel..."

cd src
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..

echo ">>> Assembling programs..."

cd src/programs

for i in *.asm
do
	nasm -O0 -w+orphan-labels -f bin $i -o `basename $i .asm`.bin || exit
done

cd ..
cd ..


echo ">>> Adding bootloader to floppy image..."

dd status=noxfer conv=notrunc if=src/bootloader/bootloader.bin of=flp/rawOS.flp || exit


echo ">>> Copying kernel and programs..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat flp/rawOS.flp tmp-loop && cp src/kernel.bin tmp-loop/

cp src/programs/* tmp-loop

sleep 0.2

echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop


echo ">>> Creating CD-ROM ISO image..."

rm -f iso/rawOS.iso
mkisofs -quiet -V 'RAWOS' -input-charset iso8859-1 -o iso/rawOS.iso -b rawOS.flp flp/ || exit

echo '>>> Done!'
