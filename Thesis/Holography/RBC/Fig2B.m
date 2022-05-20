clear
close all


cells_for_plot = [85 216];
max_pattern = 2355;

% Params
max_fr_plot = 30;

% exp_id = '20200131_rbc';
% dh_section_id = 1;
% intensity_spots = 1;

exp_id = '20190821_rbc';
dh_section_id = 1;
intensity_spots = 2/3;

% exp_id = '20190510_rbc';
% % dh_section_id = 1;
% dh_section_id = 2;
% intensity_spots = 2/3;

n_spots = 2;
set_types = ["train", "test"];
min_number_reps = 5;

% Select Valid Cells
[center, radius, vertices, surface, valid_stas] = getMEASTAs(exp_id);
tags = getTags(exp_id);
tagged_cells = find(tags>=3);
good_cells = intersect(valid_stas(:)', tagged_cells(:)');

% Find ON vs OFF cells
[temporal, spatial, rfs, valid] = getSTAsComponents(exp_id);
[polarities, on_cells, off_cells, onoff_cells] = getPolarity(temporal);

good_on_cells = intersect(on_cells, good_cells);
good_off_cells = intersect(off_cells, good_cells);
good_onoff_cells = intersect(onoff_cells, good_cells);


% Chose Patterns and compute distances
patterns = filterHoloPatterns(getHolographyRepetitions(exp_id, dh_section_id), ...
    "Set_Types", set_types, ...
    "Allowed_N_Spots", n_spots, ...
    "Intensity_Spots", intensity_spots, ...
    "N_Min_Repetitions", min_number_reps);

try
    load(strcat('/home/fran_tr/Projects/MEA-Analysis/Scripts/HoloAnalysis/only_holo', exp_id, num2str(dh_section_id), '.mat'));
catch
    distances = getCell2PatternShortestNormDistance(exp_id, dh_section_id);
    
    % Get Activations
    [activations, ~] = getHoloActivations(exp_id, dh_section_id);
    [non_linear_diff, holo] = nonLinearSumHolo(exp_id, dh_section_id, "Pattern_Idx", patterns, "Cell_Idx", good_cells);
    save(strcat('/home/fran_tr/Projects/MEA-Analysis/Scripts/HoloAnalysis/only_holo', exp_id, num2str(dh_section_id), '.mat'));
end

activated_patterns2goodcells = activations.zs(patterns, good_cells) > 0;
surround_patterns2goodcells = distances(good_cells, patterns)' > 1;
surround_patterns2allcells = distances(:, patterns)' > 1;
activated_surround_patterns2goodcells = activated_patterns2goodcells & surround_patterns2goodcells;

activated_surround_goodcells = find(any(activated_surround_patterns2goodcells));
cells_to_show = good_cells(activated_surround_goodcells);

fprintf('showing %i cells:\n', numel(cells_to_show));

% figure();
% nl_diff_good = non_linear_diff(patterns, good_cells);
% nl_diff_surround_activated = nl_diff_good(activated_surround_patterns2goodcells);
% 
% histogram(nl_diff_surround_activated, 20);
% xlabel('MultiSpot Activation - Linear-Sum Activation (Hz)');
% ylabel('Number Of Cells');
% pause(2)

% cell 85 or 216, patter 2355
for cell_id = cells_for_plot(:)'
    
%     patterns_to_show = patterns(surround_patterns2allcells(:, cell_id));
    
    %     plotHoloSTAMultiSpot(exp_id, cell_id, dh_section_id, ...
    %         "Pattern_Idx", patterns_to_show, ...
    %         'Max_Firing_rate', max_fr_plot, ...
    %         'Show_MEA', true, ...
    %         'Weights', activations.scores(patterns_to_show, cell_id));
    %     pause(3);
    
%     [max_score, max_pattern_idx] = max(activations.scores(patterns_to_show, cell_id)); 
%     max_pattern = patterns_to_show(max_pattern_idx);
    
%     for pattern = patterns_to_show(:)'
%         max_single_score = 0;
%         single_score = sum(activations.scores(holo.single_spot_patterns{pattern}, cell_id));
%         if single_score > max_single_score
%             max_pattern = pattern;
%             max_single_score = single_score;
%         end
%     end
    plotHoloCardMultiSpot(exp_id, cell_id, dh_section_id, ...
        "Holo_Pattern_Id_Multi", max_pattern, ...
        "Holo_Pattern_Idx_Single", holo.single_spot_patterns{max_pattern});
    suptitle(strcat("Cell #", num2str(cell_id), " Pattern #", num2str(max_pattern)));
    pause(3);
    waitforbuttonpress();
    close all;


    %     plotHoloActivation(cell_id, patterns, activations, holo);
    %     pause(3);
end

