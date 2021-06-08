function repetitions = computeHolographyRepetitions(dh_times_init, dh_durations, holography_total_block, holography_block_type)

set_types = ["train", "test"];  % 0 = training set, 1 = testing set
[patterns, sequence2pattern, sequence] = unique(holography_total_block', 'rows');
n_patterns = numel(sequence2pattern);


% Errors and warnings
if length(dh_times_init) ~= length(dh_durations)
    error_struct.message = strcat("Mismatch between the number of triggers amd durations for holographic stimulation");
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

repetitions.patterns = patterns;
repetitions.durations = zeros(n_patterns, 1);
repetitions.rep_begins = cell(n_patterns, 1);
repetitions.set_type = strings(n_patterns, 1);

for p = 1:n_patterns
    p_idx = sequence == p;
    
    if any(p_idx)
           
        rep_begins = dh_times_init(p_idx);
        durations = dh_durations(p_idx);
        sets = set_types(holography_block_type(p_idx) + 1);

        % make sure durations are all the same
        delta_durations = abs(durations - durations(1)) / durations(1);
        if any (delta_durations > 0.02)
            max_offset = max(abs(durations - durations(1)));
            warning(strcat("Duration of holographic pattern is not consistent across repetitions (", num2str(max_offset), " time_steps of difference)"));
        end

        % make sure pattern is only test or only training set are all the same
        if ~all(strcmp(sets(1), sets))
            error_struct.message = strcat("Inconsistent training/testing set in holographic patterns");
            error_struct.identifier = strcat('MEA_Analysis:', mfilename);
            error(error_struct);
        end
        
        duration = median(durations);
        set = sets(1);

        repetitions.durations(p) = duration;
        repetitions.rep_begins{p} = rep_begins;
        repetitions.set_type(p) = set;
    end
end