function y_labels = yPatternLabels(patterns, mode)
% mode = 0: empty labels
% mode = 1: only spot ids
% mode = 2: spots ids and intensities

if mode <= 0
    y_labels = string();
else
    n_patterns = size(patterns, 1);
    y_labels = strings(1, n_patterns);
    for i_pattern = 1:n_patterns
        p = patterns(i_pattern, :);
        p_elements = find(p);
        
        if mode == 1
            y_labels(i_pattern) = mat2str(p_elements);
        else
            p_strengths = p(p_elements);
            if range(p_strengths) == 0
                p_strengths = p_strengths(1);
            end
            y_labels(i_pattern) = strcat(mat2str(p_elements), "   ", mat2str(p_strengths, 3)) ;
        end
    end
end