#!/usr/bin/env bash

echo -e "\n Installing hostapd and dnsmasq..."

sudo apt install hostapd

sudo systemctl unmask hostapd
sudo systemctl enable hostapd

sudo apt install dnsmasq

last=$(tail -n 1 test.txt)

if [ "$last" = "hook wpa_supplicant" ]
then
	echo -e "dhcpcd.conf already configured."
else
	echo -e "Configuring dhcpcd.conf..."
	echo -e "Saving original as dhcpcd.conf.orig"
	#mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

	echo -e "\ninterface wlan0 \nhook wpa_supplicant" >> test.txt
fi

echo -e "dhcpcd.conf configuration done.\n"


#echo -e "Configuring routed-ap.conf"

#if [ -f /etc/sysctl.d/routed-ap.conf ]
#then
#	echo -e "routed-ap.conf already exists."
#else
#	echo -e "Creating routed-ap.conf"
#	echo "net.ipv4.ip_forward=1"
#fi
#echo -e "routed-ap.conf done.\n"


echo -e "Configuring dnsmasq.conf"

if [ -f /etc/dnsmasq.conf.orig ]
then
	echo -e "dnsmasq.conf already configured."
else
	echo -e "Saving original as dnsmasq.conf.orig"
	#mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
	#cp dnsmasq.conf /etc/dnsmasq.conf
fi

echo -e "dnsmasq.conf done."


echo -e "Configuring hostapd.conf"

if [[ $# -ge 2 ]]
then
	sed -i "s/^ssid=.*/ssid=$1/" hostapd.conf
	sed -i "s/^wpa_passphrase=.*/wpa_passphrase=$2/" hostapd.conf
else
	echo -e "Please provide your desired SSID and passphrase as 2 arguments."
fi

echo -e "hostapd configured.\n"

echo -e "Unblocking wifi in rfkill."

rfkill unblock wlan

echo -e "\n DONE!"

echo -e"\n Please make sure your network location is set correctly in raspi-config, then reboot the pi. Hopefully your network will come up."
