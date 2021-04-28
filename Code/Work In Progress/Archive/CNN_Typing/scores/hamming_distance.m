function distance = hamming_distance(truth_set, model_set)
    distance  = sum(abs(truth_set - model_set));



