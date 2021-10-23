function plotElectrodesMEA(varargin)

mea_spacing_micron_def = 30;
n_electrode_size_def = 16;

% Parse Input
p = inputParser;

addParameter(p, 'MEA_Spacing_Microns', mea_spacing_micron_def);
addParameter(p, 'N_Electrodes_Size', n_electrode_size_def);

parse(p, varargin{:});

mea_spacing_micron = p.Results.MEA_Spacing_Microns;
n_electrode_size = p.Results.N_Electrodes_Size;


count = 1;
xs = zeros(1, n_electrode_size * n_electrode_size);
ys = zeros(1, n_electrode_size * n_electrode_size);

for x = 1:n_electrode_size
    for y = 1:n_electrode_size
        xs(count) = x*mea_spacing_micron;
        ys(count) = y*mea_spacing_micron;
        count = count + 1;
    end
end

scatter(xs, ys, 'r+');

