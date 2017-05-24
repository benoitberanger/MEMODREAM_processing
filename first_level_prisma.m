clear all
clc

%% Prepare paths and regexp

chemin='/media/benoit/DATADRIVE1/fMRI_data_benoit/MEMODREAM/img';

suj = get_subdir_regex(chemin,'Pilote01');
% suj = get_subdir_regex(chemin);
%to see the content
char(suj)

%functional and anatomic subdir
par.dfonc_reg='(execution|imagination)$';

par.display=0;
par.run=1;

%% Get files paths

dfonc = get_subdir_regex_multi(suj,par.dfonc_reg); char(dfonc{:})
ffonc = get_subdir_regex_files(dfonc,'^swutrf'); char(ffonc)
nrRun = size(ffonc{1},1);

%% my onsets : EXECUTION

time_offcet = +0.400; % seconds // due to the format_vmrk.m, the t0 read on Analyser is shifted

% Run 1

exec.LRLR_1 = [
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

exec.countdown_1 = [
    10.508 22.432
    76.588 94.920
    182.964 198.104
    ]+time_offcet;

exec.sequence_1 = [
    27.204 38.324
    100.912 113.436
    203.512 215.320
    ]+time_offcet;

% Run 2

exec.LRLR_2 = [
    12.304 17.872
    30.732 36.468
    47.860 52.612
    79.680 84.872
    100.732 107.680
    120.032 126.464
    ]+time_offcet;

exec.countdown_2 = [
    17.872 30.732
    84.82 100.732
    171.656 187.372
    ]+time_offcet;

exec.sequence_2 = [
    36.468 47.860
    107.680 120.032
    194.236 207.284
    ]+time_offcet;

% Run 3

exec.LRLR_3 = [
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

exec.countdown_3 = [
    24.380 37.328
    103.120 116.556
    183.280 200.380
    ]+time_offcet;

exec.sequence_3 = [
    43.640 56.032
    122.932 134.428
    206.724 219.188
    ]+time_offcet;


%% my onsets : IMAGINATION

time_offcet = +0.400; % seconds // due to the format_vmrk.m, the t0 read on Analyser is shifted

% Run 1

ima.LRLR_1 = [
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

ima.countdown_1 = [
    15.744 30.912
    83.588 96.276
    153.684 164.932
    218.976 232.636
    ]+time_offcet;

ima.sequence_1 = [
    37.488 58.262
    102.968 125.172
    171.680 193.248
    238.920 260.416
    ]+time_offcet;

% Run 2

ima.LRLR_2 = [
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

ima.countdown_2 = [
    6.856 17.924
    62.480 76.776
    123.260 137.840
    189.180 198.344
    ]+time_offcet;

ima.sequence_2 = [
    24.320 44.432
    83.344 104.668
    144.644 168.964
    203.704 227.216
    ]+time_offcet;


%% Onsets formating

%    run,condition
onset{1}(1).name = 'LRLR';      onset{1}(1).onset = exec.LRLR_1(:,1)      ;  onset{1}(1).duration = exec.LRLR_1(:,2) - exec.LRLR_1(:,1);
onset{1}(2).name = 'countdown'; onset{1}(2).onset = exec.countdown_1(:,1) ;  onset{1}(2).duration = exec.countdown_1(:,2) - exec.countdown_1(:,1);
onset{1}(3).name = 'sequence';  onset{1}(3).onset = exec.sequence_1(:,1)  ;  onset{1}(3).duration = exec.sequence_1(:,2) - exec.sequence_1(:,1);

onset{2}(1).name = 'LRLR';      onset{2}(1).onset = exec.LRLR_2(:,1)      ;  onset{2}(1).duration = exec.LRLR_2(:,2) - exec.LRLR_2(:,1);
onset{2}(2).name = 'countdown'; onset{2}(2).onset = exec.countdown_2(:,1) ;  onset{2}(2).duration = exec.countdown_2(:,2) - exec.countdown_2(:,1);
onset{2}(3).name = 'sequence';  onset{2}(3).onset = exec.sequence_2(:,1)  ;  onset{2}(3).duration = exec.sequence_2(:,2) - exec.sequence_2(:,1);

onset{3}(1).name = 'LRLR';      onset{3}(1).onset = exec.LRLR_3(:,1)      ;  onset{3}(1).duration = exec.LRLR_3(:,2) - exec.LRLR_3(:,1);
onset{3}(2).name = 'countdown'; onset{3}(2).onset = exec.countdown_3(:,1) ;  onset{3}(2).duration = exec.countdown_3(:,2) - exec.countdown_3(:,1);
onset{3}(3).name = 'sequence';  onset{3}(3).onset = exec.sequence_3(:,1)  ;  onset{3}(3).duration = exec.sequence_3(:,2) - exec.sequence_3(:,1);

onset{4}(1).name = 'LRLR';      onset{4}(1).onset = ima.LRLR_1(:,1)      ;  onset{4}(1).duration = ima.LRLR_1(:,2) - ima.LRLR_1(:,1);
onset{4}(2).name = 'countdown'; onset{4}(2).onset = ima.countdown_1(:,1) ;  onset{4}(2).duration = ima.countdown_1(:,2) - ima.countdown_1(:,1);
onset{4}(3).name = 'sequence';  onset{4}(3).onset = ima.sequence_1(:,1)  ;  onset{4}(3).duration = ima.sequence_1(:,2) - ima.sequence_1(:,1);

onset{5}(1).name = 'LRLR';      onset{5}(1).onset = ima.LRLR_2(:,1)      ;  onset{5}(1).duration = ima.LRLR_2(:,2) - ima.LRLR_2(:,1);
onset{5}(2).name = 'countdown'; onset{5}(2).onset = ima.countdown_2(:,1) ;  onset{5}(2).duration = ima.countdown_2(:,2) - ima.countdown_2(:,1);
onset{5}(3).name = 'sequence';  onset{5}(3).onset = ima.sequence_2(:,1)  ;  onset{5}(3).duration = ima.sequence_2(:,2) - ima.sequence_2(:,1);


%% prepare first level


statdir=r_mkdir(suj,'stat')
execimadir=r_mkdir(statdir,'exec+ima')
do_delete(execimadir,0)
execimadir=r_mkdir(statdir,'exec+ima')

par.file_reg = '^swutrf.*nii';

par.TR=2.250;
par.delete_previous=1;


%% Specify model

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

j_specify = job_first_level_specify(dfonc,execimadir,onset,par)


%% Estimate model

fspm = get_subdir_regex_files(execimadir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast

rpVect = [0 0 0 0 0 0];

contrast.names = {
    
'EXEC : main effect : LRLR'
'EXEC : main effect : countdown'
'EXEC : main effect : sequence'
'EXEC : LRLR - countdown'
'EXEC : LRLR - sequence'
'EXEC : countdown - LRLR'
'EXEC : countdown - sequence'
'EXEC : sequence - LRLR'
'EXEC : sequence - countdown'

'IMA : main effect : LRLR'
'IMA : main effect : countdown'
'IMA : main effect : sequence'
'IMA : LRLR - countdown'
'IMA : LRLR - sequence'
'IMA : countdown - LRLR'
'IMA : countdown - sequence'
'IMA : sequence - LRLR'
'IMA : sequence - countdown'

}';

contrast.values = {
    
    [ repmat([[ 1 0 0 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 1 0 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 1 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 1 -1 0 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 1 0 -1 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ -1 1 0 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 1 -1 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ -1 0 1 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 -1 1 ] rpVect],[1 3]) repmat([[ 0 0 0 ] rpVect],[1 2]) ]
    
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 1 0 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 0 1 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 0 0 1 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 1 -1 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 1 0 -1 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ -1 1 0 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 0 1 -1 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ -1 0 1 ] rpVect],[1 2]) ]
    [ repmat([[ 0 0 0 ] rpVect],[1 3]) repmat([[ 0 -1 1 ] rpVect],[1 2]) ]
    
    }';


contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast

par.run = 1;
par.display = 0;

par.sessrep = 'none';

j_contrast = job_first_level_contrast(fspm,contrast,par)


%% Display

display_contrasts
