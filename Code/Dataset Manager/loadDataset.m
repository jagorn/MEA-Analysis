try
    load(getDatasetMat());
catch
    error_struct.message = strcat("Dataset ", dataset_file, " could not be loaded.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end