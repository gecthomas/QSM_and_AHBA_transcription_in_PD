function ROI_Zscore_transform(Ctrl_root, Pt_root, working_dir)
% ROI Z-score transformation 
%% ------------------------- SCRIPT INFORMATION ---------------------------
%
% This script will take control + participant ROI (QSM) data and perform a 
% Z-score transformation on particpant data, normalising against controls.
%
% Will also output tanh transformed Zscores
%
% Author: George Thomas
% Date:   July 2020 
%
% ----------------------------- INPUTS ------------------------------------
%
% Ctrl_root:
%   Name of Ncontrols*NROI .mat file control MRI data
%
% Pt_root:
%   Name of Nparticipants*NROI
%
% working_dir:
%   where the input/output files are/will go
%
%------------------------------- OUTPUTS ----------------------------------
%
% ztrans_<Pt_root>
%   Z-score transformed Nsubjects*NROI .csv

%% ------------------------ SCIPT BEGINS HERE -----------------------------
tic
%% import data
% add working dir to path
working_dir = [pwd working_dir];
addpath(working_dir);

disp('>>> Load data')
Ctrl = importdata([Ctrl_root '.mat']);
Pt = importdata([Pt_root '.mat']);

%% transform data

disp('>>> Get Ctrl reference')
ROI_ref_mn = mean(Ctrl);
ROI_ref_sd = std(Ctrl);

disp('>>> Z-score transform to reference')
zscores = zeros(size(Pt,1),size(Pt,2));

% loop through ROIs
for i = 1:size(Ctrl,2)
    
    disp(['ROI: ' num2str(i)])
    
    % normalise value to control reference for each subject
    for s = 1:size(Pt,1)
    zscores(s,i) = (Pt(s,i) - ROI_ref_mn(i))/ROI_ref_sd(i);
    end
    
end

tanh_scores = tanh(zscores);

%% save outputs

disp('>>> save to .mat file')
output_root = ['ztrans_' Pt_root];
save(fullfile(working_dir, [output_root '.mat']), 'zscores', '-mat');

tanh_scores = tanh(zscores);
output2_root = ['tanh_' output_root];
save(fullfile(working_dir, [output2_root '.mat']), 'tanh_scores', '-mat');

%% report speed
toc