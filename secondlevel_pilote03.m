clear
clc

imgdir   = [ pwd filesep 'img'];
stimdirs = [ pwd filesep 'stim'];
load('exarr_stim.mat')

statdir = get_subdir_regex(examArray.toJobs,'stat');
session_all_dir = get_subdir_regex(statdir,'session');

par.delete_previous=1;
par.run = 1;
par.display = 0;


%% Design the model :

% Task x Time x Session

% Task    : DT_Simple(1), DT_Complex(2), SpeedTest(3)
% Time    : Pre(1), Post(2)
% Session : 1,2,3 // session 4 is special => another model will be applied

for task = 1 : 3
    for time = 1 : 2
        for session = 1 : 3
            level   (task, time, session) = {[task time session]}; %#ok<SAGROW>
            contrast(task, time, session) = get_subdir_regex_files(session_all_dir(session),sprintf('con_000%d.nii',task+3*(time-1))); %#ok<SAGROW>
%             contrast{task, time, session} = repmat(contrast(task, time, session), [5,1]);
        end
    end
end

factorial123dir = r_mkdir(statdir,'secondlevel_factorial_123');
do_delete(factorial123dir,0)
factorial123dir = r_mkdir(statdir,'secondlevel_factorial_123');


%% Prepare Job

matlabbatch{1}.spm.stats.factorial_design.dir = factorial123dir;

matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'Task';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 3;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;

matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'Time';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;

matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).name = 'Session';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).levels = 3;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).ancova = 0;

for n = 1 : numel(level)
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(n).levels =    level{n};
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(n).scans  = contrast(n);
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(n).scans  = contrast{n};
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Run Job

spm_jobman('run',matlabbatch) % spm_jobman('interactive',matlabbatch)
fspm = get_subdir_regex_files(factorial123dir,'SPM.mat');
j_estimate = job_first_level_estimate(fspm,par);


%% Show results

SHOW{1}.spm.stats.results.spmmat = fspm;
SHOW{1}.spm.stats.results.conspec.titlestr = '';
SHOW{1}.spm.stats.results.conspec.contrasts = 1;
SHOW{1}.spm.stats.results.conspec.threshdesc = 'FWE';
SHOW{1}.spm.stats.results.conspec.thresh = 0.05;
SHOW{1}.spm.stats.results.conspec.extent = 10;
SHOW{1}.spm.stats.results.conspec.conjunction = 1;
SHOW{1}.spm.stats.results.conspec.mask.none = 1;
SHOW{1}.spm.stats.results.units = 1;
SHOW{1}.spm.stats.results.print = false;
SHOW{1}.spm.stats.results.write.none = 1;

spm('defaults','FMRI')
spm_jobman('run',SHOW)
