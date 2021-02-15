function SpikeTimes_MultiUnit = extractMultiUnitResponses(exp_id, thresholding_file)

try    
    SpikeTimes_MultiUnit = getMua(exp_id);
    disp("Multi-unit spike times were already extracted. They will be loaded instead.")
catch
    SpikeTimes_MultiUnit = readSpikeTimes(thresholding_file);
    setMua(exp_id, SpikeTimes_MultiUnit)
    disp("Multi-unit spike times extracted")
end