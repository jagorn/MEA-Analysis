function [LastTime,isChanges, lastsavefile] = find_most_recent_data(LastTime,experiment_folder,savename)
%LOAD_MOST_RECENT_DATA Summary of this function goes here
%   Detailed explanation goes here
%/////Send an explanation if no data found?

filesnames=dir(experiment_folder);

FileTime = zeros(1,6);

isChanges = 0;

for ii = 1:length(filesnames)
    
    if ~isempty(strfind(filesnames(ii).name,savename)==1)
        lengthFinal = ~isempty(strfind(filesnames(ii).name,'final-'))*6; %6 if we test a 'final-' file, 0 else
        lsave = length(savename);
        indices = strfind(filesnames(ii).name(lengthFinal+lsave+1:end),'-');
        if indices(1) == 1  %check the name of the experiment is not just a substring of the name of this file //////All possible case for substring problems checked???
            dotindex = strfind(filesnames(ii).name,'.');
            for k = 1:3
                FileTime(k) = str2double(filesnames(ii).name(lengthFinal+lsave+indices(k+1)+1:lengthFinal+lsave+indices(k+2)-1));
            end
            for k = 4:5
                FileTime(k) = str2double(filesnames(ii).name(lengthFinal+lsave+indices(k+2)+1:lengthFinal+lsave+indices(k+3)-1));
            end
            FileTime(6) = str2double(filesnames(ii).name(lengthFinal+lsave+indices(end)+1:dotindex-1));
            
            comp = FileTime - LastTime;
            
            pos = find(comp > 0,1);
            neg = find(comp < 0,1);
            
            if ~isempty(pos)
                if isempty(neg) || pos<neg
                    LastTime = FileTime;
                    isChanges = 1;
                    lastsavefile = [experiment_folder '/' filesnames(ii).name];
                end
            end
            
            %fprintf('%d - ',LastTime)
            %fprintf('\n')
        end
    end
    
end

if isChanges == 0
    lastsavefile = ' ';
end

end

