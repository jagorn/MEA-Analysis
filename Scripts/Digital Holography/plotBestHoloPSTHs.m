function plotBestHoloPSTHs(exp_id, dh_session_id, varargin)


% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'dh_session_id');
addParameter(p, 'N_Spots', 1);
addParameter(p, 'Set_Types', ["test", "train"]);
addParameter(p, 'Mode', 'raster'); % raster or psth
addParameter(p, 'One_By_One', true);
addParameter(p, 'Save', false);

parse(p, exp_id, dh_session_id, varargin{:});
n_spots = p.Results.N_Spots;
set_types = p.Results.Set_Types;
mode = p.Results.Mode;
one_by_one = p.Results.One_By_One;
do_save = p.Results.Save;

plot_columns = 4;
n_patterns_show = 20;

rate = getMeaRate(exp_id);
spikes = getSpikeTimes(exp_id);
tags = getTags(exp_id);
repetitions = getHolographyRepetitions(exp_id, dh_session_id);
psths = getHolographyPSTHs(exp_id);
multi_psth = psths(dh_session_id);

patterns = filterHoloPatterns(repetitions, "Set_Types", set_types, "Allowed_N_Spots", n_spots);
norm_scores = multi_psth.activations.scores;
norm_scores(norm_scores < 0) = 0;

[~, good_patterns_idx] = sort(sum(norm_scores(patterns, :), 2), 'descend');

n_patterns_show = min(n_patterns_show, numel(good_patterns_idx));
good_patterns = patterns(good_patterns_idx(1:n_patterns_show));

% Choose the best cells
[~, ~, ~, valid_cells] =  getSTAsComponents(exp_id);
tagged_cells = find(tags>=3);
best_cells = intersect(valid_cells(:)', tagged_cells(:)');

[~, best_cells_idx] = sort(sum(multi_psth.activations.zs(good_patterns, best_cells)), 'descend');
best_cells = best_cells(best_cells_idx);

% recap plots
z_plot = multi_psth.activations.zs(patterns, best_cells);

figure();
subplot(2, 2, 3);
imagesc(z_plot);
xlabel('cells')
ylabel('patterns');

subplot(2, 2, 1);
bar(sum(z_plot), 'g')
title('number of activations by cells');
xlim([0.5, numel(sum(z_plot))+0.5])
axis off

subplot(2, 2, 4);
barh(sum(z_plot, 2), 'r')
title('number of activated cells by pattern');
ylim([0.5, numel(sum(z_plot, 2))+0.5])
axis off


i_column = 1;
i_plot = 0;
for i_cell = best_cells(:)'
    
    if i_column == 1
        figure();
        fullScreen();
        i_plot = i_plot + 1;
    end
    
    labels = string(good_patterns);
    activated_patterns = find(multi_psth.activations.zs(good_patterns, i_cell));
    for act_pattern = activated_patterns(:)'
        labels(act_pattern) = strcat(labels(act_pattern), '(A)');
    end
    
    subplot(1, plot_columns, i_column);
    if strcmp(mode, 'raster')
        plotStimRaster(spikes{i_cell}, repetitions.rep_begins, median(repetitions.durations), rate, ...
                        'Pattern_Indices', good_patterns, ...
                        'Edges_Onsets', multi_psth.resp_win(1), ...
                        'Edges_Offsets', multi_psth.resp_win(2), ...
                        'Post_Stim_DT', 1, ...
                        'Pre_Stim_DT', 1, ...
                        'Labels', labels);
    else
        plotStimPSTH(multi_psth.psth.responses(:, i_cell, :), multi_psth.psth.t_bin, ...
                        'Stim_Onset_Seconds', multi_psth.psth.t_spacing, ...
                        'Stim_Offset_Seconds', -multi_psth.psth.t_spacing, ...
                        'Pattern_Indices', good_patterns, ...
                        'Edges_Onsets', multi_psth.resp_win(1) +  multi_psth.psth.t_spacing, ...
                        'Edges_Offsets', multi_psth.resp_win(2) +  multi_psth.psth.t_spacing, ...
                        'Labels', labels);
    end
    
    title([strcat("cell#", num2str(i_cell), " (tag=", num2str(tags(i_cell)), ")"); strcat("activations = ", num2str(numel(activated_patterns)))]);
    i_column = i_column + 1;
    if i_column > plot_columns
        t = suptitle(getHoloSection(exp_id, dh_session_id).id);
        t.Interpreter = 'None';
        
        if do_save
            file_name = strcat(getHoloSection(exp_id, dh_session_id).id, '_Rasters#', num2str(i_plot));
            file_folder = fullfile(plotsPath(exp_id), 'Holography');
            
            if ~exist(file_folder, 'dir')
                mkdir(file_folder);
            end

            file_path = fullfile(file_folder, file_name);
            saveas(gcf, file_path,'jpg')
        end
        
        if one_by_one
            waitforbuttonpress()
        end
        close;
        i_column = 1;
    end
end
