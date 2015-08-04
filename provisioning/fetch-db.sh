#!/usr/bin/env bash

# Download the pdb_seqres database
wget -q -O /opt/database/pdb_seqres.txt \
    ftp://ftp.rcsb.org/pub/pdb/derived_data/pdb_seqres.txt
