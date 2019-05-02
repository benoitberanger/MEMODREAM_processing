clear
clc

%% Prepare paths and regexp

main_path =fullfile('/mnt/data/benoit/protocol/MEMODREAM/fmri','img');


par.display = 0;
par.run     = 1;


%% Get files paths

e = exam(main_path,'Pilote03');

% T1
e.addSerie('t1_mpr_sag_0_8iso$'    ,'anat',1)
% e.addSerie('t1_mpr_sag_0_8iso$'    ,'anat_start',1)
% e.addSerie('t1_mpr_sag_0_8iso_end$','anat_end'  ,1)
e.addVolume('anat','^s.*nii','s',1)

% Run : DualTask
e.addSerie('DualTask.*_\d$'      , 'run_DualTask'      )
% e.addSerie('DualTask.*_\d_refAP$', 'run_DualTask_refAP') % refAP

% Run : SpeedTest
e.addSerie('SpeedTest.*_\d$'      , 'run_SpeedTest'      )
% e.addSerie('SpeedTest.*_\d_refAP$', 'run_SpeedTest_refAP') % refAP

% Run : Sleep
e.addSerie('Sleep.*_\d$'      , 'run_Sleep'      )
% e.addSerie('Sleep.*_\d_refAP$', 'run_Sleep_refAP') % refAP

% Run : Training
e.addSerie('Training_(Start|end)$', 'run_Training'      )
% e.addSerie('Training.*_refAP$'    , 'run_Training_refAP') % refAP

% Run : Execution
e.addSerie('Execution.*_\d$'      , 'run_Execution'      )
% e.addSerie('Execution.*_\d_refAP$', 'run_Execution_refAP') % refAP

% % Run : Imagination
e.addSerie('Imagination.*_\d$'      , 'run_Imagination'      )
% e.addSerie('Imagination.*_\d_refAP$', 'run_Imagination_refAP') % refAP

% loca
% e.addSeries('localizer', 'localizer')

% All func volumes
e.getSerie('run').addVolume('^f.*nii','f',1)

% Unzip if necessary
e.unzipVolume;

e.reorderSeries('name'); % mostly useful for topup, that requires pairs of (AP,PA)/(PA,AP) scans

e.explore


%% Segment anat

%anat segment
fanat = e.getSerie('anat').getVolume('^s');

par.GM   = [1 1 1 1]; % warped_space_Unmodulated(wc*) / warped_space_modulated(mwc*) / native_space(c*) / native_space_dartel_import(rc*)
par.WM   = [1 1 1 1];
par.CSF  = [1 1 1 1];
par.bias = [1 1]; % bias field / bias corrected image
par.warp = [1 1]; % warp field native->template / warp field native<-template
job_do_segment(fanat.removeEmpty,par);


%apply normalize on anat
fy    = e.getSerie('anat').getVolume('^y');
fanat = e.getSerie('anat').getVolume('^ms');
job_apply_normalize(fy,fanat,par);


%% Preprocess fMRI runs

% SliceTiming
ffonc_raw = e.getSerie('run').getVolume('f');
job_slice_timing(ffonc_raw,par)

%realign and reslice
par.type = 'estimate_and_reslice';
ffonc_stc = e.getSerie('run').getVolume('af');
job_realign(ffonc_stc,par)

%coregister mean fonc on anat
par.type = 'estimate';
sfonc = e.getSerie('run'); 
fmean =  sfonc(1).getVolume('^mean');
fother = sfonc.getVolume('raf');
job_coregister(fmean,fanat,fother,par);

%apply normalize
job_apply_normalize(fy,fother,par);
job_apply_normalize(fy,fmean,par);

par.type = 'write';
wfmean = e.getSerie('run').getVolume('^wmean');
wc23 = e.getSerie('anat').getVolume('^wc[23]');
job_coregister(wc23,wfmean,[],par);

%smooth the data
par.smooth = [8 8 8];
ffonc_warped = sfonc.getVolume('wraf');
job_smooth(ffonc_warped,par)

save('e_orig','e') % always keep the original
save('e_stim','e') % work on this one
