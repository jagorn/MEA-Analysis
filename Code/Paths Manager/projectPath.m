function path = projectPath()
global mea_analysis_project_path
if isempty(mea_analysis_project_path)
    script_path = mfilename('fullpath');
    script_path_parts = string(strsplit(script_path, filesep));
    project_path_parts = script_path_parts(1:end-3);
    path = join(project_path_parts, filesep);
else
    path = mea_analysis_project_path;
end

