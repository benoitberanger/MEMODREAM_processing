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

par.sessrep = 'none';

j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
