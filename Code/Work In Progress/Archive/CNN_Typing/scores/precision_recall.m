function [precision, recall, true_positives] = precision_recall(truth_set, model_set)

    true_positives = sum(and(truth_set, model_set));
    precision = true_positives / sum(model_set);
    recall = true_positives / sum(truth_set);
    



