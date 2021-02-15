function data = extractDataDH(raw_file, varargin)

% Default Parameters
dh_electrode_def = 128; % We read the DH channel...
encoding_def = 'uint16';
mea_size_def = 256;

% Parse Input
p = inputParser;
addRequired(p, 'raw_file');
addParameter(p, 'Electrode_ID', dh_electrode_def);
addParameter(p, 'Encoding', encoding_def);
addParameter(p, 'MEA_Size', mea_size_def);
parse(p, raw_file, varargin{:});

dh_electrode = p.Results.Electrode_ID; 
encoding = p.Results.Encoding; 
mea_size = p.Results.MEA_Size;

time_step = 0;      % ...from the beginning...
chunk_size = inf;    % ...to the end.
data = extractDataElectrode(raw_file, dh_electrode, time_step, chunk_size, mea_size, encoding);
