function mea_snippets = extractDataMEA(raw_file, time_steps, chunk_size, mea_size, encoding, varargin)
% Extract snippets of data from a multi electrode array raw recording.
%
% INPUTS:
% raw_file: the path to the raw file
% time_steps: the time points at which to extract data (in time steps)
% chunk_size: the size of the snippets extracted (in time steps)
% mea_size: the number of electrodes in the array
% encoding: the encoding of the raw file
% mv_scaling (optional): the scaling to convert the input signal into mv
% mv_offset (optional): the offset to convert the input signal into mv
%
% OUTPUT:
% mea_snippets: matrix of data snippets of size numel(time_steps) *  mea_size * chunk_size


% Params
scaling_mv_def = 0.1042;    % mV
offset_mv_def = 32767;     % steps

% Parse input
p = inputParser();
addRequired(p, 'raw_file');
addRequired(p, 'time_steps');
addRequired(p, 'chunk_size');
addRequired(p, 'mea_size');
addRequired(p, 'encoding');
addParameter(p, 'Scale_mV', scaling_mv_def);
addParameter(p, 'Offset_mV', offset_mv_def);

parse(p, raw_file, time_steps, chunk_size, mea_size, encoding, varargin{:});
scale_mv = p.Results.Scale_mV;
offset_mv = p.Results.Offset_mV;



if strcmp(encoding, 'uint16')
    data_size = 2;   % bites
elseif strcmp(encoding, 'float32')
    data_size = 4;  % bites
else
    error_struct.message = strcat("the data type ",  encoding, " is not supported");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

n_reps = length(time_steps);
mea_snippets = zeros(n_reps, mea_size, chunk_size);

try
    header_size = getHeaderSize(raw_file);
    fid = fopen(raw_file, 'r');
catch
    error_struct.message = strcat("the file ",  raw_file, " does not exist");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

for i_rep = 1:n_reps
    t = time_steps(i_rep);
    fseek(fid, header_size + mea_size*data_size*t, 'bof');
    data = fread(fid, chunk_size*mea_size, encoding);
    
    if strcmp(encoding, 'uint16')
        snippet = scale_mv * (single(data) - offset_mv);
    else
        snippet = single(data);
    end
    mea_snippets(i_rep, :, :) = reshape(snippet, mea_size, chunk_size);
end

fclose(fid);