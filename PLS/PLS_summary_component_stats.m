function PLS_summary_component_stats(GENEdata_root, MRIdata_root,...
    ncomp, nperm, perm_type, working_dir)
% PLS component summary statistics
%% ------------------------- SCRIPT INFORMATION ---------------------------
%
% This script will assess if each individual component in a model explains
% more or less variance in Y (MRI data) than expected by chance, and also 
% give some summary info about the components.
%
% This script is an adapted version of a script available from the
% following repository:
% https://github.com/KirstieJane/NSPN_WhitakerVertes_PNAS2016/
% Reference: Whitaker et al., 2016, PNAS
% Credit and thanks to the original author Petra Vertes
%
% Script last edited by:
% George Thomas, July 2020
% - to run significance tests on the individual components in a model
% - to have the option to use spatial permutations
% - to run with any number of components 
% - output .csv gives slightly more info
%
%----------------------------- INPUTS -------------------------------------
%
% GENEdata_root:
%   Name of genetic data .mat file, including Ngenes*NROI parcel expression
%   and probe information
%
% MRIdata_root:
%   Name of MRI data Nsubjects*NROI .mat file, containg participant QSM  
%   means Z-score transformed to control means for each ROI
%   OR - a column vector containing NROI Z-score transformed mean values.
%
% ncomp:
%   number of dimensions (components) for the PLS 
%
% nperm:
%   number of permutations for signficance testing
%
% perm_type:
%   either 'spatial' or 'random'. If spatial, permutations for significance
%   testing done by sphere-projection-rotation of the MRI data (this is 
%   recommended). If random, MRI data is randomly shuffled.
%
% working_dir:
%   directory where MRIdata_root is and where output .csv files will go
%
%------------------------------- OUTPUTS ----------------------------------
%
% summary_component_stats_<perm_type>_<MRIdata_root>.csv
%   significance info and stats about all PLS components
%
%----------------------------- DEPENDENCIES -------------------------------
%
% N.B. only if perm_type = 'spatial' 
%   rotate_parcellation_fixed_LH.m
%   sphere_HCP.txt
%
% All documentaion about the above code and coordinates is available from:
% https://github.com/frantisekvasa/rotate_parcellation/
% Credit and thanks to the author František Váša
% 

%% ------------------------ SCIPT BEGINS HERE -----------------------------
tic
%% import data

disp('>>> importing + tidying variables')
disp(' ')

% add working dir full path
working_dir = [pwd working_dir];
addpath(working_dir);

% load NROI*Ngenes gene expression matrix (LH only)
load([GENEdata_root '.mat']);
GENEdata = parcelExpression;
GENEdata(:,1) = [];
% Replace NaN Gene/ROI entries with mean expression in that ROI
for g = 1:size(GENEdata,2)
    GENEdata(isnan(GENEdata(:,g)),g) =...
        mean(GENEdata(~isnan(GENEdata(:,g)),g));
end

% import matrix of subjects*ROI MRI data
MRIdata  = importdata([MRIdata_root '.mat']);

disp('>>> grouping + averaging MRI data')
disp(' ')

% if the MRI data is Nsubjects*NROI matrix
if size(MRIdata,2) > 1
    % calculate average score in each region
    respmat = (mean(MRIdata))';
else
    % if not leave as the input column vector
    respmat = MRIdata;
end

%% run initial PLS

% define predictor X as NROI*Ngenes matrix and response Y as NROI*1 column 
% vector
Y = respmat;
X = GENEdata;

% Run initial PLS in Ncomp dimensions
disp(['>>> running PLSR in ' num2str(ncomp) ' dimensions']);
disp(' ');
[~,~,XS,~,~,pctvar]=plsregress(X,Y,ncomp);
% extract and report variance explained in Y by each comp
disp('variance explained in Y by each component:')
disp(100*pctvar(2,:))
disp(' ')    

% calculate correlation of each component's ROI weight with the MRI data
disp('correlation of PLS components with MRI data:');
[rho, pval] = corr(respmat, XS)

%% run permutation test

% assess significance of PLS components' explained variance
disp('assessing variance explained by components')

% make empty matrices for p values and cell for significance values
p = zeros(ncomp,1);
significance = cell(ncomp,1);

% get component variance explained in Y
VarC = 100*pctvar(2,:);
% make empty matrix for recalculated component variance values
VarCr = zeros(nperm,ncomp);

% check the perm type specified
if strcmpi(perm_type, 'spatial')
    % if spatial perms
    disp(['computing ' num2str(nperm) ' spatial ROI permutations'])
    % importing left hemisphere Glasser ROI coordinates
    lh_coords = importdata('sphere_HCP.txt');
    lh_coords = lh_coords(1:180,:);
    % generate indeces for nperm spatial nulls
    Yp = rotate_parcellation_fixed_LH(lh_coords,nperm);
    disp('re-running PLS')
    for j=1:nperm
        % run the PLS again resampling Y using the spatial nulls
        [~,~,~,~,~,PCTVARr] = plsregress(X,Y(Yp(:,j)),ncomp);
        % get and store variance the components explain in Y
        temp=100*PCTVARr(2,:);
        VarCr(j,:)=temp;
        % report progress
        if mod(j,100) == 0
            disp(num2str(j))
        end
    end
    output_root = ['summary_component_stats_sphere_rot_' MRIdata_root];
    
elseif strcmpi(perm_type,'random')
    % ifrandom perms
    disp('re-running PLS')
    disp(['doing ' num2str(nperm) ' permutations'])
    for j=1:nperm
        % randomly permute Y
        orderY=randperm(size(Y,1));
        Yp = Y(orderY,:);
        % run PLS with this random permutation
        [~,~,~,~,~,PCTVARr]=plsregress(X,Yp,ncomp);
        % get and store variance the components explain in Y
        temp=100*PCTVARr(2,:);
        VarCr(j,:)=temp;
        % report progress
        if mod(j,100) == 0
            disp(num2str(j))
        end
    end
    output_root = ['summary_component_stats_' MRIdata_root];
    
else
    error('invalid permutation type, must be either spatial or random')
    
end
%% calculate and report significance of each component

% count how many times a component from a null model explained more
% variance than a component in the initial model
for c = 1:ncomp
    p(c) = length(find(VarCr(:,c)>=VarC(c)))/j;
    disp(['Significance of component ' num2str(c) ':'])
    disp(p(c))
    if p(c) < 0.001
        significance{c} = '***';
        disp(significance{c})
    elseif p(c) < 0.01
        significance{c} = '**';
        disp(significance{c})
    elseif p(c) < 0.05
        significance{c} = '*';
        disp(significance{c})
    else
        significance{c} = 'NS';
        disp(significance{c})
    end
    disp(' ');
end
    
%% save results
% save explained variance, correlations and significance

% make some strings for formatting the ouput
str1 = '';
str2 = '';
str3 = '';
for s = 1:ncomp
    str1 = strcat(str1, ', %f');
    str2 = strcat(str2, ', %s');
    str3 = strcat(str3, ', %e');
end

% open a file 
fid1 = fopen(fullfile(working_dir,[output_root '.csv']),'w');
% print results to file
fprintf(fid1,strcat('%s', str1, '\n'),'component', 1:ncomp);
fprintf(fid1,strcat('%s', str1, '\n'),'expl_var_X', pctvar(1,:)*100);
fprintf(fid1,strcat('%s', str1, '\n'),'expl_var_Y', pctvar(2,:)*100);
fprintf(fid1,strcat('%s', str1, '\n'),'expl_var_Y_p', p);
fprintf(fid1,strcat('%s', str2, '\n'),'', significance{:});
fprintf(fid1,strcat('%s', str1, '\n'),'corr_X_rho', rho);
fprintf(fid1,strcat('%s', str3, '\n'),'corr_X_p',   pval);
% save and close
fclose(fid1);

%% report speed
toc
