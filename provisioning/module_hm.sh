#!/usr/bin/env bash

#
# Provisioning for the Homology Modelling module
#
export DEBIAN_FRONTEND=noninteractive # StackOverflow 500764

echo "[+] Provisioning: Homology Modelling module"

## HMMER
echo "[++] Downloading & installing HMMER"
wget -q -O /opt/software/hmmer-3.1b2.tar.gz http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz > /dev/null

(cd /opt/software && tar -xzf hmmer-3.1b2.tar.gz && cd hmmer-3.1b2 && \
    ./configure --prefix=/opt/software/hmmer3.1b2/ && make && make install) > /dev/null

(cd /opt/software/hmmer-3.1b2/easel && make install) > /dev/null

rm -rf /opt/software/hmmer-3.1b2.tar.gz /opt/software/hmmer-3.1b2/
ln -s /opt/software/hmmer3.1b2/bin/* /opt/bin/

## MODELLER
echo "[++] Downloading & installing MODELLER"
wget -q -O /opt/software/modeller_9.15-1_i386.deb https://salilab.org/modeller/9.15/modeller_9.15-1_i386.deb > /dev/null

env KEY_MODELLER=$( egrep -v "^#" /vagrant/assets/config/modeller.key ) \
    dpkg -i /opt/software/modeller_9.15-1_i386.deb > /dev/null

success=$( cd /usr/lib/modeller9.15/examples/automodel/ \
           && mod9.15 model-default.py 2>&1 | egrep 'Invalid license key' )

if [ ! -z "$success" ]
then
  echo '[!!] MODELLER installation failed: wrong key' 1>&2
  echo '[!!] To obtain a valid key visit: https://salilab.org/modeller/' 1>&2
  echo '[!!] See the /usr/lib/modeller9.15/modlib/modeller/config.py file' 1>&2
fi

rm -f /opt/software/modeller_9.15-1_i386.deb

##

# Download the pdb_seqres database
echo "[++] Downloading the PDB sequence database"
wget -q -O /opt/data/pdb_seqres.txt \
    ftp://ftp.rcsb.org/pub/pdb/derived_data/pdb_seqres.txt
