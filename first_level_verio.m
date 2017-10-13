clear all
clc

%% Prepare paths and regexp

chemin='/media/benoit/DATADRIVE1/fMRI_data_benoit/MEMODREAM/img';
% chemin='E:\fMRI_data_benoit\MEMODREAM\img';

suj = get_subdir_regex(chemin,'Pilote02');
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
  9.868 14.984
  27.304 30.668
  42.612 46.392
  62.092 65.584
  79.780 83.800 
  95.900 100.368
  110.796 115.293
  129.440 134.412
  148.560 153.240
    ]+time_offcet;

exec.countdown_1 = [
   14.984 27.304
   65.584 79.780
   115.296 129.440
    ]+time_offcet;

exec.sequence_1 = [
 30.668 42.612
 83.800 95.900
 134.412 148.560
    ]+time_offcet;

% Run 2

exec.LRLR_2 = [
   0.252 4.644
   16.316 21.356
   32.884 37.316
   62.092 65.584
   79.780 83.800
   95.900 100.368
   110.796 115.296
   129.440 134.412 
   148.560 153.240
    ]+time_offcet;

exec.countdown_2 = [
   4.644 16.316
   60.196 73.148
   120.712 136.728
    ]+time_offcet;

exec.sequence_2 = [
   21.356 32.884
   78.300 90.476
   142.528 156.540
    ]+time_offcet;

% Run 3

exec.LRLR_3 = [
3.240 9.328
24.096 28.888
40.988 45.636
71.732 76.524
91.184 96.416
110.248 114.856
140.368 145.408
158.996 164.864
178.732 184.496
    ]+time_offcet;

exec.countdown_3 = [
   9.328 24.096
   76.524 91.184
   145.408 158.996
    ]+time_offcet;

exec.sequence_3 = [
   28.888 40.988
   96.416 110.248
   164.864 178.732
    ]+time_offcet;


%% my onsets : IMAGINATION

time_offcet = +0.400; % seconds // due to the format_vmrk.m, the t0 read on Analyser is shifted

% Run 1

ima.LRLR_1 = [
   0.180 3.708
   15.020 19.916
   29.788 33.892
   43.928 49.152
   62.948 67.556
   82.760 87.660
   95.440 100.228
   111.720 116.836
   138.208 143.320
   148.152 153.124
   165.984 171.136
   189.692 194.988
   201.668 207.062
   221.512 228.428
   251.584 257.200
    ]+time_offcet;

ima.countdown_1 = [
  3.708 15.02
  49.152 62.948
  100.228 111.720
  153.124 165.984
  207.062 221.512
    ]+time_offcet;

ima.sequence_1 = [
  19.916 29.788
  67.556 82.760
  116.836 138.208
  171.136 189.692
  228.428 251.584
    ]+time_offcet;

% Run 2

ima.LRLR_2 = [
   0.360 3.024
   15.848 21.504
   43.944 49.984
   58.712 63.464
   77.604 82.824
   107.604 112.500
   117.388 122.432
   136.584 142.744
   168.832 174.480
   178.044 184.060
   199.828 205.304 
   223.728 228.916
   232.432 237.836
   254.224 259.772
   283.348 289.112
    ]+time_offcet;

ima.countdown_2 = [
    3.024 15.848
    63.464 77.604
    122.432 136.584
    184.060 199.828
    237.836 254.224
    ]+time_offcet;

ima.sequence_2 = [
    21.504 43.944
    82.824 107.604
    142.744 168.832
    205.304 223.728
    259.772 283.348
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


%% Do what is commin to the two machines

firstlevel_common;
