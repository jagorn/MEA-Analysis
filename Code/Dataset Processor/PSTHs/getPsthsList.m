function psths_list = getPsthsList()

load(getDatasetMat(), 'psths')
if ~exist('psths', 'var')
    error_struct.message = strcat("There are no psths yet in this dataset.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end  
psths_list = fields(psths);