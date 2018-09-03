 WebDav client
====================

### install davfs2

Set up permissions:
sudo chmod 4755 /usr/sbin/mount.davfs
sudo usermod -aG davfs2 $USER
echo "https://example.com/webdav.php MyName 12345" > $HOME/.davfs2/secrets
chmod 600 $HOME/.davfs2/secrets
echo "$WebDAV_Address $PathToMountPoint davfs user,rw,noauto 0 0" > /mnt/fstab
mount /mnt/webdev_dir

rsync -r --size-only /hdd/test/ /cloud/test/  --temp-dir=/tmp --no-owner --no-group
encfs - шифрование поверх существующих файлов

### cadaver 
Command line client for webdav

Add to config file: 
In ~/.cadaverrc you can put line

open https://webdav.example.com/

In ~/.netrc put

default
login %login%
password %password%



