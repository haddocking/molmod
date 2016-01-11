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
ln -sf /opt/software/dssp/dssp /opt/bin/

# Git repositories
echo "[++] Downloading & installing pdb-tools"
if [ -d /opt/software/pdb-tools ]
then
	cd /opt/software/pdb-tools
	git pull origin master
else
	git clone https://github.com/haddocking/pdb-tools /opt/software/pdb-tools > /dev/null
fi
ln -sf /opt/software/pdb-tools/*py /opt/bin

echo "[++] Downloading & installing biopython"
if [ -d /opt/software/biopython ]
then
	cd /opt/software/biopython
	git pull origin master
else
	git clone https://github.com/biopython/biopython /opt/software/biopython > /dev/null
fi
(cd /opt/software/biopython && CPPFLAGS="-w" python setup.py build && python setup.py install) > /dev/null

echo "[++] Downloading & installing pymol-psico"
if [ -d /opt/software/pymol-psico ]
then
	cd /opt/software/pymol-psico
	git pull origin master
else
	git clone https://github.com/JoaoRodrigues/pymol-psico.git /opt/software/pymol-psico > /dev/null
fi
(cd /opt/software/pymol-psico && git checkout legacy_support && CPPFLAGS="-w" python setup.py install) > /dev/null

echo "[++] Downloading & installing freesasa"
if [ -d /opt/software/freesasa ]
then
	cd /opt/software/freesasa
	git checkout with-configure 
	git reset HEAD --hard
	git pull origin with-configure
	autoconf && automake > /dev/null
else
	git clone https://github.com/JoaoRodrigues/freesasa /opt/software/freesasa > /dev/null
fi
(cd /opt/software/freesasa && git checkout with-configure && autoconf && automake && ./configure -q && CPPFLAGS="-w" make ) > /dev/null
ln -sf /opt/software/freesasa/src/freesasa /opt/bin/
ln -sf /opt/software/freesasa/share/naccess.config /opt/share/
