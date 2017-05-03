clear all
clc

%% Prepare paths and regexp

chemin='/media/benoit/DATADRIVE1/fMRI_data_benoit/MEMODREAM/img';

suj = get_subdir_regex(chemin,'Pilote01');
% suj = get_subdir_regex(chemin);
%to see the content
char(suj)

%functional and anatomic subdir
par.dfonc_reg='execution$';

par.display=0;
par.run=1;


%% Get files paths

dfonc = get_subdir_regex_multi(suj,par.dfonc_reg); char(dfonc{:})
ffonc = get_subdir_regex_files(dfonc,'^swutrf')
nrRun = size(ffonc{1},1);

%% my onsets

time_offcet = +0.400; % seconds // due to the format_vmrk.m, the t0 read on Analyser is shifted

% Run 1

LRLR_1 = [
    5.360 10.508
    22.432 27.204
    38.324 42.212
    73.336 79.588
    94.920 101.912
    113.436 120.876
    177.816 182.964
    198.104 203.512
    215.320 221.116
    ]+time_offcet;

countdown_1 = [
    10.508 22.432
    76.588 94.920
    182.964 198.104
    ]+time_offcet;

sequence_1 = [
    27.204 38.324
    100.912 113.436
    203.512 215.320
    ]+time_offcet;

% Run 2

LRLR_2 = [
    12.304 17.872
    30.732 36.468
    47.860 52.612
    79.680 84.872
    100.732 107.680
    120.032 126.464
    ]+time_offcet;

countdown_2 = [
    17.872 30.732
    84.82 100.732
    171.656 187.372
    ]+time_offcet;

sequence_2 = [
    36.468 47.860
    107.680 120.032
    194.236 207.284
    ]+time_offcet;

% Run 3

LRLR_3 = [
    16.304 24.380
    37.328 43.640
    56.032 62.720
    97.264 103.120
    116.556 122.932
    134.428 140.916
    177.772 183.280
    200.380 206.724
    219.188 225.276
    ]+time_offcet;

countdown_3 = [
    24.380 37.328
    103.120 116.556
    183.280 200.380
    ]+time_offcet;

sequence_3 = [
    43.640 56.032
    122.932 134.428
    183.280 219.188
    ]+time_offcet;

%% Onsets formating

%    run,condition
onset{1}(1).name = 'LRLR';      onset{1}(1).onset = LRLR_1(:,1)      ;  onset{1}(1).duration = LRLR_1(:,2) - LRLR_1(:,1);
onset{1}(2).name = 'countdown'; onset{1}(2).onset = countdown_1(:,1) ;  onset{1}(2).duration = countdown_1(:,2) - countdown_1(:,1);
onset{1}(3).name = 'sequence';  onset{1}(3).onset = sequence_1(:,1)  ;  onset{1}(3).duration = sequence_1(:,2) - sequence_1(:,1);

onset{2}(1).name = 'LRLR';      onset{2}(1).onset = LRLR_2(:,1)      ;  onset{2}(1).duration = LRLR_2(:,2) - LRLR_2(:,1);
onset{2}(2).name = 'countdown'; onset{2}(2).onset = countdown_2(:,1) ;  onset{2}(2).duration = countdown_2(:,2) - countdown_2(:,1);
onset{2}(3).name = 'sequence';  onset{2}(3).onset = sequence_2(:,1)  ;  onset{2}(3).duration = sequence_2(:,2) - sequence_2(:,1);

onset{3}(1).name = 'LRLR';      onset{3}(1).onset = LRLR_3(:,1)      ;  onset{3}(1).duration = LRLR_3(:,2) - LRLR_3(:,1);
onset{3}(2).name = 'countdown'; onset{3}(2).onset = countdown_3(:,1) ;  onset{3}(2).duration = countdown_3(:,2) - countdown_3(:,1);
onset{3}(3).name = 'sequence';  onset{3}(3).onset = sequence_3(:,1)  ;  onset{3}(3).duration = sequence_3(:,2) - sequence_3(:,1);


%% first level

statdir=r_mkdir(suj,'stat')
execdir=r_mkdir(statdir,'exec')
do_delete(execdir,0)
execdir=r_mkdir(statdir,'exec')

par.file_reg = '^swutrf.*nii';

par.TR=2.250;
par.delete_previous=1;


%% Specify model

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

j = job_first_level12(dfonc,execdir,onset,par)


%% Estimate model

fspm = get_subdir_regex_files(execdir,'SPM',1)
j_estimate = job_first_level12_estimate(fspm,par)


%% Define contrast: all runs

contrast.names = {
    
'main effect : LRLR'
'main effect : countdown'
'main effect : sequence'
'LRLR - countdown'
'LRLR - sequence'
'countdown - LRLR'
'countdown - sequence'
'sequence - LRLR'
'sequence - countdown'

}';
contrast.values = {
    [ 1 0 0 ]
    [ 0 1 0 ]
    [ 0 0 1 ]
    [ 1 -1 0 ]
    [ 1 0 -1 ]
    [ -1 1 0 ]
    [ 0 1 -1 ]
    [ -1 0 1 ]
    [ 0 -1 1 ]
    }';
contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));

par.delete_previous=1;


%% Estimate contrast : all runs

par.run = 1;
par.display = 0;

j_contrast_rep = job_first_level12_contrast_repl(fspm,contrast,par)
par.delete_previous=0;


%% Define contrast: each run

contrast.names = {};
for run = 1 : nrRun
contrast.names = [contrast.names sprintf('%d - main effect : LRLR'     ,run)];
contrast.names = [contrast.names sprintf('%d - main effect : countdown',run)];
contrast.names = [contrast.names sprintf('%d - main effect : sequence' ,run)];
contrast.names = [contrast.names sprintf('%d - LRLR - countdown'       ,run)];
contrast.names = [contrast.names sprintf('%d - LRLR - sequence'        ,run)];
contrast.names = [contrast.names sprintf('%d - countdown - LRLR'       ,run)];
contrast.names = [contrast.names sprintf('%d - countdown - sequence'   ,run)];
contrast.names = [contrast.names sprintf('%d - sequence - LRLR'        ,run)];
contrast.names = [contrast.names sprintf('%d - sequence - countdown'   ,run)];
end



 main_contrasts = {
    [ 1 0 0 ]
    [ 0 1 0 ]
    [ 0 0 1 ]
    [ 1 -1 0 ]
    [ 1 0 -1 ]
    [ -1 1 0 ]
    [ 0 1 -1 ]
    [ -1 0 1 ]
    [ 0 -1 1 ]
    };

run1_full_contrasts = {};
for c = 1 : length(main_contrasts)
    run1_full_contrasts{c} = [ main_contrasts{c} [ 0 0 0 0 0 0 ] repmat([ main_contrasts{c}*0 [ 0 0 0 0 0 0 ] ], [1 nrRun-1]) ];
end

contrast.values = {};
for run = 1 : nrRun
    
    for c = 1 : length(main_contrasts)
        contrast.values = [ contrast.values circshift( run1_full_contrasts{c} , [0 9*(run-1)] ) ];
    end

end
contrast.values = contrast.values;

contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast : each run

par.run = 1;
par.display = 0;

j_contrast_rep = job_first_level12_contrast(fspm,contrast,par)


%% Define contrast: leaning

contrast.names = {
    
'Increase of activation with learning : Hand vs Eye'
'Decrease of activation with learning : Hand vs Eye'

}';

contrast.values = {
    [ -2 0 1 [0 0 0 0 0 0] -2 0 2 [0 0 0 0 0 0] -2 0 3 [0 0 0 0 0 0] ]
    [ -2 0 3 [0 0 0 0 0 0] -2 0 2 [0 0 0 0 0 0] -2 0 1 [0 0 0 0 0 0] ]
    
    };

contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast : learning

par.run = 1;
par.display = 0;

j_contrast_rep = job_first_level12_contrast(fspm,contrast,par)


%% Display


show{1}.spm.stats.results.spmmat = fspm;
show{1}.spm.stats.results.conspec.titlestr = '';
show{1}.spm.stats.results.conspec.contrasts = 1;
show{1}.spm.stats.results.conspec.threshdesc = 'none'; % 'none' 'FWE' 'FDR'
show{1}.spm.stats.results.conspec.thresh = 0.05;
show{1}.spm.stats.results.conspec.extent = 10;
show{1}.spm.stats.results.conspec.conjunction = 1;
show{1}.spm.stats.results.conspec.mask.none = 1;
show{1}.spm.stats.results.units = 1;
show{1}.spm.stats.results.print = false;
show{1}.spm.stats.results.write.none = 1;


%% Display

spm('defaults','FMRI');
spm_jobman('run', show );
