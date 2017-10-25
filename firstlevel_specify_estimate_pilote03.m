clear
clc

imgdir   = [ pwd filesep 'img'];
stimdirs = [ pwd filesep 'stim'];
load('exarr_stim.mat')

regex_dfonc = '^run_(DualTask|SpeedTest|Training|Execution|Imagination|Sleep)_\d{3}$';
regex_stim  = '(DualTask_Simple|DualTask_Complex|SpeedTest|Training)_MRI_.*_SPM.mat$';


%% Fetch stim files

examArray.getSeries(regex_dfonc).print
% examArray.getSeries(regex_dfonc).addStim(stimdirs,regex_stim,'onsets')

LINK = {
    
% SERIE DIR                                STIM FILE NAME

'S03_DualTask_Simple_Start_1'             'DualTask_Simple_MRI_Start_1_SPM.mat$'
'S05_DualTask_Complex_Start_1'            'DualTask_Complex_MRI_Start_1_SPM.mat$'
'S07_Training_Start'                      'Training_MRI_Start_1_SPM.mat$'

'S11_DualTask_Simple_Pre_1'               'DualTask_Simple_MRI_Pre_1_SPM.mat$'
'S13_DualTask_Complex_Pre_1'              'DualTask_Complex_MRI_Pre_1_SPM.mat$'
'S17_SpeedTest_Pre_1'                     'SpeedTest_MRI_Pre_1_SPM.mat$'
% 'S19_Sleep_1'
'S21_SpeedTest_Post_1'                    'SpeedTest_MRI_Post_1_SPM.mat$'
'S23_DualTask_Simple_Post_1'              'DualTask_Simple_MRI_Post_1_SPM.mat$'
'S25_DualTask_Complex_Post_1'             'DualTask_Complex_MRI_Post_1_SPM.mat$'

% --- break ---

'S28_DualTask_Simple_Pre_2'               'DualTask_Simple_MRI_Pre_2_SPM.mat$'
'S30_DualTask_Complex_Pre_2'              'DualTask_Complex_MRI_Pre_2_SPM.mat$'
'S32_SpeedTest_Pre_2'                     'SpeedTest_MRI_Pre_2_SPM.mat$'
% 'S34_Sleep_2'
'S36_SpeedTest_Post_2'                    'SpeedTest_MRI_Post_2_SPM.mat$'
'S38_DualTask_Simple_Post_2'              'DualTask_Simple_MRI_Post_2_SPM.mat$'
'S40_DualTask_Complex_Post_2'             'DualTask_Complex_MRI_Post_2_SPM.mat$'

% --- break ---

'S43_DualTask_Simple_Pre_3'               'DualTask_Simple_MRI_Pre_3_SPM.mat$'
'S45_DualTask_Complex_Pre_3'              'DualTask_Complex_MRI_Pre_3_SPM.mat$'
'S47_SpeedTest_Pre_3'                     'SpeedTest_MRI_Pre_3_SPM.mat$'
% 'S49_Sleep_3'
'S51_SpeedTest_Post_3'                    'SpeedTest_MRI_Post_3_SPM.mat$'
'S53_DualTask_Simple_Post_3'              'DualTask_Simple_MRI_Post_3_SPM.mat$'
'S55_DualTask_Complex_Post_3'             'DualTask_Complex_MRI_Post_3_SPM.mat$'

% --- break ---

'S59_DualTask_Simple_Pre_4'               'DualTask_Simple_MRI_Pre_4_SPM.mat$'
'S61_DualTask_Complex_Pre_exec_4'         'DualTask_Complex_MRI_Pre_4_SPM.mat$'
'S63_SpeedTest_Pre_exec_4'                'SpeedTest_MRI_Pre_4_SPM.mat$'
% 'S65_Execution_4'
'S67_SpeedTest_Post_exec_4'               'SpeedTest_MRI_Post_4_SPM.mat$'
'S69_DualTask_Simple_PostExec_PreImag_4'  'DualTask_Simple_MRI_Post_4_SPM.mat$'
'S71_DualTask_Complex_PostExec_PreImag_4' 'DualTask_Complex_MRI_Post_4_SPM.mat$'
'S73_SpeedTest_Pre_imag_4'                'SpeedTest_MRI_Post_5_SPM.mat$'
% 'S75_Imagination_4'
'S77_SpeedTest_Post_imag_4'               'SpeedTest_MRI_Post_5_SPM.mat$'
'S79_DualTask_Simple_Post_imag_4'         'DualTask_Simple_MRI_Post_4_SPM.mat$'
'S81_DualTask_Complex_Post_imag_4'        'DualTask_Complex_MRI_Post_4_SPM.mat$'
'S83_Training_end'                        'Training_MRI_End_1_SPM.mat$'

};

for l = 1 : size(LINK,1)
    examArray.getSeries(LINK{l,1},'name').addStim(stimdirs,LINK{l,2},'SPMnod')
end

% examArray.explore


%% prepare first level : groupe 8

statdir=r_mkdir(examArray.toJobs,'stat');

session_1_dir = r_mkdir(statdir,'session_1');
session_2_dir = r_mkdir(statdir,'session_2');
session_3_dir = r_mkdir(statdir,'session_3');
session_4_dir = r_mkdir(statdir,'session_4');
do_delete(session_1_dir,0)
do_delete(session_2_dir,0)
do_delete(session_3_dir,0)
do_delete(session_4_dir,0)
session_1_dir = r_mkdir(statdir,'session_1');
session_2_dir = r_mkdir(statdir,'session_2');
session_3_dir = r_mkdir(statdir,'session_3');
session_4_dir = r_mkdir(statdir,'session_4');

par.file_reg = '^swutrf.*nii';
par.TR=2.200;
par.delete_previous=1;
par.rp = 1; % realignment paramters : movement regressors
par.run = 1;
par.display = 0;

%% Specify model : prepare list of (run,stimfile)

% --- SESSION 1 ---

session_1 = {
    'S11_DualTask_Simple_Pre_1'               'DualTask_Simple_MRI_Pre_1_SPM.mat$'
    'S13_DualTask_Complex_Pre_1'              'DualTask_Complex_MRI_Pre_1_SPM.mat$'
    'S17_SpeedTest_Pre_1'                     'SpeedTest_MRI_Pre_1_SPM.mat$'
    % 'S19_Sleep_1'
    'S21_SpeedTest_Post_1'                    'SpeedTest_MRI_Post_1_SPM.mat$'
    'S23_DualTask_Simple_Post_1'              'DualTask_Simple_MRI_Post_1_SPM.mat$'
    'S25_DualTask_Complex_Post_1'             'DualTask_Complex_MRI_Post_1_SPM.mat$'
    };

dfunc_session_1 = examArray.getSeries(session_1(:,1),'name').toJobs;
stim_session_1 = examArray.getSeries(session_1(:,1),'name').getStim.toJobs;


% --- SESSION 2 ---

session_2 = {
    'S28_DualTask_Simple_Pre_2'               'DualTask_Simple_MRI_Pre_2_SPM.mat$'
    'S30_DualTask_Complex_Pre_2'              'DualTask_Complex_MRI_Pre_2_SPM.mat$'
    'S32_SpeedTest_Pre_2'                     'SpeedTest_MRI_Pre_2_SPM.mat$'
    % 'S34_Sleep_2'
    'S36_SpeedTest_Post_2'                    'SpeedTest_MRI_Post_2_SPM.mat$'
    'S38_DualTask_Simple_Post_2'              'DualTask_Simple_MRI_Post_2_SPM.mat$'
    'S40_DualTask_Complex_Post_2'             'DualTask_Complex_MRI_Post_2_SPM.mat$'
    };

dfunc_session_2 = examArray.getSeries(session_2(:,1),'name').toJobs;
stim_session_2 = examArray.getSeries(session_2(:,1),'name').getStim.toJobs;


% --- SESSION 3 ---

session_3 = {
    'S43_DualTask_Simple_Pre_3'               'DualTask_Simple_MRI_Pre_3_SPM.mat$'
    'S45_DualTask_Complex_Pre_3'              'DualTask_Complex_MRI_Pre_3_SPM.mat$'
    'S47_SpeedTest_Pre_3'                     'SpeedTest_MRI_Pre_3_SPM.mat$'
    % 'S49_Sleep_3'
    'S51_SpeedTest_Post_3'                    'SpeedTest_MRI_Post_3_SPM.mat$'
    'S53_DualTask_Simple_Post_3'              'DualTask_Simple_MRI_Post_3_SPM.mat$'
    'S55_DualTask_Complex_Post_3'             'DualTask_Complex_MRI_Post_3_SPM.mat$'
    };

dfunc_session_3 = examArray.getSeries(session_3(:,1),'name').toJobs;
stim_session_3 = examArray.getSeries(session_3(:,1),'name').getStim.toJobs;


% --- SESSION 4 ---

session_4 = {
    'S59_DualTask_Simple_Pre_4'               'DualTask_Simple_MRI_Pre_4_SPM.mat$'
    'S61_DualTask_Complex_Pre_exec_4'         'DualTask_Complex_MRI_Pre_4_SPM.mat$'
    'S63_SpeedTest_Pre_exec_4'                'SpeedTest_MRI_Pre_4_SPM.mat$'
    % 'S65_Execution_4'
    'S67_SpeedTest_Post_exec_4'               'SpeedTest_MRI_Post_4_SPM.mat$'
    'S69_DualTask_Simple_PostExec_PreImag_4'  'DualTask_Simple_MRI_Post_4_SPM.mat$'
    'S71_DualTask_Complex_PostExec_PreImag_4' 'DualTask_Complex_MRI_Post_4_SPM.mat$'
    'S73_SpeedTest_Pre_imag_4'                'SpeedTest_MRI_Post_5_SPM.mat$'
    % 'S75_Imagination_4'
    'S77_SpeedTest_Post_imag_4'               'SpeedTest_MRI_Post_5_SPM.mat$'
    'S79_DualTask_Simple_Post_imag_4'         'DualTask_Simple_MRI_Post_4_SPM.mat$'
    'S81_DualTask_Complex_Post_imag_4'        'DualTask_Complex_MRI_Post_4_SPM.mat$'
    'S83_Training_end'                        'Training_MRI_End_1_SPM.mat$'
    };

dfunc_session_4 = examArray.getSeries(session_4(:,1),'name').toJobs;
stim_session_4 = examArray.getSeries(session_4(:,1),'name').getStim.toJobs;


%% Specify model : job spm

j_specify_1 = job_first_level_specify(dfunc_session_1,session_1_dir,stim_session_1,par);
j_specify_2 = job_first_level_specify(dfunc_session_2,session_2_dir,stim_session_2,par);
j_specify_3 = job_first_level_specify(dfunc_session_3,session_3_dir,stim_session_3,par);
j_specify_4 = job_first_level_specify(dfunc_session_4,session_4_dir,stim_session_4,par);


%% Estimate model

session_all_dir = get_subdir_regex(statdir,'session');
fspm = get_subdir_regex_files(session_all_dir,'SPM',1);
j_estimate = job_first_level_estimate(fspm,par);

