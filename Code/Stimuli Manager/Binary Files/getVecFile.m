function binary_file = getVecFile(stimulus, version)

path =  stimPath(stimulus);
if ~isfolder(path)
    error_struct.message = strcat("stimulus ", stimulus," has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

binary_file = fullfile(path, 'vec_files', strcat(version, '.vec'));
if ~isfile(binary_file)
    error_struct.message = strcat("the stimulus ", stimulus, "(version: ", version, ") has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end