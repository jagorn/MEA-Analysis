clear
% close all

% experiments
ctrl_ids = ["20210721_grid", "20220421_dh_discs", "20220428_dh_discs"];
test_ids = ["20210804a_a2", "20220502_a2_discs" ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  analysis parameters

            %
            %
            %
          % % %
           %%%
            %

exp_ids = test_ids;
visual_win = [0.175 0.500];  % seconds
activation_win = [0.150 0.550];  % seconds
surround_distance = 50; % microns

plot_single_cell = true;
plot_population = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot parameters
colors = getColors(numel(exp_ids));
f_id = randi(1e5);

% visual parameters
visual_pattern_id = 1;
visual_stim = 'holo_simple';

% holography parameters
holo_stim = 'discdelay';
intensity_spots = 1;
n_spots = 1;
set_types = ["train", "test"];
min_number_reps = 5;


for i_exp = 1:numel(exp_ids)
    exp_id = exp_ids(i_exp);
    
    fprintf('Experiment %s\n', exp_id);
    
    % Find Sections
    holo_table = getHolographyTable(exp_id);
    visual_table = getSectionsTable(exp_id);
    dh_section_id = find(contains([holo_table.stimulus], visual_stim));
    visual_section_id = find(contains([visual_table.stimulus], holo_stim));
    assert(numel(dh_section_id) == 1 && numel(visual_section_id) == 1);
    
    % Select Valid Cells
    [center, radius, vertices, surface, valid_stas] = getMEASTAs(exp_id);
    tags = getTags(exp_id);
    tagged_cells = find(tags>=3);
    valid_cells = intersect(valid_stas(:)', tagged_cells(:)');
    
    % Find ON vs OFF cells
    [temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);
    [polarities, on_cells, off_cells, onoff_cells] = getPolarity(temporal);
    
    % Filter Patterns
    patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
        "Set_Types", set_types, ...
        "Allowed_N_Spots", n_spots, ...
        "Intensity_Spots", intensity_spots, ...
        "N_Min_Repetitions", min_number_reps);
    
    % Detect Responses
    [scores, activations, visual, holo] = compareHoloVisualActivations(exp_id, visual_section_id, dh_section_id, ...
        "Pattern_Idx", patterns, ...
        "Visual_Window", visual_win, ...
        "Activation_Window", activation_win, ...
        "Visual_Pattern_Id", visual_pattern_id);
    activated_cells = find(activations.zs > 0);
    activation_scores = scores .* (activations.zs > 0);
    
    % Check Distances
    [distances_disc, valid_stas] = getCell2DMDStimDistances(exp_id, dh_section_id);
    distances_spots = getCell2PatternShortestDistances(exp_id, dh_section_id);
    surround_cells = find(distances_disc > surround_distance);
    
    % Choose cells
    valid_off_cells = intersect(off_cells, valid_cells);
    activated_surround_cells = intersect(activated_cells, surround_cells);
    my_cells = intersect(activated_surround_cells, valid_off_cells);
    
    % Plot Population
    if plot_population
        figure(f_id);
        hold on;

        x_scatter = [];
        y_scatter = [];
        for i_p = 1:numel(patterns)
            x_scatter = [x_scatter,  distances_spots(i_p, my_cells)];
            y_scatter = [y_scatter, activation_scores(i_p, my_cells)];
        end
        hs(i_exp) = scatter(x_scatter, y_scatter, 20, colors(i_exp, :), 'Filled',  'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0);
        
        fprintf('\tn. cells: %i.\n', numel(my_cells));
        fprintf('\tmean modulation: %f.\n', mean(y_scatter));
        fprintf('\tstd modulation: %f.\n', std(y_scatter));
    end
    
    % Plot RGCs
    if plot_single_cell
        for cell_id = my_cells(:)'
            
            [max_activation, max_pattern] = max(activation_scores(:, cell_id));
            plotVisualHoloCard(exp_id, cell_id, dh_section_id, visual_section_id, ...
                "Holo_Pattern_Id", max_pattern, ...
                "Visual_Pattern_Id", visual_pattern_id, ...
                "Visual_Win", visual_win);
            title(strcat("Pattern #", num2str(max_pattern)));
            pause(1);
            plotHoloVisualActivation(cell_id, patterns, activations, visual, holo);
            ss = get(0,'screensize');
            width = ss(3);
            height = ss(4);
            set(gcf,'Position',[0, 0, width, height/2]);
            waitforbuttonpress();
            close all;
        end
    end
    fprintf('\n');
    
end

if plot_population
    
        % Make plot nicer
        figure(f_id);
        yline(-10, 'k--');
        yline( 0,  'k--');
        yline(+10, 'k--');
        xlabel('distance RGC-disc [\mum]');
        xlim([surround_distance 1000]);
        ylabel('surround modulation [Hz]');
        ylim([-20 40]);
        legend(hs, exp_ids, 'Interpreter', 'None');
end