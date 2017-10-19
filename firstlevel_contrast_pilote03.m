clear
clc

stim_path = [ pwd filesep 'stim'];

%% Fetch stim files

% stimArray = exam(stim_path,'Pilote03');
% 
% stimArray.addVolumes

stim_dirs  = get_subdir_regex(stim_path,'Pilote03');
stim_files = get_subdir_regex_files(stim_dirs,...
    '(DualTask_Simple|DualTask_Complex|SpeedTest|Training)_MRI_.*_SPM.mat$');
files = char(stim_files);

for f = 1 : size(files,1)
    
    filename = deblank(files(f,:));
    
   l = load(filename);

   [~,name,~] = fileparts(filename)
   l.names
   
end
