function roi_nii = combine_rois(wtseg_nii,out_dir)

% ROIs are combined in a specific order - later ones overwrite earlier ones
% if there is any overlap.


%% ROI file info, verify geometry, load
Vtseg = spm_vol(wtseg_nii);
voxel_volume = abs(det(Vtseg.mat));
Ytseg = spm_read_vols(Vtseg);


%% Initialize final label image and info file
Ylabels = zeros(size(Ytseg));
label_info = table([],{},[],[],'VariableNames', ...
	{'Label','Region','Volume_before_overlap_mm3','Volume_mm3'});
warning('off','MATLAB:table:RowsAddedExistingVars');


%% Temporal lobe v4
% 1   R head
% 2   R body
% 4   L head
% 5   L body
% 6     R amyg
% 8     L amyg
% 10  R tail
% 11  L tail
Ylabels(ismember(Ytseg(:),[1 2 10])) = 1;  % R hipp
Ylabels(ismember(Ytseg(:),[4 5 11])) = 2;  % L hipp

label_info.Label(end+1) = 1;
label_info.Region{end} = 'R_Hippocampus';
label_info.Volume_before_overlap_mm3(end) = ...
	sum(Ylabels(:)==label_info.Label(end)) * voxel_volume;

label_info.Label(end+1) = 2;
label_info.Region{end} = 'L_Hippocampus';
label_info.Volume_before_overlap_mm3(end) = ...
	sum(Ylabels(:)==label_info.Label(end)) * voxel_volume;


%% Compute final volumes
for h = 1:height(label_info)
	label_info.Volume_mm3(h) = sum(Ylabels(:)==label_info.Label(h)) * voxel_volume;
end


%% Done - write label image and info CSV
Vlabels = Vtseg;
Vlabels.pinfo(1:2) = [1;0];
Vlabels.dt(1) = spm_type('uint16');
roi_nii = fullfile(out_dir,'rois_hipp.nii');
Vlabels.fname = roi_nii;
spm_write_vol(Vlabels,Ylabels);

label_csv = fullfile(out_dir,'rois_hipp-labels.csv');
writetable(label_info,label_csv);


