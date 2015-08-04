#!/usr/bin/env python

"""
Pymol-based script to calculate per-residue relative
solvent accessible surface area.
"""

from __future__ import print_function

import os
import sys

try:

    import __main__
    __main__.pymol_argv = [ 'pymol', '-qc' ]

    import pymol
    pymol.finish_launching()

    from pymol import cmd, CmdException
    cmd.set('dot_solvent')

except ImportError as e:
    print('[!!] Could not import PyMOL', file=sys.stderr)
    print(e, file=sys.stderr)
    sys.exit(1)

#
# Scaling factors for relative ASA
# Taken from NACCESS
rel_asa = {

    'bb':
        {
        'ALA': 38.54,
        'CYS': 37.53,
        'ASP': 37.70,
        'GLU': 37.51,
        'PHE': 35.37,
        'GLY': 47.77,
        'HIS': 35.80,
        'ILE': 37.16,
        'LYS': 37.51,
        'LEU': 37.51,
        'MET': 37.51,
        'ASN': 37.70,
        'PRO': 16.23,
        'GLN': 37.51,
        'ARG': 37.51,
        'SER': 38.40,
        'THR': 37.57,
        'VAL': 37.16,
        'TRP': 38.10,
        'TYR': 35.38,
        },
    'sc':
        {
        'ALA': 69.41,
        'CYS': 96.75,
        'ASP': 102.69,
        'GLU': 134.74,
        'PHE': 164.11,
        'GLY': 32.33,
        'HIS': 147.08,
        'ILE': 137.96,
        'LYS': 163.30,
        'LEU': 141.12,
        'MET': 156.64,
        'ASN': 106.24,
        'PRO': 119.90,
        'GLN': 140.99,
        'ARG': 201.25,
        'SER': 78.11,
        'THR': 101.70,
        'VAL': 114.28,
        'TRP': 211.26,
        'TYR': 177.38,
    }
}

#
pdbf = sys.argv[1]
cmd.load(pdbf, 'protein')
cmd.remove('het or solvent or element H')

r_list = []
cmd.iterate('protein and name ca', 'r_list.append((resn, resi))', space=locals())

headers = ('Num', 'Res', 'MC (A)', 'MC (%)', 'SC (A)', 'SC (%)')
print('{0:>5s}\t{1:>5s}\t{2:>8s}\t{3:>8s}\t{4:>8s}\t{5:>8s}'.format(*headers))
for (resn, resi) in r_list:
    rsa = cmd.get_area('protein and resi {0}'.format(resi))
    bb_rsa = cmd.get_area('protein and resi {0} and name ca+c+n+o'.format(resi))
    sc_rsa = rsa - bb_rsa
    rel_bb_rsa = 100*bb_rsa / rel_asa['bb'][resn]
    rel_sc_rsa = 100*sc_rsa / rel_asa['sc'][resn]

    _vals = (resi, resn, bb_rsa, rel_bb_rsa, sc_rsa, rel_sc_rsa)
    print('{0:>5s}\t{1:>5s}\t{2:>8.2f}\t{3:>8.2f}\t{4:>8.2f}\t{5:>8.2f}'.format(*_vals))
