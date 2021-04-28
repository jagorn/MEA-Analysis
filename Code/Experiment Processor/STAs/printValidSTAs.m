function printValidSTAs(exp_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Label', "");

parse(p, exp_id, varargin{:});
label = p.Results.Label;

[~, ~, ~, valid] = getSTAsComponents(exp_id, 'Label', label);
disp(valid(:)')

