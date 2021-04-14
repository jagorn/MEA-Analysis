function binary_file = getBinaryFile(stimulus, version)

path =  stimPath(stimulus);
if ~isfolder(path)
    error_struct.message = strcat("stimulus ", stimulus," has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

binary_file = fullfile(path, 'bin_files', strcat(version, '.bin'));
if ~isfile(binary_file)
    error_struct.message = strcat("the stimulus ", stimulus, "(version: ", version, ") has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end