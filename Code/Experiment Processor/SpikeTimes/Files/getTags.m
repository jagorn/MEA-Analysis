function tags = getTags(exp_id)
tags_file = fullfile(processedPath(exp_id), 'Tags.mat');
if ~isfile(tags_file)
    error_struct.message = strcat("cell tags were not extracted yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end

load(tags_file, 'tags');

if ~exist('tags', 'var')
    error_struct.message = strcat("cell tags were not extracted yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    

