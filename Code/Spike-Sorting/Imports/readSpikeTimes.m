function spikes = readSpikeTimes(results_file, multi_unit)

if ~exist('multi_unit', 'var')
    multi_unit = false;
end

if ~isfile(results_file)
    error_struct.message = strcat("The results file ", results_file, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if multi_unit
    prefix_channels = 'elec_';
else
    prefix_channels = 'temp_';
end

fprintf('Extracting Traces...\n');
spikes = {};

there_is_trace = true;
i_trace = 1;
while there_is_trace
    try
        trace = h5read(char(results_file), ['/spiketimes/' prefix_channels int2str(i_trace - 1)]);
        spikes{i_trace}  = double(trace(:));
        fprintf('\ttrace %d\n', i_trace);
        i_trace = i_trace + 1;
    catch
        there_is_trace = false;
    end
end
fprintf('Extraction Completed\n\n');
