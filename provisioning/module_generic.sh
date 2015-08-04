#!/usr/bin/env bash

#
# General Provisioning for scientific software
# shared by several modules
#
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

echo "[+] Provisioning: General Scientific Software"

# Download DSSP
echo "[++] Downloading & installing dssp"
mkdir -p /opt/software/dssp
wget -q -O /opt/software/dssp/dssp ftp://ftp.cmbi.ru.nl/pub/software/dssp/dssp-2.0.4-linux-i386 > /dev/null
chmod a+x /opt/software/dssp/dssp
ln -s /opt/software/dssp/dssp /opt/bin/

# Git repositories
echo "[++] Downloading & installing pdb-tools"
git clone https://github.com/haddocking/pdb-tools /opt/software/pdb-tools > /dev/null
ln -s /opt/software/pdb-tools/*py /opt/bin

echo "[++] Downloading & installing biopython"
git clone https://github.com/biopython/biopython /opt/software/biopython > /dev/null
(cd /opt/software/biopython && python setup.py build && python setup.py install) > /dev/null
