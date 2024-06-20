#!/usr/bin/env bash

cp tar1090_instances /etc/default/tar1090_instances

bash -c "$(wget -nv -O - https://github.com/wiedehopf/tar1090/raw/master/install.sh)"

cp tar1090-webroot /etc/default/tar1090-webroot

cp config.js /usr/local/share/tar1090/html-webroot/config.js

systemctl restart tar1090
