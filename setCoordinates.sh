#!/usr/bin/env bash


if [[ $# -eq 2 ]]
then
	sed "s/^RECEIVER_LAT=.*/RECEIVER_LAT=$1/" etc/default/dump1090-fa
	sed "s/^RECEIVER_LON=.*/RECEIVER_LON=$2/" etc/default/dump1090-fa

	echo -e "New coordinates set as $1, $2"
else
	echo -e "Provide 2 arguments. LAT and LON. Ensure that these are decimal numbers only. Negative for S and W"
fi
