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
ffonc = get_subdir_regex_files(dfonc,'^swutrf'); char(ffonc)
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
    206.724 219.188
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


%% Go

do_classic_contrasts

do_learning_contrast_execution

display_contrasts
