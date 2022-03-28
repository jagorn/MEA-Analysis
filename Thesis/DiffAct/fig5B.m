clear
close all
clc

% parameters
exclude_leaked_cells = true;

% compare variance explained in euler PCAs
dataset_idx = ["20210301_reachr2_noSTAs"; "20210302_reachr2_noSTAs"; "20201125_reachr2_noSTAs"];
conditions_pharma = ["lap4_acet_30nd100p"; "lap4_acet_30nd100p"; "lap4_acet_30nd100p"];
conditions_control = ["lap4_acet_cnqxcpp_30nd100p"; "lap4_acet_cnqxcpp_30nd100p"; "lap4_acet_cnqxcpp_20nd50p"];

st_scores_good_simple = [];
st_scores_good_pharma = [];
labels_good = [];

scores_only_on = [];
scores_only_off = [];

scores_only_on_pharma = [];
scores_only_off_pharma = [];

for i_exp = 1:numel(dataset_idx)
    
    dataset_id = dataset_idx(i_exp);
    condition_pharma = conditions_pharma(i_exp);
    condition_control = conditions_control(i_exp);
    
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
    good_cells = (ONCells & ONCells_pharma) | (OFFCells & OFFCells_pharma);
    
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
                
                scores_only_on = [scores_only_on st_scores_simple(i_cell)];
                
            elseif OFFCells(i_cell)
                st_scores_simple(i_cell) = st_scores.simpleOff.scores(i_cell);
                labels{i_cell} = 'OFF';
                
                scores_only_off = [scores_only_off st_scores_simple(i_cell)];
                
            else
                error('this cell is neither ON nor OFF')
            end
            
            % add the st-scores for the pharmacology condition
            if ONCells_pharma(i_cell)
                st_scores_pharma(i_cell) = st_scores.pharmaOn.scores(i_cell);
                scores_only_on_pharma = [scores_only_on_pharma st_scores_pharma(i_cell)];

            elseif OFFCells_pharma(i_cell)
                st_scores_pharma(i_cell) = st_scores.pharmaOff.scores(i_cell);
                scores_only_off_pharma = [scores_only_off_pharma st_scores_pharma(i_cell)];
            else
                i_cell
                error('this cell is neither ON nor OFF')
            end
            
            if (OFFCells_pharma(i_cell) &&  ONCells(i_cell)) || (ONCells_pharma(i_cell) &&  OFFCells(i_cell))
                i_cell
                error('this cell changed polarity')
            end
            
        end
    end
    
    % extract only the good cells
    st_scores_good_simple = [st_scores_good_simple; st_scores_simple(good_cells)];
    st_scores_good_pharma = [st_scores_good_pharma; st_scores_pharma(good_cells)];
    labels_good = [labels_good; labels(good_cells)] ;
    
    if any(isnan(st_scores_good_simple)) || any(isnan(st_scores_good_pharma))
        error('something went wrong with the st-scores computation');
    end
    
end

% plot
figure()
subplot(1, 3, 1)
hold on
histogram(scores_only_on, 0:0.1:1, 'EdgeColor', 'None', 'FaceColor', 'r', 'FaceAlpha', 0.5)
histogram(scores_only_on_pharma, 0:0.1:1, 'EdgeColor', 'None', 'FaceColor', 'g', 'FaceAlpha', 0.5)
legend({'Photoreceptor Responses', 'Optogenetic Responses'})
xlabel('Sustained-Transient Index')
ylabel('Number of Cells')
title('ST Index Distribution (ON cells)')
ylim([0 15])


subplot(1, 3, 2)
hold on
histogram(scores_only_off,  0:0.1:1, 'EdgeColor', 'None', 'FaceColor', 'r', 'FaceAlpha', 0.5)
histogram(scores_only_off_pharma,  0:0.1:1, 'EdgeColor', 'None', 'FaceColor', 'g', 'FaceAlpha', 0.5)
legend({'Photoreceptor Responses', 'Optogenetic Responses'})
xlabel('Sustained-Transient Index')
ylabel('Number of Cells')
title('ST Index Distribution (OFF cells)')
ylim([0 8])

subplot(1, 3, 3)
hold on
daspect([1 1 1])
xlim([0 1.1])
ylim([0 1.1])
plot([0, 1], [0, 1], 'k--', 'LineWidth', 1.5)

% gscatter(st_scores_good_simple, st_scores_good_pharma, labels_good, 'br', 'oo')
on_plt = scatter(scores_only_on, scores_only_on_pharma, 50, [0.9, 0.2, 0.2], 'o', 'filled', 'MarkerFaceAlpha', .5);
off_plt = scatter(scores_only_off, scores_only_off_pharma, 50, [0.2, 0.2, 0.95], 'o', 'filled', 'MarkerFaceAlpha', .5);
legend('', 'ON cells', 'OFF cells');
xlabel('Photoreceptor Responses')
ylabel('Optogenetic Responses')
title('Sustained-Transient Index Comparison')
