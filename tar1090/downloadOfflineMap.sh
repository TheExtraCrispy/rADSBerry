#!/usr/bin/env bash

if [ "$1" = "extra" ]
then
	curl https://raw.githubusercontent.com/wiedehopf/adsb-scripts/master/osm_tiles_offline.sh | sudo bash
else
	curl https://raw.githubusercontent.com/wiedehopf/adsb-scripts/master/osm_tiles_offline_10.sh | sudo bash


