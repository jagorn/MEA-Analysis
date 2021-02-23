function [unique_frames, unique_beg_time, unique_end_time] = concatPatterns(reps)
% Concatenates patterns with differents sets of spots
% By enlarging the size of the patterns

frames = [];
beg_time = [];
end_time = [];

for i = 1:numel(reps)
    [n_reps, n_spots] = size(frames);
    [n_new_reps, n_new_spots] = size(reps{i}.frames);

    frames(n_reps+1:n_reps+n_new_reps, n_spots+1:n_spots+n_new_spots) = reps{i}.frames;
    beg_time = [beg_time, reps{i}.rep_begin];
    end_time = [end_time, reps{i}.rep_end];
end

[unique_frames] = unique(frames, 'rows');
n_unique_frames = size(unique_frames, 1);
unique_beg_time = cell(n_unique_frames, 1);
unique_end_time = cell(n_unique_frames, 1);

for i_unique = 1:n_unique_frames
    frame = unique_frames(i_unique, :);
    idx_frame = all(frame==frames, 2);
    unique_beg_time{i_unique} = [beg_time{idx_frame}];
    unique_end_time{i_unique} = [end_time{idx_frame}];
end      
        

