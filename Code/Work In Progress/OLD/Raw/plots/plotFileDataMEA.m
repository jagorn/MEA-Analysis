function plotFileDataMEA(raw_file, time_step, chunk_size, color, dead_electrodes, stim_electrodes, encoding, mea_map)
assert(numel(time_step) ==1)

if ~exist('mea_map', 'var')
    load('PositionsMEA', 'Positions')
    mea_map = double(Positions);
end

if ~exist('encoding', 'var')
	encoding = 'uint16';
end

if ~exist('dead_electrodes', 'var')
    dead_electrodes = [];
end

if ~exist('stim_electrodes', 'var')
    stim_electrodes = [127 128 255 256];
end

if ~exist('color', 'var')
    color = 'k';
end

mea_size = size(mea_map, 1);
waves = extractDataMEA(raw_file, time_step, chunk_size, mea_size, encoding);
waves = reshape(waves, mea_size, chunk_size)/10;
plotDataMEA(waves, mea_map, color, dead_electrodes, stim_electrodes)