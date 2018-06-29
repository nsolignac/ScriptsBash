#First, find out which device your USB stick is.

lsblk

#Store the device full path /dev/sd?? where ?? is the partition name from previous output.

read DEVICE

#Unmount the device/partition (if necessary).

umount $DEVICE

#To format as FAT32:

mkdosfs -F 32 -I $DEVICE 


