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


%% my onsets

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
    ];

countdown_1 = [
    10.508 22.432
    76.588 94.920
    182.964 198.104
    ];

sequence_1 = [
    27.204 38.324
    100.912 113.436
    203.512 215.320
    ];

% Run 2

LRLR_2 = [
    12.304 17.872
    30.732 36.468
    47.860 52.612
    79.680 84.872
    100.732 107.680
    120.032 126.464
    ];

countdown_2 = [
    17.872 30.732
    84.82 100.732
    171.656 187.372
    ];

sequence_2 = [
    36.468 47.860
    107.680 120.032
    194.236 207.284
    ];

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
    ];

countdown_3 = [
    24.380 37.328
    103.120 116.556
    183.280 200.380
    ];

sequence_3 = [
    43.640 56.032
    122.932 134.428
    183.280 219.188
    ];

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


%% Define contrast

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


%% Estimate contrast

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
