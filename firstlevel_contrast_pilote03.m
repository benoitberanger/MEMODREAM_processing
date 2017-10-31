clear
clc

imgdir   = [ pwd filesep 'img'];
stimdirs = [ pwd filesep 'stim'];
load('exarr_stim.mat')

statdir = get_subdir_regex(examArray.toJobs,'stat');
session_all_dir = get_subdir_regex(statdir,'session');
fspm = get_subdir_regex_files(session_all_dir,'SPM',1);

par.delete_previous=1;
par.run = 1;
par.display = 0;
par.sessrep = 'none';


%% Define contrasts

% Tap

rp = [0 0 0 0 0 0];

% 2 conditions for each run
null = [0 0 rp];
rest = [1 0 rp];
tap  = [0 1 rp];

% --- SESSION 1 ---

contrast(1).names = {
    
'Session 1 : Tap-Rest : DT_Simple  : Pre'
'Session 1 : Tap-Rest : DT_Complex : Pre'
'Session 1 : Tap-Rest : SpeedTest  : Pre'
'Session 1 : Tap-Rest : SpeedTest  : Post'
'Session 1 : Tap-Rest : DT_Simple  : Post'
'Session 1 : Tap-Rest : DT_Complex : Post'


'Session 1 : Tap : Post-Pre : DT_Simple'
'Session 1 : Tap : Post-Pre : DT_Complex'
'Session 1 : Tap : Post-Pre : SpeedTest'

'Session 1 : Tap : Pre : DT_Complex-SpeedTest'

}';

contrast(1).values = {
    
[ -rest+tap null null null null null ]
[ null -rest+tap null null null null ]
[ null null -rest+tap null null null ]
[ null null null -rest+tap null null ]
[ null null null null -rest+tap null ]
[ null null null null null -rest+tap ]

[ -tap null null null tap  null ]
[ null -tap null null null tap  ]
[ null null -tap tap  null null ]

[ null tap -tap null null null ]

}';

contrast(1).types = cat(1,repmat({'T'},[1 length(contrast(1).names)]));


% --- SESSION 2 ---

contrast(2).names = {
    
'Session 2 : Tap-Rest : DT_Simple  : Pre'
'Session 2 : Tap-Rest : DT_Complex : Pre'
'Session 2 : Tap-Rest : SpeedTest  : Pre'
'Session 2 : Tap-Rest : SpeedTest  : Post'
'Session 2 : Tap-Rest : DT_Simple  : Post'
'Session 2 : Tap-Rest : DT_Complex : Post'

'Session 2 : Tap : Post-Pre : DT_Simple'
'Session 2 : Tap : Post-Pre : DT_Complex'
'Session 2 : Tap : Post-Pre : SpeedTest'

'Session 2 : Tap : Pre : DT_Complex-SpeedTest'


}';

contrast(2).values = {
    
[ -rest+tap null null null null null ]
[ null -rest+tap null null null null ]
[ null null -rest+tap null null null ]
[ null null null -rest+tap null null ]
[ null null null null -rest+tap null ]
[ null null null null null -rest+tap ]

[ -tap null null null tap  null ]
[ null -tap null null null tap  ]
[ null null -tap tap  null null ]

[ null tap -tap null null null ]

}';

contrast(2).types = cat(1,repmat({'T'},[1 length(contrast(2).names)]));


% --- SESSION 3 ---

contrast(3).names = {
    
'Session 3 : Tap-Rest : DT_Simple  : Pre'
'Session 3 : Tap-Rest : DT_Complex : Pre'
'Session 3 : Tap-Rest : SpeedTest  : Pre'
'Session 3 : Tap-Rest : SpeedTest  : Post'
'Session 3 : Tap-Rest : DT_Simple  : Post'
'Session 3 : Tap-Rest : DT_Complex : Post'

'Session 3 : Tap : Post-Pre : DT_Simple'
'Session 3 : Tap : Post-Pre : DT_Complex'
'Session 3 : Tap : Post-Pre : SpeedTest'

'Session 3 : Tap : Pre : DT_Complex-SpeedTest'

}';

contrast(3).values = {
    
[ -rest+tap null null null null null ]
[ null -rest+tap null null null null ]
[ null null -rest+tap null null null ]
[ null null null -rest+tap null null ]
[ null null null null -rest+tap null ]
[ null null null null null -rest+tap ]

[ -tap null null null tap  null ]
[ null -tap null null null tap  ]
[ null null -tap tap  null null ]

[ null tap -tap null null null ]

}';

contrast(3).types = cat(1,repmat({'T'},[1 length(contrast(3).names)]));


% --- SESSION 4 ---

contrast(4).names = {
    
'Session 4 : Tap-Rest : DT_Simple  : PreE'
'Session 4 : Tap-Rest : DT_Complex : PreE'
'Session 4 : Tap-Rest : SpeedTest  : PreE'
% Execution
'Session 4 : Tap-Rest : SpeedTest  : PostE'
'Session 4 : Tap-Rest : DT_Simple  : PostEPreI'
'Session 4 : Tap-Rest : DT_Complex : PostEPreI'
'Session 4 : Tap-Rest : SpeedTest  : PreI'
% Imagination
'Session 4 : Tap-Rest : SpeedTest  : PostI'
'Session 4 : Tap-Rest : DT_Simple  : PostI'
'Session 4 : Tap-Rest : DT_Complex : PostI'

'Session 4 : Post-Pre EXEC : DT_Simple'
'Session 4 : Post-Pre EXEC : DT_Complex'
'Session 4 : Post-Pre EXEC : SpeedTest'

'Session 4 : Post-Pre IMAG : DT_Simple'
'Session 4 : Post-Pre IMAG : DT_Complex'
'Session 4 : Post-Pre IMAG : SpeedTest'

}';

contrast(4).values = {
    
[ -rest+tap null null null null null null null null null ]
[ null -rest+tap null null null null null null null null ]
[ null null -rest+tap null null null null null null null ]
[ null null null -rest+tap null null null null null null ]
[ null null null null -rest+tap null null null null null ]
[ null null null null null -rest+tap null null null null ]
[ null null null null null null -rest+tap null null null ]
[ null null null null null null null -rest+tap null null ]
[ null null null null null null null null -rest+tap null ]
[ null null null null null null null null null -rest+tap ]

[ -tap null null null tap  null null null null null ]
[ null -tap null null null tap  null null null null ]
[ null null -tap tap  null null null null null null ]

[ null null null null -tap null null null tap  null ]
[ null null null null null -tap null null null tap  ]
[ null null null null null null -tap tap  null null ]

}';

contrast(4).types = cat(1,repmat({'T'},[1 length(contrast(4).names)]));


%% Estimate contrast

j_contrast_1 = job_first_level_contrast(fspm(1),contrast(1),par);
j_contrast_2 = job_first_level_contrast(fspm(2),contrast(2),par);
j_contrast_3 = job_first_level_contrast(fspm(3),contrast(3),par);
j_contrast_4 = job_first_level_contrast(fspm(4),contrast(4),par);


%% Show results

matlabbatch{1}.spm.stats.results.spmmat = fspm(4);
matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 10;
matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.print = false;
matlabbatch{1}.spm.stats.results.write.none = 1;

spm_jobman('run',matlabbatch)
