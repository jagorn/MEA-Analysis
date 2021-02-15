function setMua(exp_id, mua)
mua_file = fullfile(processedPath(exp_id), 'SpikeTimes_MultiUnit.mat');
save(mua_file, 'mua');

