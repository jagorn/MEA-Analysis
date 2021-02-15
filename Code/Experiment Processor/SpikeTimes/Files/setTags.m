function setTags(exp_id, tags)
tags_file = fullfile(processedPath(exp_id), 'Tags.mat');
save(tags_file, 'tags');
