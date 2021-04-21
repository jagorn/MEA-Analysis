function plotOnOffAnalysis(dataset, pattern_label, output_folder)

control_label = 'simple';

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

bad_cells = bothOnsetOffset_idx | inconsistentOFF_idx | inconsistentON_idx;
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

GraphOnCells =  [PercentageOnsetON, PercentageOffsetON, PercentageSilentON] * 100;
GraphOffCells = [PercentageOnsetOFF, PercentageOffsetOFF, PercentageSilentOFF] * 100;

% Legends
cond_idx = 1:numel(condition_labels);
legend_onset =  'Activated at Onset';
legend_offset = 'Activated at Offset';
legend_silent = 'Never Activated';
x_labels = condition_labels(cond_idx);
x_labels = regexprep(x_labels, '_', '');
x_labels = regexprep(x_labels, 'lap4', 'L');
x_labels = regexprep(x_labels, 'acet', 'A');
x_labels = regexprep(x_labels, 'cnqxcpp', 'C');

% Plot the histograms
figure;
fullScreen();

% First ON cells...
subplot(2, 1, 1);

b = bar(GraphOnCells(cond_idx, :));
b(1).FaceColor = [.99 .5 .5];
b(2).FaceColor = [.8 .2 .2];
b(3).FaceColor = [.3 .3 .3];

legend(legend_onset, legend_offset, legend_silent)
ylabel('Percentage (%) ')
xlabel('Light Levels')
ylim([0 100])

set(gca,'FontSize', 10)
set(gca,'box','off')
set(gca,'XTickLabel', x_labels)
title(['ON Cells (' num2str(TotalON) ')'])


% ...then OFF cells
subplot(2, 1, 2);

b = bar(GraphOffCells(cond_idx, :));
b(1).FaceColor = [.5 .5 .99];
b(2).FaceColor = [.2 .2 .8];
b(3).FaceColor = [.3 .3 .3];

legend(legend_onset, legend_offset, legend_silent)
ylabel('Percentage (%) ')
xlabel('Light Levels')
ylim([0 100])

set(gca,'FontSize', 10)
set(gca,'box','off')
set(gca,'XTickLabel', x_labels)
title( ['OFF Cells (' num2str(TotalOFF) ')'])

% Figure Title
suptitle(regexprep(dataset, '_', '-'))


file_name = strcat(getDatasetId, "_", pattern_label, "_Statistics");
filepath = fullfile(output_folder, file_name);
export_fig(filepath, '-svg');
close;
