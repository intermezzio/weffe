rm -rf /usr/local/share/weffe
rm /usr/local/bin/weffe

sudo rm -f /etc/modules-load.d/v4l2loopback.conf 
sudo rm -f /etc/modprobe.d/v4l2loopback.conf

echo "Successfully uninstalled weffe locally"
