#!/usr/bin/env bash

git clone https://github.com/flightaware/dump1090

cd dump1090

make RTLSDR=no HACKRF=no LIMESDR=no SOAPYSDR=no

cd dump1090 /usr/bin/dump1090-fa

cd ..

cp dump1090-fa /etc/default/dump1090-fa

mkdir /usr/share/dump1090-fa
cp start-dump1090-fa /usr/share/dump1090-fa

cp dump1090-fa.service /etc/systemd/system/dump1090-fa.service


systemctl daemon-reload
systemctl enable dump1090-fa.service
