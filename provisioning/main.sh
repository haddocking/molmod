#!/usr/bin/env bash

#
# General provisioning script
#

## Avoid errors here and there
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764
sed -i -e '/^mesg n/d' /root/.profile

## Make /opt directory structure
echo "[+] Creating /opt directory structure"
mkdir -p /opt/data /opt/software /opt/bin /opt/share >& /dev/null

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
add-apt-repository ppa:ubuntu-toolchain-r/test >& /dev/null # gcc 4.8 req. for GMX
add-apt-repository ppa:abelcheung/lucid-dev-backports &> /dev/null # autotools, req. for freesasa
(apt-get -qq update && apt-get -qq -y upgrade && apt-get -qq -y dist-upgrade) > /dev/null

# Change default compilers to newer versions
(apt-get -qq install -y --no-install-recommends gcc-4.8 g++-4.8 && \
sudo update-alternatives --quiet --remove-all gcc && \
sudo update-alternatives --quiet --remove-all g++ && \
sudo update-alternatives --quiet --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20 && \
sudo update-alternatives --quiet --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20 && \
sudo update-alternatives --quiet --config gcc && \
sudo update-alternatives --quiet --config g++ ) > /dev/null

# Building tools
apt-get -qq install -y --no-install-recommends git autoconf automake cmake autotools-dev \
										   build-essential libfftw3-3 libfftw3-dev > /dev/null

# Python libs
apt-get -qq install -y --no-install-recommends python-numpy python-matplotlib \
                                           python-dev > /dev/null