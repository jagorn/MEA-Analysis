function spikes = readSpikeTimesSecondsDAT(dat_folder, dat_prefix, channels)

if ~isfolder(dat_folder)
    error_struct.message = strcat("The .dat file ", results_file, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

fprintf('Extracting Traces...\n');
spikes = {};

for i = 1:numel(channels)
    i_channel = channels(i);
    if i_channel<10
        dat_file = strcat(dat_prefix, '_0', int2str(i_channel), '.dat');
    else
        dat_file = strcat(dat_prefix, '_', int2str(i_channel), '.dat');
    end
    dat_path = fullfile(dat_folder, dat_file);
    trace = importdata(dat_path);
    if isfield(trace,'data')
        spikes{i} = round(trace.data);
    end
end
fprintf('Extraction Completed\n\n');