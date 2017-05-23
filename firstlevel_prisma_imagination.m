clear all
clc

%% Prepare paths and regexp

chemin='/media/benoit/DATADRIVE1/fMRI_data_benoit/MEMODREAM/img';

suj = get_subdir_regex(chemin,'Pilote01');
% suj = get_subdir_regex(chemin);
%to see the content
char(suj)

%functional and anatomic subdir
par.dfonc_reg='imagination$';

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
    9.572 15.744
    30.912 37.488
    58.262 64.536
    77.188 83.588
    96.276 102.968
    125.172 132.208
    147.340 153.684
    164.932 171.680
    193.248 199.248
    212.120 218.976
    232.636 238.920
    260.416 266.484
    ]+time_offcet;

countdown_1 = [
    15.744 30.912
    83.588 96.276
    153.684 164.932
    218.976 232.636
    ]+time_offcet;

sequence_1 = [
    37.488 58.262
    102.968 125.172
    171.680 193.248
    238.920 260.416
    ]+time_offcet;

% Run 2

LRLR_2 = [
    1.552 6.856
    17.924 24.320
    44.432 49.392
    56.428 62.480
    76.776 83.344
    104.668 109.568
    118.824 123.260
    137.840 144.644
    168.964 175.304
    182.436 189.180
    198.344 203.704
    227.216 235.516
    ]+time_offcet;

countdown_2 = [
    6.856 17.924
    62.480 76.776
    123.260 137.840
    189.180 198.344
    ]+time_offcet;

sequence_2 = [
    24.320 44.432
    83.344 104.668
    144.644 168.964
    203.704 227.216
    ]+time_offcet;


%% Onsets formating

%    run,condition
onset{1}(1).name = 'LRLR';      onset{1}(1).onset = LRLR_1(:,1)      ;  onset{1}(1).duration = LRLR_1(:,2) - LRLR_1(:,1);
onset{1}(2).name = 'countdown'; onset{1}(2).onset = countdown_1(:,1) ;  onset{1}(2).duration = countdown_1(:,2) - countdown_1(:,1);
onset{1}(3).name = 'sequence';  onset{1}(3).onset = sequence_1(:,1)  ;  onset{1}(3).duration = sequence_1(:,2) - sequence_1(:,1);

onset{2}(1).name = 'LRLR';      onset{2}(1).onset = LRLR_2(:,1)      ;  onset{2}(1).duration = LRLR_2(:,2) - LRLR_2(:,1);
onset{2}(2).name = 'countdown'; onset{2}(2).onset = countdown_2(:,1) ;  onset{2}(2).duration = countdown_2(:,2) - countdown_2(:,1);
onset{2}(3).name = 'sequence';  onset{2}(3).onset = sequence_2(:,1)  ;  onset{2}(3).duration = sequence_2(:,2) - sequence_2(:,1);


%% first level

statdir=r_mkdir(suj,'stat')
execdir=r_mkdir(statdir,'imagination')
do_delete(execdir,0)
execdir=r_mkdir(statdir,'imagination')

par.file_reg = '^swutrf.*nii';

par.TR=2.250;
par.delete_previous=1;


%% Go

do_classic_contrasts

do_learning_contrast_imagination

display_contrasts
