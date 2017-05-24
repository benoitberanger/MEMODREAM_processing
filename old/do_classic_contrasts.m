%% Specify model

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

j = job_first_level_specify(dfonc,execdir,onset,par)


%% Estimate model

fspm = get_subdir_regex_files(execdir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


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

par.sessrep = 'repl';

j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
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

par.sessrep = 'none';

j_contrast = job_first_level_contrast(fspm,contrast,par)

