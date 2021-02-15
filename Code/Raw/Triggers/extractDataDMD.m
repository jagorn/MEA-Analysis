function data = extractDataDMD(raw_file, varargin)

% Default Parameters
dmd_electrode_def = 127; % We read the DMD channel...
encoding_def = 'uint16';
mea_size_def = 256;

% Parse Input
p = inputParser;
addRequired(p, 'raw_file');
addParameter(p, 'Electrode_ID', dmd_electrode_def);
addParameter(p, 'Encoding', encoding_def);
addParameter(p, 'MEA_Size', mea_size_def);
parse(p, raw_file, varargin{:});

dmd_electrode = p.Results.Electrode_ID; 
encoding = p.Results.Encoding; 
mea_size = p.Results.MEA_Size;

time_step = 0;      % ...from the beginning...
chunk_size = inf;    % ...to the end.

data = extractDataElectrode(raw_file, dmd_electrode, time_step, chunk_size, mea_size, encoding);