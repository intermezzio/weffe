mkdir -p /usr/local/share/weffe/static
install -Dm755 ./weffe "/usr/local/share/weffe/weffe"
install -Dm644 ./help.md "/usr/local/share/weffe/"

install -t "/usr/local/share/weffe/static" static/*.png

echo "#!/bin/sh
 /usr/local/share/weffe/weffe \"\$@\"" >> ./tempbin
install -Dm755 ./tempbin "/usr/local/bin/weffe"
rm ./tempbin

echo "Successfully installed weffe locally"
