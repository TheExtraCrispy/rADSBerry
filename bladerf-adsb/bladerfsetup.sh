#!/usr/bin/env bash



echo -e "\nDownloading bladerf-adsb..."
git clone https://github.com/TheExtraCrispy/bladeRF-adsb

cd bladeRF-adsb/bladeRF_adsb

echo -e "\nDownloading FPGA images..."
wget http://nuand.com/fpga/adsbx40.rbf
wget http://nuand.com/fpga/adsbx115.rbf
wget http://nuand.com/fpga/adsbxA4.rbf
wget http://nuand.com/fpga/adsbxA5.rbf
wget http://nuand.com/fpga/adsbxA9.rbf

echo -e "\nBuilding bladerf-adsb..."
make

echo -e "\nSetting up service..."

cd ..

./install.sh

systemctl daemon-reload
systemctl enable bladeRF-adsb.service


echo "Done."


