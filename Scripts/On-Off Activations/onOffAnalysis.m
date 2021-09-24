function [GraphOnCells, GraphOffCells, TotalON, TotalOFF, condition_labels] = onOffAnalysis(dataset, pattern_label, control_label, control_pattern)

if ~exist('control_label', 'var')
    control_label = 'simple';
end
if ~exist('control_pattern', 'var')
    control_pattern = 'flicker';
end

changeDataset(dataset);
load(getDatasetMat(), 'cellsTable', 'activations');

pattern_activations = activations.(pattern_label);
condition_labels = fields(pattern_activations);

% remove the control condition from the list of conditions
if numel(condition_labels) > 2
    condition_labels(strcmp(condition_labels, control_label)) = [];
end

n_conditions = numel(condition_labels);
n_cells = numel(cellsTable);

% Build the Z matrices
zs_on = false(n_conditions, n_cells);
zs_off = false(n_conditions, n_cells);
for i_cond = 1:n_conditions
    condition_label = condition_labels{i_cond};
    zs_on(i_cond, :) = pattern_activations.(condition_label).on.z;
    zs_off(i_cond, :) = pattern_activations.(condition_label).off.z;
end

z_on_control = pattern_activations.(control_label).on.z;
z_off_control = pattern_activations.(control_label).off.z;

% Assess cell polarities
ONCells = z_on_control & ~z_off_control;
OFFCells = z_off_control & ~z_on_control;

TotalON = sum(ONCells);
TotalOFF = sum(OFFCells);

% Sum up all the activations to compute statistics
onsetOn =   sum(repmat(ONCells, n_conditions, 1) & zs_on, 2);
offsetOn =  sum(repmat(ONCells, n_conditions, 1) & zs_off, 2);
onsetOff =  sum(repmat(OFFCells, n_conditions, 1) & zs_on, 2);
offsetOff = sum(repmat(OFFCells, n_conditions, 1) & zs_off, 2);
silentOn =  sum(repmat(ONCells, n_conditions, 1) & ~zs_off & ~zs_on, 2);
silentOff = sum(repmat(OFFCells, n_conditions, 1) & ~zs_off & ~zs_on, 2);

GraphOnCells =  [onsetOn, offsetOn, silentOn];
GraphOffCells = [onsetOff, offsetOff, silentOff];
