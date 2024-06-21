#!/usr/bin/env bash

echo -e "Installingng dependencies.."
apt-get install libusb-1.0-0-dev libusb-1.0-0 build-essential cmake libncurses5-dev libtecla1 libtecla-dev pkg-config git wget

#clone repo
echo -e "Downloading repo..."
git clone https://github.com/Nuand/bladeRF.git ./bladeRF

echo -e "Building libbladerf..."
cd bladeRF/host
mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DINSTALL_UDEV_RULES=ON ../
sudo make
sudo make install
sudo ldconfig

echo -e "Done. Hopefully worked."
