function [temporal, spatial, rfs, valid] = getSTAsComponents(exp_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Label', "");
parse(p, exp_id, varargin{:});
label = p.Results.Label;

stas_file = getSTAsFile(exp_id, label);
load(stas_file, 'temporal', 'spatial', 'rfs', 'valid');

if ~exist('temporal', 'var') ||  ~exist('spatial', 'var') ||  ~exist('rfs', 'var') || ~exist('valid', 'var')
    error_struct.message = strcat("STAs were not factorized yet in ", exp_id);
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);  
end
    
