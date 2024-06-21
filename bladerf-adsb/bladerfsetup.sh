#!/usr/bin/env bash

#pull down my github files
#download images
#build

systemctl daemon-reload
systemctl enable bladeRF-adsb.service


echo "Downloading bladerf-adsb..."
git clone github.com/theextracrispy/bladerf-adsb

cd bladerf-adsb/bladerf_adsb

echo "Downloading FPGA images..."
wget http://nuand.com/fpga/adsbx40.rbf
wget http://nuand.com/fpga/adsbx115.rbf
wget http://nuand.com/fpga/adsbxA4.rbf
wget http://nuand.com/fpga/adsbxA5.rbf
wget http://nuand.com/fpga/adsbxA9.rbf

echo "Building bladerf-adsb..."
make

echo "Done."


