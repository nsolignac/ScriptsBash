#List all drives.
echo "List all drives to select the target (the name must be without numbers)"
lsblk

#Ask the user the name of the drive and store it (has to be the root drive. Eg. /dev/sdb, /dev/sda.
echo "Name of the drive (without numbers): "
read DRIVE

#Ask the user the path to the ISO file and store it.
echo "Full path to the iso file: "
read ISO

#Unmount the driver to be used.
sudo umount /dev/$DRIVE

#Create the bootable disc.
echo "Where"$ISO" is the input file, and /dev/"$DRIVE" is the dest address"
sudo dd bs=4M if=$ISO of=/dev/$DRIVE conv=fdatasync