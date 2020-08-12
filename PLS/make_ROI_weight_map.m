function make_ROI_weight_map(ROIweight_fname,ROItemplate_root,working_dir)
% Map a set of N values to a template set of N ROIs
%% ------------------------- SCRIPT INFORMATION ---------------------------
% 
% This script will take a set of N ROIs and assign a custom set of N values
% to them - e.g. for plotting or presentation
%
% Author: George Thomas, July 2020
%
%------------------------------- INPUTS -----------------------------------
%
% ROIweight_fname
%   Either a .csv or .mat column vector of N values to assign
%   E.g. ROIweights.csv / ROIweights2.mat
%
% ROItemplate_root
%   Rootname of a NIFTI file containing the set of N ROIs, the first ROI 
%   should correspond to the first row entry in ROI weights and so on...
%
% working_dir
%   Name of directory for inputs/outputs (relative to pwd)
%
%------------------------------- OUTPUTS ----------------------------------
%
% MAPPED_<ROIweights basename>.nii.gz
%   A NIFTI file with ROI index values replaced by the custom values
%
%----------------------------- DEPENDENCIES -------------------------------
%
% SPM must be installed & on the path
%
% m1_nifti_load.m
% m1_nifti_save.m
% m1_fname_split.m
% Available from:
% https://gitlab.com/acostaj/QSMexplorer/-/tree/master/matlab_utils/_Utils
% Credit and thanks to Julio Acosta-Cabronero
%

%% ------------------------ SCRIPT BEGINS HERE ----------------------------
tic

%% import data

disp('> load data');

% add working_dir full path
working_dir = [pwd working_dir];
addpath(working_dir);

% get ROI weight filetype and basename
dots = findstr(ROIweight_fname, '.');
lastDot = dots(length(dots));
ROIweight_root = ROIweight_fname(1:lastDot-1);
ftype = ROIweight_fname(lastDot:end);   
% check the file type is OK
if ~(strcmpi(ftype,'.mat') || strcmpi(ftype,'.csv'))
    error('invalid filetype, must be .csv or .mat')
end
% import the file
[ROIweight] = importdata([ROIweight_root ftype]);

% load in the template file
[ROItemplate] = m1_nifti_load(ROItemplate_root);
% find the min and max ROI index
minROI = min(ROItemplate(ROItemplate~=0));
maxROI = max(ROItemplate(:));

%% re-assign indexed ROIs with custom values
disp('assign ROI weights')
% loop across min-max ROI range
for x = minROI:maxROI
    idx = find(ROItemplate==x);
    % Check if ROI exits
    if idx
	% if it does then reassign it
        disp(['ROI: ' num2str(x)])
        ROItemplate(idx) = ROIweight(x);
    end
end

%% save new map

filename = fullfile(working_dir, ['MAPPED_' ROIweight_root]);

% get SPM image structure info from the template
ima_struct = spm_vol([ROItemplate_root '.nii.gz']);
% save the template with reassigned values
m1_nifti_save(ROItemplate,ima_struct,filename);

%% report speed
toc
