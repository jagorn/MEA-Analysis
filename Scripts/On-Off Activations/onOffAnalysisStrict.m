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

try
    z_on_control = pattern_activations.(control_label).on.z;
    z_off_control = pattern_activations.(control_label).off.z;
catch
    fprintf('%s does not have a pattern labeled %s. As a control, %s will be used instead.\n', pattern_label, control_label, control_pattern);
    z_on_control = activations.(control_pattern).(control_label).on.z;
    z_off_control = activations.(control_pattern).(control_label).off.z;
end


% Assess cell polarities
try
    ONCells = [cellsTable.Polarity] == 'ON';
    OFFCells = [cellsTable.Polarity] == 'OFF';
catch
    disp('polarity was not found in the cells table. the first condition will be used to compute polarities');
    ONCells = z_on_control & ~z_off_control;
    OFFCells = z_off_control & ~z_on_control;
end

TotalON = sum(ONCells);
TotalOFF = sum(OFFCells);


% Remove inconsistent cells and ON-OFF cells
bothOnsetOffset_idx     = any(zs_on & zs_off, 1) | (z_on_control & z_off_control);     % cells that respond to both onset and offset
inconsistentOFF_idx     = ~z_off_control & OFFCells;                                % cells with OFF STA that respond like ON
inconsistentON_idx      = ~z_on_control & ONCells;                                  % cells with ON STA that respond like OFF

bad_cells = inconsistentOFF_idx | inconsistentON_idx;
disp([num2str(sum(bad_cells)) ' bad cells were removed'])


% Sum up all the activations to compute statistics
onsetOn =   sum(repmat(ONCells  & ~bad_cells, n_conditions, 1) & zs_on, 2);
offsetOn =  sum(repmat(ONCells  & ~bad_cells, n_conditions, 1) & zs_off, 2);
onsetOff =  sum(repmat(OFFCells & ~bad_cells, n_conditions, 1) & zs_on, 2);
offsetOff = sum(repmat(OFFCells & ~bad_cells, n_conditions, 1) & zs_off, 2);
silentOn =  sum(repmat(ONCells  & ~bad_cells, n_conditions, 1) & ~zs_off & ~zs_on, 2);
silentOff = sum(repmat(OFFCells & ~bad_cells, n_conditions, 1) & ~zs_off & ~zs_on, 2);

TotalON = sum(ONCells   & ~bad_cells);
TotalOFF = sum(OFFCells & ~bad_cells);

PercentageOnsetON =     onsetOn / TotalON;
PercentageOnsetOFF =    onsetOff / TotalOFF;
PercentageOffsetON =    offsetOn / TotalON;
PercentageOffsetOFF =   offsetOff / TotalOFF;
PercentageSilentON =    silentOn / TotalON;
PercentageSilentOFF =   silentOff / TotalOFF;

GraphOnCells =  [onsetOn, offsetOn, silentOn];
GraphOffCells = [onsetOff, offsetOff, silentOff];
