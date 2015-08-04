#!/usr/bin/env bash

#
# General provisioning script
#

## Avoid errors here and there
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

## Make /opt directory structure
echo "[+] Creating /opt directory structure"
mkdir /opt/database /opt/software /opt/bin

## Copy assets
echo "[+] Copying assets"

cp /vagrant/assets/config/bashrc ~haddocker/.bashrc
chown haddocker:haddocker ~haddocker/.bashrc

cp /vagrant/assets/config/bash_profile ~haddocker/.bash_profile
chown haddocker:haddocker ~haddocker/.bash_profile

## Update system & Install packages
echo "[+] Updating system and installing packages"
add-apt-repository ppa:lucid-bleed/ppa &> /dev/null # dpkg, req. for MODELLER
add-apt-repository ppa:roblib/ppa &> /dev/null # cmake, req. for GROMACS
(apt-get -qq update && apt-get -qq -y upgrade && apt-get -qq -y dist-upgrade) > /dev/null

# Building tools
apt-get install -y --no-install-recommends cmake build-essential > /dev/null

# Python libs
apt-get install -y --no-install-recommends python-numpy python-matplotlib \
                                           python-dev > /dev/null

#
## Download & Compile scientific software
#

cd /opt/software

# HMMER
echo "[+] Downloading & installing HMMER"
wget -q http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz > /dev/null
tar -xzf hmmer-3.1b2.tar.gz
cd hmmer-3.1b2
( ./configure --prefix=/opt/software/hmmer3.1b2/ && make && make install ) > /dev/null
( cd easel && make install ) > /dev/null
cd ..
rm -rf hmmer-3.1b2.tar.gz hmmer-3.1b2/
ln -s $PWD/hmmer3.1b2/bin/* /opt/bin/

# GROMACS
echo "[+] Downloading & installing GROMACS"
echo "    Go grab a drink..."
# sudo apt-get -qq -y install gromacs > /dev/null
wget -q ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.0.6.tar.gz > /dev/null
tar -xzf gromacs-5.0.6.tar.gz
(cd gromacs-5.0.6 && mkdir build && cd build && cmake ../ \
                                                -DGMX_BUILD_OWN_FFTW=ON \
                                                -DCMAKE_INSTALL_PREFIX=/opt/software/gromacs5 && \
                                                make && make install) > /dev/null
ln -s /opt/software/gromacs5/bin/GMXRC /opt/bin

# MODELLER
echo "[+] Downloading & installing MODELLER"
wget -q https://salilab.org/modeller/9.15/modeller_9.15-1_i386.deb > /dev/null
env KEY_MODELLER=$( egrep -v "^#" /vagrant/assets/config/modeller.key ) \
    dpkg -i modeller_9.15-1_i386.deb > /dev/null

success=$( cd /usr/lib/modeller9.15/examples/automodel/ \
           && mod9.15 model-default.py 2>&1 | egrep 'Invalid license key' )

if [ ! -z "$success" ]
then
  echo '[!!] MODELLER installation failed: wrong key' 1>&2
  echo '[!!] To obtain a valid key visit: https://salilab.org/modeller/' 1>&2
  echo '[!!] See the /usr/lib/modeller9.15/modlib/modeller/config.py file'
fi

rm -f modeller_9.15-1_i386.deb

# Download DSSP
echo "[+] Downloading & installing dssp"
mkdir -p dssp
wget -q ftp://ftp.cmbi.ru.nl/pub/software/dssp/dssp-2.0.4-linux-i386 > /dev/null
mv dssp-2.0.4-linux-i386 dssp/dssp && chmod a+x dssp/dssp
ln -s /opt/software/dssp/dssp /opt/bin/

# Git repositories
echo "[+] Downloading & installing pdb-tools"
git clone https://github.com/haddocking/pdb-tools > /dev/null
echo "[+] Downloading & installing biopython"
git clone https://github.com/biopython/biopython > /dev/null
(cd biopython && python setup.py build && python setup.py install) > /dev/null
