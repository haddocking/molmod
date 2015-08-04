#!/usr/bin/env bash

#
# General Provisioning for data files
# shared by several modules
#
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764
echo "[+] Provisioning: Module Data"
echo "[++] Downloading data for the molmod modules"
git clone https://github.com/JoaoRodrigues/molmod-data.git /opt/data/ > /dev/null

ln -s /opt/data/py/*py /opt/bin/
