function snippets = extractDataElectrode(raw_file, electrode_id, time_steps, chunk_size, mea_size, encoding)
% Extract snippets of electrode traces from a multi electrode array raw recording.
% INPUTS:
% raw_file: the path to the raw file
% electrode_id: the index of the electrode to read from
% time_steps: the time points at which to extract data (in time steps)
% chunk_size: the size of the snippets extracted (in time steps)
% mea_size: the number of electrodes in the array
% the encoding of the raw file
% OUTPUT:
% snippets: matrix of data snippets of size numel(time_steps) * chunk_size

if strcmp(encoding, 'uint16')
    data_size = 2;   % bites
elseif strcmp(encoding, 'float32')
    data_size = 4;   % bites
else
    error_struct.message = strcat("the data type ",  encoding, " is not supported");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

n_reps = length(time_steps);
if n_reps > 1
    snippets = zeros(n_reps, chunk_size);
end
header_size = getHeaderSize(raw_file);
fid = fopen(raw_file, 'r');

for i_rep = 1:n_reps
    t = time_steps(i_rep);
    location = header_size + (electrode_id - 1)*data_size + mea_size*data_size*t;
    fseek(fid, location, 'bof');
    data = fread(fid, chunk_size, encoding, (mea_size - 1)*data_size);
    if strcmp(encoding, 'uint16')
        snippets(i_rep, :) = 0.1042*(single(data)-32767);
    else
        snippets(i_rep, :) = single(data);
    end
end
fclose(fid);