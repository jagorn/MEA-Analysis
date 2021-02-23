function [unique_frames, unique_beg_time, unique_end_time] = stackPatterns(reps)
% Stacks patterns with the same sets of spots
% The size of the input is not changed

frames = [];
beg_time = [];
end_time = [];

for i = 1:numel(reps)
    n_frames = size(frames, 1);
    n_new_frames = size(reps{i}.frames, 1);

    frames(n_frames+1:n_frames+n_new_frames, :) = reps{i}.frames;
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

