function sta_frame = getSTAFrame(i_cell, do_smooth)

if ~exist('do_smooth', 'var')
    do_smooth = false;
end
load(getDatasetMat, "stas");

if do_smooth
    sta_frame = std(smoothSta(stas{i_cell}), [], 3);
else
    sta_frame = std(stas{i_cell}, [], 3);
end

