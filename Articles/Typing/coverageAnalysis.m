clear
close all
load('typing_results.mat', 'mosaicsTable', 'duplicate_cells', 'psths', 'names', 'colors', 'symbols', 'rfs', 'stas');

mea_area = 510 * 510;  % microns
density_retina = 1000;

function expected_size = expectedClusterSize(nnd)
    triangle_area = (nnd/2)^2 * sqrt(3) / 4;
    exagon_area = 6 * triangle_area;
    expected_size = exagon_area / mea_area;
end

function prob_type = samplingProbType(size_type, nnd_type)
    expected_size = expectedClusterSize(nnd_type);
    prob_type = size_type / expected_size;
end

function prob_recording = samplingProbExperiment(n_cells_recorded)
    prob_recording = n_cells_recorded / density_retina * mea_area;
end

function bias = computeBiasType(size_type, nnd_type, n_cells_experiment)
    prob_type = samplingProbType(size_type, nnd_type);
    prob_recording = samplingProbExperiment(n_cells_experiment);
    bias = log(prob_type) - log(prob_recording);
end

