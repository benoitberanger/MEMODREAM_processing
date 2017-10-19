clear
clc

load('exarr.mat')

subjectdir = examArray.toJobs;

img_path  = [ pwd filesep 'img'];
stim_path = [ pwd filesep 'stim'];

func_regex = '^run_(DualTask|SpeedTest|Training)_\d{3}$';

%% Fetch run volumes

func_volumes = examArray.getSeries(func_regex);

dfonc = func_volumes.toJobs
% char(ffunc)

%% Fetch stim files

% stimArray = exam(stim_path,'Pilote03');
% 
% stimArray.addVolumes

stim_dirs  = get_subdir_regex(stim_path,'Pilote03');
stim_files = get_subdir_regex_files(stim_dirs,...
    '(DualTask_Simple|DualTask_Complex|SpeedTest|Training)_MRI_.*_SPM.mat$')
% char(stim_files)


%% prepare first level

statdir=r_mkdir(subjectdir,'stat')
fmristat=r_mkdir(statdir,'fmri')
do_delete(fmristat,0)
fmristat=r_mkdir(statdir,'fmri')

par.file_reg = '^swutrf.*nii';

par.TR=2.200;
par.delete_previous=1;


%% Specify model

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

j_specify = job_first_level_specify(dfonc,fmristat,stim_files,par)


%% Estimate model

fspm = get_subdir_regex_files(fmristat,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)

