function makerois_main(inp)


%% SPM init
spm_jobman('initcfg')


%% Get reference geometry
mnigeom_nii = which(inp.mnigeom_nii);


%% Warp/resample ROIs to MNI space
disp('Warping')
wtseg_nii = warp_images(inp.tseg_nii,inp.deffwd_nii,mnigeom_nii,0,inp.out_dir);


%% Combine desired ROIs into single image
combine_rois(wtseg_nii,inp.out_dir);


%% Exit
if isdeployed
	exit
end

