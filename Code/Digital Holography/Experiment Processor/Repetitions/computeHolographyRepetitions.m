function everything = computeHolographyRepetitions(dh_times_init, dh_times_end, holography_total_block, holography_block_type)

[patterns, sequence2pattern, sequence] = unique(holography_total_block', 'rows');
training_set = ~holography_block_type(sequence2pattern);
testing_set = holography_block_type(sequence2pattern);

% Errors and warnings
if length(dh_times_init) ~= length(dh_times_end)
    error_struct.message = strcat("Mismatch between the number of trigger onsets and offsets for holographic stimulation");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if length(dh_times_init) > length(sequence)
    error_struct.message = strcat("Triggers are expected to be ", num2str(length(sequence)), " but ", num2str(length(dh_times_init)), " were found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

if(length(dh_times_init) < length(sequence))
    fprintf('\tWARNING: %i triggers expected, but only %i were found\n', length(sequence), length(dh_times_init));
end

everything.rep_begin = cell(1, max(sequence));
everything.durations = cell(1, max(sequence));
everything.patterns = patterns;

for t = 1:length(dh_times_init)
    frame_id = sequence(t);
    everything.rep_begin{frame_id} = [everything.rep_begin{frame_id} dh_times_init(t)];
    everything.rep_end{frame_id} = [everything.rep_end{frame_id} dh_times_end(t)];
end