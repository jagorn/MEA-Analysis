function mea_snippets = extractDataMEA(raw_file, time_steps, chunk_size, mea_size, encoding)
% Extract snippets of data from a multi electrode array raw recording.
% INPUTS:
% raw_file: the path to the raw file
% time_steps: the time points at which to extract data (in time steps)
% chunk_size: the size of the snippets extracted (in time steps)
% mea_size: the number of electrodes in the array
% the encoding of the raw file
% OUTPUT:
% mea_snippets: matrix of data snippets of size numel(time_steps) *  mea_size * chunk_size


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

header_size = getHeaderSize(raw_file);
fid = fopen(raw_file, 'r');

for i_rep = 1:n_reps
    t = time_steps(i_rep);
    fseek(fid, header_size + mea_size*data_size*t, 'bof');
    data = fread(fid, chunk_size*mea_size, encoding);
    if strcmp(encoding, 'uint16')
        snippet = 0.1042*(single(data)-32767);
    else
        snippet = single(data);
    end
    mea_snippets(i_rep, :, :) = reshape(snippet, mea_size, chunk_size);
end

fclose(fid);