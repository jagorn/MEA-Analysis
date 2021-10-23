function extractVisualHoloRepetitions(exp_id, visual_section_id, holo_section_id)

[visual_section, i_visual_section] = getSection(exp_id, visual_section_id);
holo_section = getHoloSection(exp_id, holo_section_id);

visual_section_id = visual_section.id;
visual_stim_id = visual_section.stimulus;
visual_conditions = visual_section.conditions;
holo_stim_id = holo_section.stimulus;

configs = loadConfigs(exp_id, visual_section_id);

if ~isKey(configs, 'version')
    error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'version' is missing");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if ~isKey(configs, 'is_looping')
    error_struct.message = strcat("In the ", section_id, " configuration file the parameter 'is_looping' is missing");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

visual_stim_version = configs('version');
vec_file = getVecFile(visual_stim_id, visual_stim_version);
[TotalBlock, BlockSign] = getHolographyFrames(exp_id, holo_stim_id);
evtTimes = getEvtTimes(exp_id);

vec_matrix = load(vec_file);
visual_sequence = vec_matrix(2:end, 2);
dh_sequence = vec_matrix(2:end, 4);

visual_triggers = evtTimes{i_visual_section}.evtTimes_begin;

visual_map = getRepetitionsMap(visual_stim_id, visual_stim_version);
state_labels = string(['simple', visual_map.names]);

repetitions = computeVisualHoloRepetitions(state_labels, visual_triggers, visual_sequence, dh_sequence, TotalBlock, BlockSign);
h_table = getHolographyTable(exp_id);
n_entries_h = numel(h_table);

for i_rep = 1:numel(repetitions)
    label = repetitions(i_rep).label;
    reps = repetitions(i_rep).repetitions;
    
    stim_id = strcat(num2str(n_entries_h + i_rep), '-', visual_stim_id, '-', label);
    if ~isempty(visual_conditions)
        stim_id = strcat(stim_id, '_(', join(string(visual_conditions), '_'), ')');
    end
    
    try
        visual_section.positions = holo_section.positions;
    end
    
    try
        visual_section.image = holo_section.image;
    end
    
    h_table(n_entries_h + i_rep) = visual_section;
    h_table(n_entries_h + i_rep).id = stim_id;
    h_table(n_entries_h + i_rep).stimulus = strcat('holo_', label);
    h_table(n_entries_h + i_rep).repetitions = reps;
end
setHolographyTable(exp_id, h_table);


