#!/usr/bin/env python

import os
import pandas

# Load FS labels
lutfile = f'{os.environ["FREESURFER_HOME"]}/FreeSurferColorLUT.txt'
lut = pandas.read_csv(
    lutfile, 
    sep='\s+', 
    skip_blank_lines=True, 
    comment='#',
    names=['Label', 'Region', 'R', 'G', 'B', 'A'],
    )

print(lut)

# Load ROI mean values output of fslstats
conlabel = 'con_0001'
confile = f'../OUTPUTS/{conlabel}.txt'
con = pandas.read_csv(
    confile,
    header=None, 
    na_values='missing'
    )
con.columns = ["Mean"]

# Get label values, assuming 1..N as in output of fslstats
con['Label'] = range(1,con.shape[0]+1)

# Add con name
con['Contrast'] = conlabel

# Merge region labels
con = con.merge(
    lut[['Label', 'Region']],
    on='Label',
    )

# FIXME get contrast names from SPM somehow?

print(con)

