clear
close all
clc

% parameters
exclude_leaked_cells = true;

% compare variance explained in euler PCAs
dataset_id = "20210301_reachr2_noSTAs";
% dataset_id = "20210302_reachr2_noSTAs";
% dataset_id = "20201125_reachr2_noSTAs";

condition_pharma = "lap4_acet_30nd100p";
% condition_pharma = "lap4_acet_30nd100p";
% condition_pharma = "lap4_acet_nd30p100";

condition_control = "lap4_acet_cnqxcpp_30nd100p";
% condition_control = "lap4_acet_cnqxcpp_30nd100p";
% condition_control = "lap4_acet_cnqxcpp_nd20p50";


changeDataset(dataset_id);
loadDataset();
n_cells = numel(cellsTable);

% Cells polarity
z_on_simple = activations.flicker.simple.on.z;
z_off_simple = activations.flicker.simple.off.z;

z_on_pharma  = activations.flicker.(condition_pharma).on.z;
z_off_pharma  = activations.flicker.(condition_pharma).off.z;

z_on_control  = activations.flicker.(condition_control).on.z;
z_off_control  = activations.flicker.(condition_control).off.z;

ONCells = z_on_simple & ~z_off_simple;
OFFCells = z_off_simple & ~z_on_simple;

ONCells_pharma = z_on_pharma & ~z_off_pharma;
OFFCells_pharma = z_off_pharma & ~z_on_pharma;

% Choose good cells
good_cells = (ONCells | OFFCells) & (ONCells_pharma | OFFCells_pharma);

% choose wether to eliminate leaked cells or not
LeakCells = z_on_control | z_off_control;
if exclude_leaked_cells
    good_cells = good_cells & ~LeakCells;
end
n_good_cells = sum(good_cells)

% Load ST-scores
computeSTScores('flicker', 'simple', 'simpleOn', [0.5, 0.8], [0, 0.3]);
computeSTScores('flicker', 'simple', 'simpleOff', [1.5, 1.8], [1.0, 1.3]);

computeSTScores('flicker', condition_pharma, 'pharmaOn', [0.5, 0.8], [0, 0.3]);
computeSTScores('flicker', condition_pharma, 'pharmaOff', [1.5, 1.8], [1.0, 1.3]);

load(getDatasetMat, 'st_scores');

st_scores_simple = nan(n_cells, 1);
st_scores_pharma = nan(n_cells, 1);
labels = cell(n_cells, 1);

% sort out the scores of the good cells
for i_cell = 1:n_cells
    if good_cells(i_cell)
        
        % add the st-scores for the simple condition
        if ONCells(i_cell)
            st_scores_simple(i_cell) = st_scores.simpleOn.scores(i_cell);
            labels{i_cell} = 'ON';
            
        elseif OFFCells(i_cell)
            st_scores_simple(i_cell) = st_scores.simpleOff.scores(i_cell);
            labels{i_cell} = 'OFF';
            
        else
            error('this cell is neither ON nor OFF')
        end
        
        % add the st-scores for the pharmacology condition
        if ONCells_pharma(i_cell)
            st_scores_pharma(i_cell) = st_scores.pharmaOn.scores(i_cell);
            
        elseif OFFCells_pharma(i_cell)
            st_scores_pharma(i_cell) = st_scores.pharmaOff.scores(i_cell);
            
        else
            error('this cell is neither ON nor OFF')
        end
    end
end

% extract only the good cells
st_scores_good_simple = st_scores_simple(good_cells);
st_scores_good_pharma = st_scores_pharma(good_cells);
labels_good = labels(good_cells);

if any(isnan(st_scores_good_simple)) || any(isnan(st_scores_good_pharma))
    error('something went wrong with the st-scores computation');
end

% plot
figure()

subplot(1, 2, 2)
hold on
% daspect([1 1 1])
xlim([0 5])
ylim([0 5])
plot([0, 5], [0, 5], 'k--', 'LineWidth', 1.5)

gscatter(st_scores_good_simple, st_scores_good_pharma, labels_good)
xlabel('Normal Responses')
ylabel('Optogenetic Responses')
title('Sustained-Transient Response Ratio')

subplot(1, 2, 1)
hold on
histogram(st_scores_good_simple, 0:0.25:5, 'EdgeColor', 'None', 'FaceColor', 'r', 'FaceAlpha', 0.5)
histogram(st_scores_good_pharma, 0:0.25:5, 'EdgeColor', 'None', 'FaceColor', 'g', 'FaceAlpha', 0.5)
legend({'Simple Response', 'Optogenetic Response'})
xlabel('Sustained-Transient Ratio')
ylabel('Number of Cells')
title('Sustained-Transient Response Ratio')
