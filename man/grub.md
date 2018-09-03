Разрешение консоли:
В зависимости от версии grub открываете файл /boot/grub/menu.lst или /boot/grub/grub.cfg, 
находите секцию menuentry и в конец строки linux/boot/vmlinuz-2.6.32-5-amd64 root=... добавляете vga=795

Depth/24bit  
	
800×600  1024×768  1280×1024  1600×1200 
vga=789  vga=792   vga=795   vga=799

добавить в grub.cfg 
GRUB_CMDLINE_LINUX_DEFAULT="quiet vga=773" 


## uefi
lsmod | grep efivarfs
efibootmgr -c -L sabayon -l \\EFI\\sabayon\\grubx64.efi
Затем смотрим порядок загрузки в биосе

Возможные варианты загрузки ищем в /boot/efi

