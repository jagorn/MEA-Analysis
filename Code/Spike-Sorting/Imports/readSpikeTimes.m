function spikes = readSpikeTimes(results_file)

if ~isfile(results_file)
    error_struct.message = strcat("The results file ", results_file, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

fprintf('Extracting Traces...\n');
spikes = {};

there_is_trace = true;
i_trace = 1;
while there_is_trace
    try
        trace = h5read(char(results_file), ['/spiketimes/temp_' int2str(i_trace - 1)]);
        spikes{i_trace}  = double(trace(:));
        fprintf('\ttrace %d\n', i_trace);
        i_trace = i_trace + 1;
    catch
        there_is_trace = false;
    end
end
fprintf('Extraction Completed\n\n');
