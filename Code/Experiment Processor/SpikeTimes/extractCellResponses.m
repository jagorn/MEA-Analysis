function SpikeTimes = extractCellResponses(exp_id, results_file)
% Extracts the spike times of a given experiment from the spike-sorting
% results.

try
    SpikeTimes = getSpikeTimes(exp_id);
    disp("Spike times were already extracted. They will be loaded instead.")
catch
    SpikeTimes = readSpikeTimes(results_file);
    setSpikeTimes(exp_id, SpikeTimes);
    disp("Spike times extracted")
end