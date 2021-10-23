function mergeHoloSections(exp_id, section_id_1, section_id_2)

section_1 = getHoloSection(exp_id, section_id_1);
section_2 = getHoloSection(exp_id, section_id_2);
holo_table = getHolographyTable(exp_id);

if section_1.stimulus ~= section_2.stimulus
    error_struct.message = strcat("Cannot merge the two sections: different stimuli used");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
stimulus = section_1.stimulus;

if section_1.rate ~= section_2.rate
    error_struct.message = strcat("Cannot merge the two sections: different frame rate used");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
rate = section_1.rate;

if ~isequal(section_1.positions, section_2.positions)
    error_struct.message = strcat("Cannot merge the two sections: different spot positions used");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end
positions = section_1.positions;

conditions = union(section_1.conditions, section_2.conditions);
notes = strcat("merged from section ", num2str(section_id_1), " and ", num2str(section_id_2));
triggers = [section_1.triggers, section_2.triggers];
durations = [section_1.durations, section_2.durations];

stim_count = numel(holo_table) + 1;
stim_id = strcat(num2str(stim_count), '-', stimulus, '_merged');
if ~isempty(conditions)
    stim_id = strcat(stim_id, '_(', join(string(conditions), '_'), ')');
end

% TODO
repetitions_1 = section_1.repetitions;
repetitions_2 = section_2.repetitions;

patterns = union(repetitions_1.patterns, repetitions_2.patterns, 'row');
n_patterns = size(patterns, 1);

[~, p_idx_1] = ismember(repetitions_1.patterns, patterns, 'row');
[~, p_idx_2] = ismember(repetitions_2.patterns, patterns, 'row');

rep_durations = zeros(n_patterns, 1);
rep_begins = cell(n_patterns, 1);
set_type = strings(n_patterns, 1);

rep_durations(p_idx_2) = repetitions_2.durations;
rep_durations(p_idx_1) = repetitions_1.durations;

set_type(p_idx_2) = repetitions_2.set_type;
set_type(p_idx_1) = repetitions_1.set_type;

for i_pattern = 1:n_patterns
    rep_begins{i_pattern} = [repetitions_1.rep_begins{p_idx_1 == i_pattern}  repetitions_2.rep_begins{p_idx_2 == i_pattern}];
end

repetitions.patterns = patterns;
repetitions.durations = rep_durations;
repetitions.rep_begins = rep_begins;
repetitions.set_type = set_type;

section.id = stim_id;
section.stimulus = stimulus;
section.conditions = conditions;
section.notes = notes;
section.triggers = triggers;
section.durations = durations;
section.rate = rate;
section.repetitions = repetitions;
section.positions = positions;

try
    section.image = section_1.image;
end

holo_table(stim_count) = section;
setHolographyTable(exp_id, holo_table)





