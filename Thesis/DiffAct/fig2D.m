experiments = ["20201021_lap4acet_noSTAs"; "20201028_lap4acet_noSTAs"; "20210108_lap4acet_noSTAs"; "20201202_cnqxcpp_noSTAs"; "20210322_cnqxcpp_noSTAs"];
pattern_label = 'flicker';

cond_idx = 10:-1:4;


all_condition_labels = [];

graph_on_cells = cell(1, numel(experiments));
grapsh_off_cells = cell(1, numel(experiments));
conditions = cell(1, numel(experiments));

total_on  = zeros(1, numel(experiments));
total_off  = zeros(1, numel(experiments));


for i_exp = 1:numel(experiments)
    experiment = experiments(i_exp);
    [GraphOnCells, GraphOffCells, TotalON, TotalOFF, condition_labels] = onOffAnalysis(experiment, pattern_label);
    all_condition_labels = union(all_condition_labels, condition_labels);
    
    graph_on_cells{i_exp} = GraphOnCells;
    grapsh_off_cells{i_exp} = GraphOffCells;
    conditions{i_exp} = condition_labels;
    
    total_on(i_exp) = TotalON;
    total_off(i_exp) = TotalOFF;
end


all_graph_on_cells = cell(numel(experiments), numel(all_condition_labels));
all_graph_off_cells = cell(numel(experiments), numel(all_condition_labels));

for i_exp = 1:numel(experiments)
    conditions_exp = conditions{i_exp};
    graph_on_cell = graph_on_cells{i_exp};
    graph_off_cell = grapsh_off_cells{i_exp};
    
    for i_condition = 1:numel(conditions_exp)
        
        condition = conditions_exp{i_condition};
        condition_id = strcmp(all_condition_labels, condition);
        
        all_graph_on_cells{i_exp, condition_id} = graph_on_cell(i_condition, :);
        all_graph_off_cells{i_exp, condition_id} = graph_off_cell(i_condition, :);
    end
end

n_conditions = numel(all_condition_labels);
n_experiments = numel(experiments);

avg_graph_on = zeros(n_conditions, 3);
avg_graph_off = zeros(n_conditions, 3);
std_graph_on = zeros(n_conditions, 3);
std_graph_off = zeros(n_conditions, 3);

for i_c = 1:n_conditions
    sum_entry_on = [0, 0, 0];
    sum_entry_off = [0, 0, 0];
    
    for i_e = 1:n_experiments
        entry_on = all_graph_on_cells{i_e, i_c};
        entry_off = all_graph_off_cells{i_e, i_c};
        
        if ~isempty(entry_on)
            sum_entry_on = sum_entry_on + entry_on;
        end
        
        if ~isempty(entry_off)
            sum_entry_off = sum_entry_off + entry_off;
        end
    end
    
    total_entry_on = sum(sum_entry_on);
    avg_entry_on = sum_entry_on / total_entry_on;
    std_entry_on  = sqrt(total_entry_on .* avg_entry_on .* (1 - avg_entry_on)) ./ total_entry_on;
    
    total_entry_off = sum(sum_entry_off);
    avg_entry_off = sum_entry_off / total_entry_off;
    std_entry_off  = sqrt(total_entry_off .* avg_entry_off .* (1 - avg_entry_off)) ./ total_entry_off;
    
    avg_graph_on(i_c, :) = avg_entry_on;
    avg_graph_off(i_c, :) = avg_entry_off;
    std_graph_on(i_c, :) = std_entry_on;
    std_graph_off(i_c, :) = std_entry_off;
    
end

% Legends
legend_onset =  'Activated at Onset';
legend_offset = 'Activated at Offset';
legend_silent = 'Never Activated';
x_labels = all_condition_labels(cond_idx);
x_labels = regexprep(x_labels, '_', '');
x_labels = regexprep(x_labels, 'lap4', 'L');
x_labels = regexprep(x_labels, 'acet', 'A');
x_labels = regexprep(x_labels, 'cnqxcpp', 'C');

% Plot the histograms
figure;
fullScreen();

% First ON cells...
subplot(2, 1, 1);
hold on;
b = bar(avg_graph_on(cond_idx, :));
b(1).FaceColor = [.99 .5 .5];
b(2).FaceColor = [.8 .2 .2];
b(3).FaceColor = [.3 .3 .3];

hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(avg_graph_on(cond_idx, :));
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',avg_graph_on(cond_idx, :),std_graph_on(cond_idx, :),'k','linestyle','none');
hold off

legend(legend_onset, legend_offset, legend_silent)
ylabel('Cells Activated (%) ')
xlabel('Light Levels')
ylim([0 1])

set(gca,'FontSize', 10)
set(gca,'box','off')
set(gca,'XTick', 1:numel(x_labels))
set(gca,'XTickLabel', x_labels)

set(gca,'YTick', 0:0.2:1)
set(gca,'yTickLabel', 0:20:100)

title(['ON Cells (' num2str(TotalON) ')'])


% ...then OFF cells
subplot(2, 1, 2);
hold on;
b = bar(avg_graph_off(cond_idx, :));
b(1).FaceColor = [.5 .5 .99];
b(2).FaceColor = [.2 .2 .8];
b(3).FaceColor = [.3 .3 .3];

hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(avg_graph_off(cond_idx, :));
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',avg_graph_off(cond_idx, :),std_graph_off(cond_idx, :),'k','linestyle','none');
hold off


legend(legend_onset, legend_offset, legend_silent)
ylabel('Cells Activated (%) ')
xlabel('Light Levels')
ylim([0 1])

set(gca,'FontSize', 10)
set(gca,'box','off')
set(gca,'XTick', 1:numel(x_labels))
set(gca,'XTickLabel', x_labels)

set(gca,'YTick', 0:0.2:1)
set(gca,'yTickLabel', 0:20:100)

title( ['OFF Cells (' num2str(TotalOFF) ')'])

% Figure Title
suptitle('Control Activation (no Opsin Expressed)')