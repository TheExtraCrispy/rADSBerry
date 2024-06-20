# Description

rADSBerry is a silly name I gave to a standalone local ADSB receiver running on a pi with a bladeRF.

Message reception and processing is handled on the bladeRF through an FPGA image specialized for ADSB reception.

The pi hosts a local network which you can connect to and view the decoded messages on a map without requiring an internet connection.


# Requirements/components

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

The script in the access-point directory should automatically install the required packages and configure them.
When you run the script, supply it with the desired SSID and passphrase:
```
sudo ./APSetup.sh YourNetworkNameHere YourPassphraseHere
```


# Dump1090-fa

The script in the dump1090 directory should automatically install and configure dump1090-fa for the bladeRF.

#Tar1090 Offline map files
This is the slow part. To serve the map tiles offline they need to be downloaded and stored locally. Theres two qualities:
Required Tiles: 700mb download, 2gb on disk. Supports a limited amount of zoom.
Extra Detailed Tiles: Requires previous tiles, allows more zooming. 1.3GB download, 4GB on disk.

To install required files:

```
sudo ./downloadOfflineMap
```

To then install extra detailed tiles:
```
sudo ./downloadOfflineMap Extra
```

# Tar1090

The script under tar1090 should automatically install and configure the webserver. It can be accessed through the hosted network under HOSTNAME.local, whatever your hostname on the device is.
NOTE: Only run this AFTER you've installed dump1090-fa and all the offline map files you want.

```
sudo ./setuptar1090
```

# BladeRF-ADSB

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

