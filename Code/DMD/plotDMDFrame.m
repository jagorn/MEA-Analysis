function plotDMDFrame(stim_id, stim_version, frame_id, varargin)

% Parse Input
p = inputParser;
addRequired(p, 'stim_id');
addRequired(p, 'stim_version');
addRequired(p, 'frame_id');
addParameter(p, 'Polarity', 1);
addParameter(p, 'Homography', []);

parse(p, stim_id, stim_version, frame_id, varargin{:});
polarity = p.Results.Polarity;
homography = p.Results.Homography;

file_path = fullfile(stimPath(stim_id), 'bin_files', strcat(stim_version, '.bin'));
frame = extractFrameBin(file_path, frame_id, polarity);
img = frame / max(frame(:));

if isempty(homography)
    img_handle = imshow(img);
    set(img_handle, 'AlphaData', 0.4);
else
    [img_2mea, imgRef_2mea] = transformImage(homography, img);
    img_handle = imshow(img_2mea, imgRef_2mea);
    set(img_handle, 'AlphaData', 0.4);
end


