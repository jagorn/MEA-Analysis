function saveSTAs(exp_id, STAs, temporal, spatial, rfs, valid, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'STAs');
addRequired(p, 'temporal');
addRequired(p, 'spatial');
addRequired(p, 'rfs');
addRequired(p, 'valid');
addParameter(p, 'Label', "");

parse(p, exp_id, STAs, temporal, spatial, rfs, valid, varargin{:});
label = p.Results.Label;

stas_file = getSTAsFile(exp_id, label);
save(stas_file, 'STAs', 'temporal', 'spatial', 'rfs', 'valid');