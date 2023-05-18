#!/usr/bin/env bash

# Initialize defaults
export mnigeom_nii=avg152T1.nii
export out_dir=/OUTPUTS
export labelinfo=

# Parse input options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in      
        --deffwd_niigz)  export deffwd_niigz="$2";  shift; shift ;;
        --wt1_niigz)     export wt1_niigz="$2";     shift; shift ;;
        --subject_dir)   export subject_dir="$2";   shift; shift ;;
        --spm_dir)       export spm_dir="$2";       shift; shift ;;
        --mnigeom_nii)   export mnigeom_nii="$2";   shift; shift ;;
        --labelinfo)     export labelinfo="$2";     shift; shift ;;
        --out_dir)       export out_dir="$2";       shift; shift ;;
        *) echo "Input ${1} not recognized"; shift ;;
    esac
done

# Prep files
cp "${deffwd_niigz}" "${out_dir}"/y_deffwd.nii.gz
cp "${wt1_niigz}" "${out_dir}"/wt1.nii.gz
cp -R "${subject_dir}" "${out_dir}"/SUBJECT
cp -R "${spm_dir}" "${out_dir}"/spm
gunzip "${out_dir}"/*.nii.gz "${out_dir}"/spm/*.nii.gz

# Convert FS images to nii and combine to FS space ROI image

# Matlab part - warp ROI image to MNI with SPM12
run_spm12.sh ${MATLAB_RUNTIME} function warp_images \
    "${out_dir}"/fsroi.nii \
    "${out_dir}"/y_deffwd.nii \
    "${mnigeom_nii}" \
    0 \
    "${out_dir}"


# PDF
make_pdf.sh

# Zip
gzip "${out_dir}"/fsroi_mni.nii
