Create Ram-dist 
=================

add to /etc/fstab line:
tmpfs   /tmp         tmpfs   nodev,nosuid,size=2G          0  0

mount -o remount,size=4G,noatime /tmp

List partition:
findmnt --target /tmp

!! True commands, not /etc/fstab edit:
mount -t tmpfs -o size=1G,mode=0777 tmpfs /space
