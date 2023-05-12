function makerois(varargin)

P = inputParser;
addOptional(P,'tseg_nii','/OUTPUTS/tseg.nii')
addOptional(P,'deffwd_nii','/OUTPUTS/y_deffwd.nii')
addOptional(P,'wt1_nii','/OUTPUTS/wt1.nii')
addOptional(P,'mnigeom_nii','avg152T1.nii')
addOptional(P,'out_dir','../OUTPUTS');
parse(P,varargin{:});
disp(P.Results)

makerois_main(P.Results)

