function [cells, roi, rfs] = simulateMosaic(varargin)

% Parameters
roi_size_def = 500;  % microns
soma_radius_def = 15;  % microns
soma_radius_std_def = 0.5;  % microns^2
soma_density_def = 5e-4; % microns^-2
sampling_ratio_def = 0.4;
receptive_fields_def = true;
n_cells = [];

% Parse Input
p = inputParser;
addParameter(p, 'Roi_Size', roi_size_def);
addParameter(p, 'Soma_Radius', soma_radius_def);
addParameter(p, 'Soma_Radius_std', soma_radius_std_def);
addParameter(p, 'Soma_Density', soma_density_def);
addParameter(p, 'Sampling_Ratio', sampling_ratio_def);
addParameter(p, 'Receptive_Fields', receptive_fields_def);
addParameter(p, 'N_Cells', soma_density_def);

parse(p, varargin{:});

roi_radius = p.Results.Roi_Size;
soma_radius = p.Results.Soma_Radius;
soma_radius_std = p.Results.Soma_Radius_std;
soma_density = p.Results.Soma_Density; 
sampling_ratio = p.Results.Sampling_Ratio; 
receptive_fields = p.Results.Receptive_Fields;
n_cells = p.Results.N_Cells;

% Compute Variables
roi = [roi_radius, roi_radius];
roi_area = roi_radius^2;

if isempty(n_cells)
    n_cells = round(soma_density * roi_area);   
end

% Generate Cells
cells = zeros(n_cells, 3);
for i_cell = 1:n_cells
    
    % Repeat Cell Generation until the overlapping requirements are met
    is_overlapping = true;
    overlapping_counter = 0;
    while is_overlapping
        soma_position = rand(1, 2) * roi_radius;
        soma_size = normrnd(soma_radius, soma_radius_std);
        
        is_overlapping = false;
        for other_cell_i = 1:(i_cell-1)
            other_cell = cells(other_cell_i, :);
            
            if norm(other_cell(1:2) - soma_position) < (other_cell(3) + soma_size)
                is_overlapping = true;
                overlapping_counter = overlapping_counter + 1;
                
                if overlapping_counter > 10000
                    error("density too high");
                end
                break;
            end
        end
    end
    
    cells(i_cell, 1:2) = soma_position;
    cells(i_cell, 3) = soma_size;
end

if sampling_ratio < 1
    sampled_cells = rand(1, n_cells) < sampling_ratio;
    cells(~sampled_cells, :) = [];
end

if receptive_fields
    rfs = generateRdmRFs(cells, roi);
else
    rfs = [];
end
