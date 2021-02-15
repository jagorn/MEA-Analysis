function tags = readTags(templatesFile)

if ~isfile(templatesFile)
    error_struct.message = strcat("The templates file ", templatesFile, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

fprintf('Extracting Tags...\n');
tags = h5read(templatesFile, '/tagged');
fprintf('Extraction Completed\n\n');
