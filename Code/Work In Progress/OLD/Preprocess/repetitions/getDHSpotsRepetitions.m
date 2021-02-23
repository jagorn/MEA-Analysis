function [zeros, single, multi, test, everything] = getDHSpotsRepetitions(dhTimes_init, dhTimes_end, dh_frames_mat)

load(dh_frames_mat, 'TotalBlock', 'BlockSign');
[frames, sequence2frames, order] = unique(TotalBlock', 'rows');

zero_sequences = sum(logical(TotalBlock) > 0, 1) == 0;
single_sequences = sum(logical(TotalBlock) > 0, 1) == 1;
others_sequences = sum(logical(TotalBlock) > 0, 1) > 1;

zero_idx = zero_sequences(sequence2frames);
single_idx = single_sequences(sequence2frames);

others_idx = others_sequences(sequence2frames);
multi_idx = ~BlockSign(sequence2frames)' & others_idx;
test_idx = BlockSign(sequence2frames)' & others_idx;


assert(length(dhTimes_init) == length(dhTimes_end));
assert(length(dhTimes_init) <= length(order));

if(length(dhTimes_init) < length(order))
    fprintf('\tWARNING: %i triggers expected, but only %i were found\n', length(order), length(dhTimes_init));
end

everything.rep_begin = cell(1, max(order));
everything.rep_end = cell(1, max(order));
everything.frames = frames;

for t = 1:length(dhTimes_init)
    frame_id = order(t);
    everything.rep_begin{frame_id} = [everything.rep_begin{frame_id} dhTimes_init(t)];
    everything.rep_end{frame_id} = [everything.rep_end{frame_id} dhTimes_end(t)];
end

zeros.rep_begin = everything.rep_begin(zero_idx);
zeros.rep_end = everything.rep_end(zero_idx);
zeros.frames = frames(zero_idx, :);

single.rep_begin = everything.rep_begin(single_idx);
single.rep_end = everything.rep_end(single_idx);
single.frames = frames(single_idx, :);

multi.rep_begin = everything.rep_begin(multi_idx);
multi.rep_end = everything.rep_end(multi_idx);
multi.frames = frames(multi_idx, :);

test.rep_begin = everything.rep_begin(test_idx);
test.rep_end = everything.rep_end(test_idx);
test.frames = frames(test_idx, :);