mkdir -p /usr/local/share/weffe/static
install -Dm755 ./weffe "/usr/local/share/weffe/weffe"
install -Dm644 ./help.md "/usr/local/share/weffe/"

install -t "/usr/local/share/weffe/static" static/*.png

echo "#!/bin/bash
 /usr/local/share/weffe/weffe \"\$@\"" >> ./tempbin
install -Dm755 ./tempbin "/usr/local/bin/weffe"
rm ./tempbin

sudo echo "v4l2loopback" > /etc/modules-load.d/v4l2loopback.conf
sudo echo "options v4l2loopback video_nr=7 card_label=\"Weffe\" exclusive_caps=1" > /etc/modprobe.d/v4l2loopback.conf
sudo update-initramfs -c -k $(uname -r)

version=$(git describe --long | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g')

echo "Successfully installed weffe v$version locally"
