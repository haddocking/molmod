#!/usr/bin/env bash

#
# General Provisioning for data files
# shared by several modules
#
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764
echo "[+] Provisioning: Module Data"
echo "[++] Downloading data for the molmod modules"
if [ -d /opt/data/.git ]
then
	cd /opt/data/
	git pull origin master
else
	git clone https://github.com/haddocking/molmod-data.git /opt/data/ > /dev/null
fi

ln -sf /opt/data/py/*py /opt/bin/
