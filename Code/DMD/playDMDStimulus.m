function playDMDStimulus(stimulus, version, is_polarity_inverted, freq)

bin_file = getBinaryFile(stimulus, version);
vec_file = getVecFile(stimulus, version);
DMDSimulator(bin_file, vec_file, is_polarity_inverted, freq)
