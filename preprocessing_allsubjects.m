clear
clc

%% Prepare paths and regexp

main_path =fullfile('/mnt/data/benoit/protocol/MEMODREAM/fmri','img');


par.display = 0;
par.run     = 1;


%% Get files paths

examArray = exam(main_path,'Pilote03');

% T1
examArray.addSerie('t1_mpr_sag_0_8iso$'    ,'anat',1)
% examArray.addSerie('t1_mpr_sag_0_8iso$'    ,'anat_start',1)
% examArray.addSerie('t1_mpr_sag_0_8iso_end$','anat_end'  ,1)
examArray.addVolume('anat','^s.*nii','s',1)

% Run : DualTask
examArray.addSerie('DualTask.*_\d$'      , 'run_DualTask'      )
% examArray.addSerie('DualTask.*_\d_refAP$', 'run_DualTask_refAP') % refAP

% Run : SpeedTest
examArray.addSerie('SpeedTest.*_\d$'      , 'run_SpeedTest'      )
% examArray.addSerie('SpeedTest.*_\d_refAP$', 'run_SpeedTest_refAP') % refAP

% Run : Sleep
examArray.addSerie('Sleep.*_\d$'      , 'run_Sleep'      )
% examArray.addSerie('Sleep.*_\d_refAP$', 'run_Sleep_refAP') % refAP

% Run : Training
examArray.addSerie('Training_(Start|end)$', 'run_Training'      )
% examArray.addSerie('Training.*_refAP$'    , 'run_Training_refAP') % refAP

% Run : Execution
examArray.addSerie('Execution.*_\d$'      , 'run_Execution'      )
% examArray.addSerie('Execution.*_\d_refAP$', 'run_Execution_refAP') % refAP

% % Run : Imagination
examArray.addSerie('Imagination.*_\d$'      , 'run_Imagination'      )
% examArray.addSerie('Imagination.*_\d_refAP$', 'run_Imagination_refAP') % refAP

% loca
% examArray.addSeries('localizer', 'localizer')

% All func volumes
examArray.getSerie('run').addVolume('^f.*nii','f',1)

% Unzip if necessary
examArray.unzipVolume;

examArray.reorderSeries('name'); % mostly useful for topup, that requires pairs of (AP,PA)/(PA,AP) scans

examArray.explore


%% Segment anat

%anat segment
fanat = examArray.getSerie('anat').getVolume('^s');

par.GM   = [1 1 1 1]; % warped_space_Unmodulated(wc*) / warped_space_modulated(mwc*) / native_space(c*) / native_space_dartel_import(rc*)
par.WM   = [1 1 1 1];
par.CSF  = [1 1 1 1];
par.bias = [1 1]; % bias field / bias corrected image
par.warp = [1 1]; % warp field native->template / warp field native<-template
job_do_segment(fanat.removeEmpty,par);


%apply normalize on anat
fy    = examArray.getSerie('anat').getVolume('^y');
fanat = examArray.getSerie('anat').getVolume('^ms');
job_apply_normalize(fy,fanat,par);


%% Preprocess fMRI runs

% SliceTiming
ffonc_raw = examArray.getSerie('run').getVolume('f');
job_slice_timing(ffonc_raw,par)

%realign and reslice
par.file_reg = '^f.*nii'; par.type = 'estimate_and_reslice';
ffonc_stc = examArray.getSerie('run').getVolume('af');
job_realign(ffonc_stc,par)

%coregister mean fonc on anat
par.type = 'estimate';
sfonc = examArray.getSerie('run'); 
fmean =  sfonc(1).getVolume('^mean');
fother = sfonc.getVolume('raf');
job_coregister(fmean,fanat,fother,par);

%apply normalize
job_apply_normalize(fy,fother,par);

%smooth the data
par.smooth = [8 8 8];
ffonc_warped = sfonc.getVolume('wraf');
job_smooth(ffonc_warped,par)

save('exarr_orig','examArray') % always keep the original
save('exarr_stim','examArray') % work on this one
