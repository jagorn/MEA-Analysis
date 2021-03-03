function path = getH_ImagesPath()
script_path = mfilename('fullpath');
script_path_parts = string(strsplit(script_path, filesep));
project_path_parts = script_path_parts(1:end-1);
path = join(project_path_parts, filesep);
