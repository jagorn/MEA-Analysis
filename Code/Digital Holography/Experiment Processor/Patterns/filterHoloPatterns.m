function indices = filterHoloPatterns(holo_patterns, varargin)

[n_patterns, n_spots] = size(holo_patterns.patterns);

% Parameters Sorting Files
set_types_def = ["train", "test"];  % it can be "train", "test", or  both
intensity_def = [];
allowed_n_spots_def = [];
mandatory_spots = [];
optional_spots_def = 1:n_spots;
min_number_reps_def = 0;

% Parse Input
p = inputParser;
addRequired(p, 'holo_patterns');
addParameter(p, 'Set_Types', set_types_def);
addParameter(p, 'Allowed_N_Spots', allowed_n_spots_def);
addParameter(p, 'Intensity_Spots', intensity_def);
addParameter(p, 'Mandatory_Spots', mandatory_spots);
addParameter(p, 'Optional_Spots', optional_spots_def);
addParameter(p, 'N_Min_Repetitions', min_number_reps_def);

parse(p, holo_patterns, varargin{:});

set_types = p.Results.Set_Types;
allowed_n_spots = p.Results.Allowed_N_Spots;
mandatory_spots = p.Results.Mandatory_Spots;
optional_spots = p.Results.Optional_Spots;
min_number_reps = p.Results.N_Min_Repetitions;
intensity = p.Results.Intensity_Spots;

% min number repetitions
idx_min_number_reps = false(n_patterns, 1);
for i_p = 1:n_patterns
    if numel(holo_patterns.rep_begins{i_p}) >= min_number_reps
        idx_min_number_reps(i_p) = true;
    end
end

% set intensity
if isempty(intensity)
    idx_set_intensity = true(n_patterns, 1);
else
    idx_set_intensity = abs(sum(holo_patterns.patterns, 2) - intensity) < 0.01;
end


% set type
if isempty(set_types)
    idx_set_types = true(n_patterns, 1);
else
    idx_set_types = false(n_patterns, 1);
    for set_type = set_types
        idx_set_types = idx_set_types | strcmp(holo_patterns.set_type, set_type);
    end
end

% allowed number of spots
if isempty(allowed_n_spots)
    idx_n_spots = true(n_patterns, 1);
else
    idx_n_spots = false(n_patterns, 1);
    for dim_pattern = allowed_n_spots
        idx_n_spots = idx_n_spots | sum(holo_patterns.patterns>0, 2) == dim_pattern;
    end
end

% mandatory spots
if isempty(mandatory_spots)
    idx_mandatory_spots = true(n_patterns, 1);
else
    idx_mandatory_spots = false(n_patterns, 1);
    for m_spot = mandatory_spots
        idx_mandatory_spots = idx_mandatory_spots | holo_patterns.patterns(:, m_spot);
    end
end

% optional spots
idx_optional_spots = true(n_patterns, 1);
m_spots_logical = unfind(mandatory_spots, n_spots);
o_spots_logical = unfind(optional_spots, n_spots);
excluded_spots = find(~m_spots_logical & ~o_spots_logical);
for e_spot = excluded_spots
    idx_optional_spots = idx_optional_spots & ~holo_patterns.patterns(:, e_spot);
end

% pool together
indices = find(idx_set_types & idx_n_spots & idx_mandatory_spots & idx_optional_spots & idx_set_intensity & idx_min_number_reps);