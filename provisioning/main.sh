#!/usr/bin/env bash

#
# General provisioning script
#

## Avoid errors here and there
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

## Make /opt directory structure
echo "[+] Creating /opt directory structure"
mkdir -p /opt/data /opt/software /opt/bin

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
apt-get install -y --no-install-recommends git cmake build-essential > /dev/null

# Manually compile & install autoconf/make/etc
wget -q http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz > /dev/null
(tar -xzf autoconf-2.69.tar.gz && cd autoconf-2.69 && ./configure && make && sudo make install) > /dev/null
rm -rf autoconf-2.69.tar.gz autoconf-2.69

wget -q http://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz > /dev/null
(tar -xzf automake-1.15.tar.gz && cd automake-1.15 && ./configure && make && sudo make install) > /dev/null
rm -rf automake-1.15.tar.gz automake-1.15

wget -q http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz > /dev/null
(tar -xzf libtool-2.4.6.tar.gz && cd libtool-2.4.6 && ./configure && make && sudo make install) > /dev/null
rm -rf libtool-2.4.6.tar.gz libtool-2.4.6

# Python libs
apt-get install -y --no-install-recommends python-numpy python-matplotlib \
                                           python-dev > /dev/null
