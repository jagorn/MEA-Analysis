function spike_times = extractMultiUnit_dat(file_prefix)

spike_times = cell(1, 256);
for ich = 1:256
    if ich < 10
        a = importdata([file_prefix '0' int2str(ich) '.dat']);
    else
        a = importdata([file_prefix int2str(ich) '.dat']);
    end
    if isfield(a, 'data')
        spike_times{ich} = a.data;
        spike_times{ich} = spike_times{ich}(:, 1);
    end
end

