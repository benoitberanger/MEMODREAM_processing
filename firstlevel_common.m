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
par.delete_previous=0;

%% Contrast : activity difference over thr runs

contrast.names = {
    
'increase of accitivy : hands vs eye'
'decrease of accitivy : hands vs eye'


}';

contrast.values = {
    
    [ -3 0 1 rpVect -3 0 2 rpVect -3 0 3 rpVect -3 0 4 rpVect -3 0 5 rpVect ]
    [ -3 0 5 rpVect -3 0 4 rpVect -3 0 3 rpVect -3 0 2 rpVect -3 0 1 rpVect ]
    
    }';


contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast

par.run = 1;
par.display = 0;

par.sessrep = 'none';

j_contrast = job_first_level_contrast(fspm,contrast,par)


%% Contrast : activity difference over thr runs

contrast.names = {
    
'increase of accitivy : main effect hand'
'decrease of accitivy : main effect hand'


}';

contrast.values = {
    
    [ 0 0 -2 rpVect 0 0 -1 rpVect 0 0 0 rpVect 0 0 1 rpVect 0 0 2 rpVect ]
    [ 0 0 2 rpVect 0 0 1 rpVect 0 0 0 rpVect 0 0 -1 rpVect 0 0 -2 rpVect ]
    
    }';


contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast

par.run = 1;
par.display = 0;

par.sessrep = 'none';

j_contrast = job_first_level_contrast(fspm,contrast,par)


%% Contrast : activity difference over thr runs

contrast.names = {
    
'IMA - EXEC : main effect hand'
'EXEC - IMA : main effect hand'


}';

contrast.values = {
    
    [ 0 0 -2 rpVect 0 0 -2 rpVect 0 0 -2 rpVect 0 0 3 rpVect 0 0 3 rpVect ]
    [ 0 0 2 rpVect 0 0 2 rpVect 0 0 2 rpVect 0 0 -3 rpVect 0 0 -3 rpVect ]
    
    }';


contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast

par.run = 1;
par.display = 0;

par.sessrep = 'none';

j_contrast = job_first_level_contrast(fspm,contrast,par)


%% Contrast : EXEC increase/decrease of activation during motor task

contrast.names = {
    
'EXEC increase of activation'
'EXEC decrease of activation'


}';

contrast.values = {
    
    [ 0 -2 1 rpVect 0 -2 2 rpVect 0 -2 3 rpVect]
    [ 0 -2 3 rpVect 0 -2 2 rpVect 0 -2 1 rpVect]
    
    }';


contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));


%% Estimate contrast

par.run = 1;
par.display = 0;

par.sessrep = 'none';

j_contrast = job_first_level_contrast(fspm,contrast,par)


%% Display

display_contrasts
