function [TotalX, TotalY, nbTotalFrames, nBit]= getBinFileInfos(bin_file)

% Read Bin File Header
fid = fopen(bin_file,'r','ieee-le');
stim_data = fread(fid, 4, 'uint16');
TotalX = stim_data(1);
TotalY = stim_data(2);
nbTotalFrames = stim_data(3) + 1;
nBit = stim_data(4);