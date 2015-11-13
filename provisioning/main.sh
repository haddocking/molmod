#!/usr/bin/env bash

#
# General provisioning script
#

## Avoid errors here and there
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

## Make /opt directory structure
echo "[+] Creating /opt directory structure"
mkdir -p /opt/data /opt/software /opt/bin /opt/share

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
apt-get install -y --no-install-recommends git cmake automake build-essential > /dev/null

# Python libs
apt-get install -y --no-install-recommends python-numpy python-matplotlib \
                                           python-dev > /dev/null
