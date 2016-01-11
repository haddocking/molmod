#!/usr/bin/env bash

#
# Provisioning for the Molecular Dynamics module
#
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

echo "[+] Provisioning: Molecular Dynamics module"

# GROMACS
echo "[++] Downloading & installing GROMACS"
echo "     Go grab a drink (or three)..."
# sudo apt-get -qq -y install gromacs > /dev/null
wget -q -O /opt/software/gromacs-5.1.1.tar.gz ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.1.tar.gz > /dev/null

if [ -d /opt/software/gromacs5 ]
then
	rm -rf /opt/software/gromacs5
fi

(cd /opt/software && tar -xzf gromacs-5.1.1.tar.gz && cd gromacs-5.1.1 && mkdir build && cd build && \
    cmake ../ -DGMX_BUILD_OWN_FFTW=OFF -DCMAKE_INSTALL_PREFIX=/opt/software/gromacs5 && make && \
    make install) > /dev/null

rm -rf /opt/software/gromacs-5.1.1 /opt/software/gromacs-5.1.1.tar.gz

ln -sf /opt/software/gromacs5/bin/GMXRC /opt/bin
