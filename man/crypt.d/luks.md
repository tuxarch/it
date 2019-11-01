Create crypt image
======================

dd if=/dev/zero bs=1M count=100 of=~/my-container.img
sudo cryptsetup luksFormat ~/mycontainer
sudo cryptsetup luksOpen ~/mycontainer secret-device < YES (uppercase)
sudo mkfs.ext4 /dev/mapper/secret-device
sudo mount /dev/mapper/secret-device ~/my-mount-point
sudo umount ~/my-mount-point
sudo cryptsetup luksClose secret-device

Simply mount 
sudo cryptsetup luksOpen ~/mycontainer secret-device
sudo mount /dev/mapper/secret-device ~/my-mount-point

Софт для винды: FreeOTFE

Работа с целым диском
========================

sudo cryptsetup -v --type luks --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 2000 --use-urandom --verify-passphrase luksFormat /dev/sdc
sudo cryptsetup open /dev/sdc dm_dev
sudo mkfs.ext4 -b 4096 /dev/mapper/dm_dev
sudo mount /mnt/usb

sudo umount /mnt/usb
sudo cryptsetup close dm_dev

