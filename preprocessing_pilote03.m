clear
clc

%% Prepare paths and regexp

chemin = [ pwd filesep 'img'];

suj = get_subdir_regex(chemin,'Pilote03');
% suj = get_subdir_regex(chemin);
%to see the content
char(suj)

%functional and anatomic subdir
par.dfonc_reg='(execution|imagination)$';
par.dfonc_reg_oposit_phase = 'refAP$';
par.danat_reg='t1_mpr_sag_0_8iso';

%for the preprocessing : Volume selecytion
par.anat_file_reg  = '^s.*nii'; %le nom generique du volume pour l'anat
par.file_reg  = '^f.*nii'; %le nom generique du volume pour les fonctionel

par.display=0;
par.run=1;


%% Get files paths

% dfonc = get_subdir_regex_multi(suj,par.dfonc_reg) % ; char(dfonc{:})
% dfonc_op = get_subdir_regex_multi(suj,par.dfonc_reg_oposit_phase)% ; char(dfonc_op{:})
% dfoncall = get_subdir_regex_multi(suj,{par.dfonc_reg,par.dfonc_reg_oposit_phase })% ; char(dfoncall{:})
% anat = get_subdir_regex_one(suj,par.danat_reg)% ; char(anat) %should be no warning

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

examArray = exam(chemin,'Pilote03');

% T1
examArray.addSeries('t1_mpr_sag_0_8iso$'    ,'anat_start',1)
examArray.addSeries('t1_mpr_sag_0_8iso_end$','anat_end'  ,1)
examArray.addVolumes('anat','^s.*nii','s',1)

% Run : DualTask
examArray.addSeries('DualTask.*_\d$'      , 'run_DualTask'      )
examArray.addSeries('DualTask.*_\d_refAP$', 'run_DualTask_refAP') % refAP

% Run : SpeedTest
examArray.addSeries('SpeedTest.*_\d$'      , 'run_SpeedTest'      )
examArray.addSeries('SpeedTest.*_\d_refAP$', 'run_SpeedTest_refAP') % refAP

% Run : Sleep
examArray.addSeries('Sleep.*_\d$'      , 'run_Sleep'      )
examArray.addSeries('Sleep.*_\d_refAP$', 'run_Sleep_refAP') % refAP

% Run : Training
examArray.addSeries('Training_(Start|end)$', 'run_Training'      )
examArray.addSeries('Training.*_refAP$'    , 'run_Training_refAP') % refAP

% Run : Execution
examArray.addSeries('Execution.*_\d$'      , 'run_Execution'      )
examArray.addSeries('Execution.*_\d_refAP$', 'run_Execution_refAP') % refAP

% % Run : Imagination
examArray.addSeries('Imagination.*_\d$'      , 'run_Imagination'      )
examArray.addSeries('Imagination.*_\d_refAP$', 'run_Imagination_refAP') % refAP

% loca
% examArray.addSeries('localizer', 'localizer')

% All func volumes
examArray.addVolumes('run','^f.*nii','f',1)

% Unzip if necessary
unzip_volume(examArray.getVolumes.toJobs);
examArray.getVolumes.removeGZ

examArray.reorderSeries('name'); % mostly useful for topup, that requires pairs of (AP,PA)/(PA,AP) scans

examArray.explore

regex_dfonc = '^run_(DualTask|SpeedTest|Training|Execution|Imagination|Sleep)_\d{3}$';
dfonc = examArray.getSeries(regex_dfonc).toJobs
regex_dfonc_op = '^run_(DualTask|SpeedTest|Training|Execution|Imagination|Sleep)_refAP_\d{3}$';
dfonc_op = examArray.getSeries(regex_dfonc_op).toJobs
dfoncall = examArray.getSeries('run').toJobs
anat =  examArray.getSeries('anat').toJobs(0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Segment anat

% %anat segment
% % anat = get_subdir_regex(suj,par.danat_reg)
% fanat = get_subdir_regex_files(anat,par.anat_file_reg,1)
% 
% par.GM   = [0 0 1 0]; % Unmodulated / modulated / native_space dartel / import
% par.WM   = [0 0 1 0];
% j_segment = job_do_segment(fanat,par)
% 
% %apply normalize on anat
% fy = get_subdir_regex_files(anat,'^y',1)
% fanat = get_subdir_regex_files(anat,'^ms',1)
% j_apply_normalise=job_apply_normalize(fy,fanat,par)

%anat segment
fanat = examArray.getSeries('anat').getVolumes('^s').toJobs

par.GM   = [0 0 1 0]; % Unmodulated / modulated / native_space dartel / import
par.WM   = [0 0 1 0];
j_segment = job_do_segment(fanat,par)
fy_start    = examArray.getSeries('anat_start').addVolumes('^y' ,'y' )
fanat_start = examArray.getSeries('anat_start').addVolumes('^ms','ms')
fy_end    = examArray.getSeries('anat_end').addVolumes('^y' ,'y' )
fanat_end = examArray.getSeries('anat_end').addVolumes('^ms','ms')

%apply normalize on anat
j_apply_normalise=job_apply_normalize(fy_start,fanat_start,par)
j_apply_normalise=job_apply_normalize(fy_end,fanat_end,par)
examArray.getSeries('anat').addVolumes('^wms','wms',1)


%% Brain extract

% ff=get_subdir_regex_files(anat,'^c[123]',3);
% fo=addsuffixtofilenames(anat,'/mask_brain');
% do_fsl_add(ff,fo)
% fm=get_subdir_regex_files(anat,'^mask_b',1); fanat=get_subdir_regex_files(anat,'^s.*nii',1);
% fo = addprefixtofilenames(fanat,'brain_');
% do_fsl_mult(concat_cell(fm,fanat),fo);

ff_start=examArray.getSeries('anat_start').addVolumes('^c[123]','c',3)
fo_start=addsuffixtofilenames(anat{1}(1,:),'/mask_brain');
do_fsl_add(ff_start,fo_start)

fm_start=examArray.getSeries('anat_start').addVolumes('^mask_b','mask_brain',1)
fanat_start=examArray.getSeries('anat_start').getVolumes('^s').toJobs
fo_start = addprefixtofilenames(fanat_start,'brain_');
do_fsl_mult(concat_cell(fm_start,fanat_start),fo_start);
examArray.getSeries('anat_start').addVolumes('^brain_','brain',1)



ff_end=examArray.getSeries('anat_end').addVolumes('^c[123]','c',3)
fo_end=addsuffixtofilenames(anat{1}(2,:),'/mask_brain');
do_fsl_add(ff_end,fo_end)

fm_end=examArray.getSeries('anat_end').addVolumes('^mask_b','mask_brain',1)
fanat_end=examArray.getSeries('anat_end').getVolumes('^s').toJobs
fo_end = addprefixtofilenames(fanat_end,'brain_');
do_fsl_mult(concat_cell(fm_end,fanat_end),fo_end);
examArray.getSeries('anat_end').addVolumes('^brain_','brain',1)



%% Preprocess fMRI runs

%realign and reslice
par.file_reg = '^f.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice = job_realign(dfonc,par)
examArray.getSeries(regex_dfonc).addVolumes('^rf','rf',1)

%realign and reslice opposite phase
par.file_reg = '^f.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice_op = job_realign(dfonc_op,par)
examArray.getSeries(regex_dfonc_op).addVolumes('^rf','rf',1)

%topup and unwarp
par.file_reg = {'^rf.*nii'}; par.sge=0;
do_topup_unwarp_4D(dfoncall,par)
examArray.getSeries('run').addVolumes('^utmeanf','utmeanf',1)
examArray.getSeries('run').addVolumes('^utrf.*nii','utrf',1)

%coregister mean fonc on brain_anat
% fanat = get_subdir_regex_files(anat,'^s.*nii$',1) % raw anat
% fanat = get_subdir_regex_files(anat,'^ms.*nii$',1) % raw anat + signal bias correction
% fanat = get_subdir_regex_files(anat,'^brain_s.*nii$',1) % brain mask applied (not perfect, there are holes in the mask)
fanat = examArray.getSeries('anat_start').getVolumes('^brain').toJobs

par.type = 'estimate';
for nbs=1:length(suj)
    fmean(nbs) = examArray.getSeries('run_DualTask_001').getVolumes('^utmeanf').toJobs
end

fo = examArray.getSeries(regex_dfonc).getVolumes('^utrf').toJobs
j_coregister=job_coregister(fmean,fanat,fo,par)

%apply normalize
fy_start = examArray.getSeries('anat_start').getVolumes('^y').toJobs
j_apply_normalize=job_apply_normalize(fy_start,fo,par)

%smooth the data
ffonc = examArray.getSeries(regex_dfonc).addVolumes('^wutrf','wutrf',1)
par.smooth = [8 8 8];
j_smooth=job_smooth(ffonc,par)
examArray.getSeries(regex_dfonc).addVolumes('^swutrf','swutrf',1)

save('exarr','examArray')
