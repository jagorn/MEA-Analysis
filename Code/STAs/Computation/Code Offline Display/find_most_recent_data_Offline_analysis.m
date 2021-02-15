function [channels_list,isChanges] =  find_most_recent_data_Offline_analysis(channels_list_init,experiment_folder,savename)
%LOAD_MOST_RECENT_DATA Summary of this function goes here
%   Detailed explanation goes here
%/////Send an explanation if no data found?

channels_list = channels_list_init;

filesnames=dir(experiment_folder);
lsave = length(savename)+4;

isChanges = 0;

for ii = 1:length(filesnames)
    
    if ~isempty(strfind(filesnames(ii).name,savename)==1)
        
        nchan = str2num(filesnames(ii).name(lsave+1:end-4));
        
        if ~ismember(nchan,channels_list)
            channels_list = [channels_list, nchan];
        end
    end
    
end

if any(~ismember(channels_list,channels_list_init))
    isChanges = 1;
end

end

