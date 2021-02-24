function selected_patterns = selectPatterns(z_score, varargin)

% Default Parameters
n_min_activations_def = 1;
n_min_patterns_def = 0;
n_max_patterns_def = size(z_score, 2);


% Parse Input
p = inputParser;
addRequired(p, 'z_score');

addParameter(p, 'N_Min_Activations', n_min_activations_def);
addParameter(p, 'N_Min_Patterns', n_min_patterns_def);
addParameter(p, 'N_Max_Patterns', n_max_patterns_def);

% Assign Parameters
parse(p, z_score, varargin{:});
n_min_activations = p.Results.N_Min_Activations;
n_min_patterns = p.Results.N_Min_Patterns;
n_max_patterns = p.Results.N_Max_Patterns;

% Choose Patterns
activations = sum(z_score);
[activations_sorted, patterns_sorted] = sort(activations, 'descend');

if numel(patterns_sorted) > n_max_patterns
    patterns_sorted = patterns_sorted(1:n_max_patterns);
    activations_sorted = activations_sorted(1:n_max_patterns);
end

patterns_enough_activations = patterns_sorted(activations_sorted >= n_min_activations);

if numel(patterns_enough_activations) > n_min_patterns
    selected_patterns = patterns_enough_activations;
else
    selected_patterns = patterns_sorted(1:n_min_patterns);
end