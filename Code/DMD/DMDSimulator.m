function DMDSimulator(bin_file, vec_file, is_polarity_inverted, freq)

% Read Bin File Header
fid = fopen(bin_file,'r','ieee-le');
stim_data = fread(fid, [1, 4], 'uint16');
TotalX = stim_data(1);
TotalY = stim_data(2);
nbTotalFrames = stim_data(3);
nBit = stim_data(4);

% Read Frames from Bin File
frames = zeros(TotalX, TotalY, nbTotalFrames);
for i_frame = 1:nbTotalFrames
    frames(:, :, i_frame) = fread(fid, [TotalX, TotalY], ['uint' num2str(nBit)]);
end

% Read Frames Sequence from Vec File
vec = load(vec_file);
% add 1 for matlab convention
frame_sequence = vec(2:end, 2)' + 1;

% Plot The Frames
dt_frame = 1/freq;
figure('Name', bin_file)

hold on;
warning_was_shown = false;
for frame_id = frame_sequence
    
    tic;
    if is_polarity_inverted
        frame = 255 - frames(:, :, frame_id);
    else
        frame = frames(:, :, frame_id);
    end
    imshow(frame', 'DisplayRange', [0, 255])
    t = toc;
    pause(dt_frame- t)
    
    if (dt_frame < t) && ~warning_was_shown
        warning('frame rate is too high to be displayed correctly')
        warning_was_shown = true;
    end
end
