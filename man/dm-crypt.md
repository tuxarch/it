Simple crypt folder
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
