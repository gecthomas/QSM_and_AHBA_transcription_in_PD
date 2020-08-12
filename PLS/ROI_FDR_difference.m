function ROI_FDR_difference(Ctrl_root, Pt_root, working_dir)
% Test for differences between ROIs and save results
%% ------------------------- SCRIPT INFORMATION ---------------------------
%
% This script runs a two tailed ttest at each ROI to test for differences
% between patients and controls. 
%
% The p-values are then FDR-corrected using the BH method
%
% Most of the script is just organising and saving the results
%
%----------------------------- INPUTS -------------------------------------
%
% Ctrl_root:
%   rootname of .mat file containing Nsubjects*NROI MRI info
%
% Pt_root:
%   as above for participants
%
% working_dir:
%   name of subdirectory where inputs/outputs are/will go
%
%------------------------------- OUTPUTS ----------------------------------
%
% ROI_differences_<Pt_root>.csv
%   file containing info about sigficant ROIs
%   ROI_index/Ctrl_mean/Pt_mean/uncorr_p/significance/corr_p/significance
%
% significant_ROIs_<Pt_root>.mat
%   NROI long column vector with 0 for no difference, +1/+2 for Pt greater
%   than controls at uncorr/corr and -1/-2 for Ctrl greater than Pt at
%   uncorr / corr
%
%---------------------------- DEPENDENCIES --------------------------------
%
% fdr.m, available from: 
% https://brainder.org/2011/09/05/fdr-corrected-fdr-adjusted-p-values/

%% ------------------------ SCIPT BEGINS HERE -----------------------------
tic

%% import data
disp('>>> Load data')

% add full working dir path
working_dir = [pwd working_dir];
addpath(working_dir);

% load control and participant data
Ctrl = importdata([Ctrl_root '.mat']);
Pt = importdata([Pt_root '.mat']);

%% Run tests

% Two-tailed ttest to find differences
[h,p] = ttest2(Pt, Ctrl);

disp('>>> Testing for Ctrl, Pt diffrences')

% report number of uncorrected regional differences
disp('> significant differences at p<0.05:')
disp(num2str(sum(h)))

% Run fdr correction (dependency fdr_correction.m must be on path)
[~,~,padj] = fdr(p);

% report number of corrected regional differences
disp('> significant differences at pFDR<0.05:')
disp(num2str(sum(padj<0.05)))

%% save results

disp('>>> save results to .csv')

% get indeces of regions with showing significant differences at p<0.05
uncorr_ROIs = find(p<0.05);
% get control and participant mean values in those regions  
mean_Ctrl_ROI = mean(Ctrl(:,uncorr_ROIs));
mean_Pt_ROI = mean(Pt(:,uncorr_ROIs));
% get the p-values from the ttest at that region 
uncorr_p = p(uncorr_ROIs);
% make a cell to contain uncorrected reporting threholds
up_sig = cell(length(uncorr_ROIs),1);

% find regions also significant at pFDR<0.05
corr_p = padj(uncorr_ROIs);
% make a cell to contain corrected reporting thresholds
cp_sig = cell(length(uncorr_ROIs),1);

% open a .csv file in working_dir
output_root = ['ROI_differences_' Pt_root '.csv'];
fid1 = fopen(fullfile(working_dir,output_root),'w');

% print column headers
fprintf(fid1,'%s,%s,%s,%s,%s,%s,%s\n',...
    'ROI','Ctrl','Pt','uncorr_p','thr','corr_p','thr');

% loop through all ROIs significant at uncorrected level
for i = 1:length(uncorr_ROIs)
    
    % see at what uncorrected level there is significance and save result 
    if uncorr_p(i)<0.001
        up_sig{i} = '***';
    elseif uncorr_p(i)<0.01
        up_sig{i} = '**';
    elseif uncorr_p(i)<0.05
        up_sig{i} = '*';
    else
        up_sig{i} = 'ns';
    end
    
    % see at what corrected level there is significance and save result
    if corr_p(i)<0.001
        cp_sig{i} = '***';
    elseif corr_p(i)<0.01
        cp_sig{i} = '**';
    elseif corr_p(i)<0.05
        cp_sig{i} = '*';
    else
        cp_sig{i} = 'ns';
    end
    
    % print these results as well as ROI index and mean values to .csv
    fprintf(fid1,'%d,%e,%e,%f,%s,%f,%s\n',...
        uncorr_ROIs(i),...
        mean_Ctrl_ROI(i),...
        mean_Pt_ROI(i),...
        uncorr_p(i),...
        up_sig{i},...
        corr_p(i),...
        cp_sig{i});
end

% close and save .csv
fclose(fid1);

%% give basic idea of directionality and save

% make logical arrays and add / subtract so that:
% 0 = no difference
% +1 = Pt > Ctrl at p<0.05
% +2 = Pt > Ctrl at pFDR<0.05
% -1 = Ctrl > Pt at p<0.05
% -2 = Ctrl > Pt at pFDR<0.05
uncorr_more = p<0.05 & mean(Ctrl) < mean(Pt);
uncorr_less = p<0.05 & mean(Ctrl) > mean(Pt);
corr_more = padj<0.05 & mean(Ctrl) < mean(Pt);
corr_less = padj<0.05 & mean(Ctrl) > mean(Pt);
significant_ROIs = uncorr_more - uncorr_less + corr_more - corr_less;

% save this .mat file
save([working_dir '/significant_ROIs_' Pt_root '.mat'],...
    'significant_ROIs');

%% report speed
toc
