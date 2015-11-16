#!/usr/bin/env bash

#
# Provisioning for the Docking module
#
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

echo "[+] Provisioning: Docking module"

# Clustal Omega
echo "[++] Downloading & installing Clustal Omega"
wget -q -O /opt/software/clustalo http://www.clustal.org/omega/clustalo-1.2.0-Ubuntu-32-bit > /dev/null
ln -s /opt/software/clustalo /opt/bin/

# WebLogo
echo "[++] Downloading & installing WebLogo"
git clone https://github.com/WebLogo/weblogo.git /opt/software/weblogo > /dev/null
ln -s /opt/software/weblogo/weblogo /opt/bin/
