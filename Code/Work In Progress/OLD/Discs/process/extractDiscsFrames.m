function discs_frames = extractDiscsFrames(discs_bin_file)


% Read Bin File Header
fid = fopen(discs_bin_file,'r','ieee-le');
stim_data = fread(fid, [1, 4], 'uint16');
TotalX = stim_data(1);
TotalY = stim_data(2);
nbTotalFrames = stim_data(3);
nBit = stim_data(4);

% Read Frames from Bin File
for i_frame = 1:nbTotalFrames
    frame = fread(fid, [TotalX, TotalY], ['uint' num2str(nBit)]);
    
    norm_img = frame-min(frame(:));
    if max(norm_img(:)) > 0
        norm_img = norm_img /max(norm_img(:));
    end
    norm_img = logical(norm_img);
  
    radius_range = [10, max(TotalX, TotalY)];
    
    [centers_d, radii_d] = imfindcircles(norm_img, radius_range, 'ObjectPolarity', 'dark');
    [centers_l, radii_l] = imfindcircles(norm_img, radius_range, 'ObjectPolarity', 'bright');
    
    assert(isempty(centers_d) || isempty(centers_l))
    if isempty(centers_d) && isempty(centers_l)
        center_x = [];
        center_y = [];
        radius = [];
        disc_color = [];
    elseif isempty(centers_d)
        assert(length(centers_l) == 2);
        center_x = round(centers_l(1));
        center_y = round(centers_l(2));
        radius = round(radii_l(1));
        disc_color = frame(round(center_y), round(center_x));
    else
        assert(length(centers_d) == 2);
        center_x = round(centers_d(1));
        center_y = round(centers_d(2));
        radius = round(radii_d(1)); 
        disc_color = frame(round(center_y), round(center_x));
    end
    
    background_color = frame(1,1);
    
    discs_frames(i_frame).id = i_frame -1;
    discs_frames(i_frame).disc_color = disc_color;
    discs_frames(i_frame).disc_center_x = center_x;
    discs_frames(i_frame).disc_center_y = center_y;
    discs_frames(i_frame).disc_radius = radius;
    discs_frames(i_frame).background_color = background_color;
end