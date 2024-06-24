#!/usr/bin/env bash

echo -e "\n Installing hostapd and dnsmasq..."

sudo apt install hostapd

sudo systemctl unmask hostapd
sudo systemctl enable hostapd

sudo apt install dnsmasq

sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

last=$(tail -n 1 /etc/dhcpcd.conf)

if [ "$last" = "nohook wpa_supplicant" ]
then
	echo -e "dhcpcd.conf already configured."
else
	echo -e "Configuring dhcpcd.conf..."
	echo -e "Saving original as dhcpcd.conf.orig"
	mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

	echo -e "\ninterface wlan0\n static ip_address=192.168.11.1/24\nnohook wpa_supplicant" >> /etc/dhcpcd.conf
fi

echo -e "dhcpcd.conf configuration done.\n"



echo -e "Configuring dnsmasq.conf"

if [ -f /etc/dnsmasq.conf.orig ]
then
	echo -e "dnsmasq.conf already configured."
else
	echo -e "Saving original as dnsmasq.conf.orig"
	mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
	cp dnsmasq.conf /etc/dnsmasq.conf
fi

echo -e "dnsmasq.conf done."


echo -e "Configuring hostapd.conf"

if [[ $# -ge 2 ]]
then
	sed -i "s/^ssid=.*/ssid=$1/" hostapd.conf
	sed -i "s/^wpa_passphrase=.*/wpa_passphrase=$2/" hostapd.conf

	cp hostapd.conf /etc/hostapd/hostapd.conf

	echo -e "hostapd configured.\n"

	echo -e "Unblocking wifi in rfkill."

	rfkill unblock wlan

	echo -e "\n DONE!"

	echo -e"\n Please make sure your network location is set correctly in raspi-config, then reboot the pi. Hopefully your network will come up."

else
	echo -e "Please provide your desired SSID and passphrase as 2 arguments."
fi
