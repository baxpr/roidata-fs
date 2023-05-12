#!/usr/bin/env bash

# Initialize defaults
export mnigeom_nii=avg152T1.nii
export out_dir=/OUTPUTS
export project=TESTPROJ
export subject=TESTSUBJ
export session=TESTSESS
export scan=TESTSCAN

# Parse input options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in      
        --deffwd_niigz)  export deffwd_niigz="$2";  shift; shift ;;
        --wt1_niigz)     export wt1_niigz="$2";     shift; shift ;;
        --mnigeom_nii)   export mnigeom_nii="$2";   shift; shift ;;
        --project)       export project="$2";       shift; shift ;;
        --subject)       export subject="$2";       shift; shift ;;
        --session)       export session="$2";       shift; shift ;;
        --scan)          export scan="$2";          shift; shift ;;
        --out_dir)       export out_dir="$2";       shift; shift ;;
        *) echo "Input ${1} not recognized"; shift ;;
    esac
done

# Prep files
cp "${deffwd_niigz}" "${out_dir}"/y_deffwd.nii.gz
cp "${wt1_niigz}" "${out_dir}"/wt1.nii.gz
gunzip "${out_dir}"/*.nii.gz

# Matlab part
run_spm12.sh ${MATLAB_RUNTIME} function makerois \
    wt1_nii "${out_dir}"/wt1.nii \
    tseg_nii "${out_dir}"/tseg.nii \
    deffwd_nii "${out_dir}"/y_deffwd.nii \
    mnigeom_nii "${mnigeom_nii}" \
    out_dir "${out_dir}"

# PDF
make_pdf.sh

# Zip
gzip "${out_dir}"/rois_hipp.nii
