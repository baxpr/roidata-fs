#!/usr/bin/env bash

# Initialize defaults
export roi_img=aparc.a2009s+aseg.mgz
export out_dir=/OUTPUTS
export labelinfo=

# Parse input options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in      
        --deffwd_niigz)  export deffwd_niigz="$2";  shift; shift ;;
        --roi_img)       export roi_img="$2";       shift; shift ;;
        --wt1_niigz)     export wt1_niigz="$2";     shift; shift ;;
        --subject_dir)   export subject_dir="$2";   shift; shift ;;
        --spm_dir)       export spm_dir="$2";       shift; shift ;;
        --labelinfo)     export labelinfo="$2";     shift; shift ;;
        --out_dir)       export out_dir="$2";       shift; shift ;;
        *) echo "Input ${1} not recognized"; shift ;;
    esac
done

# Prep files
gunzip -c "${deffwd_niigz}" > "${out_dir}"/y_deffwd.nii
gunzip -c "${spm_dir}"/mask.nii.gz > "${out_dir}"/mask.nii
cp "${wt1_niigz}" "${out_dir}"/wt1.nii.gz

# Convert FS ROI image to nii
mri_convert "${subject_dir}"/mri/"${roi_img}" "${out_dir}"/fsroi.nii

# Matlab part - warp ROI image to MNI with SPM12
run_spm12.sh ${MATLAB_RUNTIME} function warp_images \
    "${out_dir}"/fsroi.nii \
    "${out_dir}"/y_deffwd.nii \
    "${out_dir}"/mask.nii \
    0 \
    "${out_dir}"

# Extract ROI signals from spm_con images 
for con in "${spm_dir}"/con_????.nii.gz; do
    connum=$(basename "${con}" .nii.gz)
    fslstats -K "${out_dir}"/wfsroi.nii "${con}" -m > "${out_dir}/${connum}.txt"
    #fslmeants -i "${con}" -o "${out_dir}/${connum}.txt" --label="${out_dir}"/wfsroi.nii
done

# FIXME We are here. Convert fsl text file data to csv with empties removed
# Get a list of indices to keep from the ROI image (convert to 0 based? not sure)
# Get labels from the FS LUT ${FREESURFER_HOME}/FreeSurferColorLUT.txt
# data_tocsv.py

# PDF
make_pdf.sh

# Zip
gzip "${out_dir}"/fsroi_mni.nii
