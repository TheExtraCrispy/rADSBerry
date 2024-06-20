# Description

rADSBerry is a silly name I gave to a standalone local ADSB receiver running on a pi with a bladeRF.

Message reception and processing is handled on the bladeRF through an FPGA image specialized for ADSB reception.

The pi hosts a local network which you can connect to and view the decoded messages on a map without requiring an internet connection.


#Requirements/components

tar1090

tar1090 offline files

dump1090-fa

bladeRF-ADSB

libbladeRF

hostAPD

dnsmasq

netfilter-persistent

iptables-persistent
# Setting up access point

Install and enable dnsmasq and hostapd

```
sudo apt install hostapd

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
```
-------------I DONT HONESTLY KNOW IF THIS PART IS NEEDED YET--------------------------
Installing netfilter and iptables

```
sudo DEBIA_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
```

Configuration
```
sudo nano /etc/dhcpcd.conf
```

Add to the bottom of the file:
```
interface wlan0
hook wpa_supplicant
```

Create this file with the following contents:
```
sudo nano /etc/sysctl.d/routed-ap.conf
```

```
net.ipv4.ip_forward=1
```

```
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

```
sudo netfilter-persistent save
```

------pretty sure yoy need this part-----------
```
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo nano /etc/dnsmasq.conf
```
Add this to the file:
```
interface=wlan0
dhcp-range=192.168.11.2,192.168.11.20,255.255.255.0,24h

domain=wlan
address=/gw.wlan/192.168.11.1
```

Ensure it isn't blocked
```
sudo rfkill unblock wlan
```

```
sudo raspi-config
```
Set your network location correctly


#Configuring the hosted network:
```
sudo nano /etc/hostapd/hostapd.conf
```

```
country_code=US
interface=wlan0
ssid=YOUR NETWORK NAME HERE
hw_mode=a (note, set this to b if using earlier than rpi 3b+)
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=YOUR NETWORK PASSWORD HERE
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

Reboot the pi and hopefully the network comes up.

#Dump1090-fa

Dump1090 should be able to be installed by a package manager

```
sudo apt install dump1090-fa
```

To configure the receiver:
```
sudo nano /etc/default/dump1090-fa
```

# remember to upload the premade config file

#Tar1090 Offline map files
This is the slow part. To serve the map tiles offline they need to be downloaded and stored locally. Theres two qualities:
Required Tiles: 700mb download, 2gb on disk. Supports a limited amount of zoom.
Extra Detailed Tiles: Requires previous tiles, allows more zooming. 1.3GB download, 4GB on disk.

To install required files:
```
curl https://raw.githubusercontent.com/wiedehopf/adsb-scripts/master/osm_tiles_offline.sh | sudo bash
```

To install extra detailed tiles:
```
curl https://raw.githubusercontent.com/wiedehopf/adsb-scripts/master/osm_tiles_offline_10.sh | sudo bash
```

#Tar1090
To create the webserver at the root eg: adsb.local instead of adsb.local/tar1090:

Create the following file with contents before installing:
```
/run/dump1090-fa webroot
```

The creator of tar1090 provides an installation script:
```
sudo bash -c "$(wget -nv -0 - https://github.com/wiedehopf/tar1090/raw/master/install.sh)"
```

To configure tar1090:
```
sudo nano /etc/default/tar1090-webroot
```

To configure the webpage itself:
```
sudo nano /usr/local/share/tar1090/html-webroot/config.js
```

# NOTE TO ME: ADD INSTRUCTIONS TO CONFIGURE FOR OFFLINE MAP


#BladeRF-ADSB

Requires libbladerf, i reccommend building the latest version from source. The package managers seem to have outdated versions.

I've got a repo of a slightly modified version of Nuand's bladerf-adsb code

Uses the same FPGA image, just altered with a service file and different support for newer devices

Should have an install script which you just run as 
```
sudo ./install.sh
```

Enable the bladeRF service with 
```
sudo systemctl daemon-reload

sudo systemctl enable bladeRF-adsb.service
```


# done(?)
Now when you reboot the pi it should put up the network. This should show up on other devices under the name you chose previously

Connecting to this (It may spin forever but it should still work), you should be able to go to

adsb.local, or in some browsers http://adsb.local (https seems to break it)

It should show 

A map with tiles, even when not conneced to internet/data

Planes showing up on the map, if you have a messages per second above 0, the decoder is working

# Troubleshooting
Tar1090 says it cant connect to receiver:
The decoder dump1090-fa is down, or otherwise not connecting to the tar1090 server. Make sure that its running and it's creating some kind of file in /run/dump1090-fa

No messages:
Make sure the connections are all good. You can check on the bladeRF decoder with 
```
systemctl status bladeRF-adsb.service
```
or
```
journalctl -u bladeRF-adsb.service
```

No network showing up:
Make sure the pi isnt connecting to any other networks. If it automatically connects to a network it remembers, it will take down the access point.
Can also check to make sure rfkill isnt blocking it. Check for error messages in the status of hostapd

No map tiles showing up:
Make sure the offline map tiles are downloaded. If offline tiles dont appear on the list of available maps, something went wrong with the installation.
By default tar1090 starts with the normal online maps selected, you can replace this in the config to start on the offline file

bladeRF transfer errors:
Make sure that you have the latest FPGA images and latest version of libbladerf

