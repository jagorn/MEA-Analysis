function folders = experimentList()

all_files = dir(dataPath);
exp_idx = [dir(dataPath).isdir];
exp_idx(1:2) = false;
folders = {all_files(exp_idx).name};