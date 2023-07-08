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
    )
con.columns = ["Mean"]

# Get label values, assuming 1..N as in output of fslstats
con['Label'] = range(1,con.shape[0]+1)

# Add con name
# FIXME get contrast names from SPM somehow?
con['Contrast'] = conlabel

# Replace "missing" with nan
con.Mean = con.Mean.apply(lambda x: float('nan') if x.startswith('missing') else float(x))

# Merge region labels
con = con.merge(
    lut[['Label', 'Region']],
    on='Label',
    how='left',
    )

print(con)

# Now drop NA rows
con.dropna(inplace=True)

print(con)


