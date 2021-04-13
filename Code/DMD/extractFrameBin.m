function frame = extractFrameBin(bin_file, frame_id, is_polarity_inverted)

% Read Bin File Header
fid = fopen(bin_file,'r','ieee-le');
stim_data = fread(fid, 4, 'uint16');
TotalX = stim_data(1);
TotalY = stim_data(2);
nbTotalFrames = stim_data(3) + 1;
nBit = stim_data(4);


if frame_id > nbTotalFrames
    error_struct.message = strcat("The file ", bin_file, " only has ", num2str(nbTotalFrames), " frames");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

fseek(fid, TotalX*TotalY*(frame_id-1) ,'cof');
frame = fread(fid, [TotalX, TotalY], ['uint' num2str(nBit)]);
fclose(fid);

if is_polarity_inverted
    frame = 255 - frame;
end