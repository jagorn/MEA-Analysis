function mcc = mcc_score(truth_set, model_set)

true_pos = sum(and(truth_set, model_set));
true_neg = sum(and(~truth_set, ~model_set));

false_pos = sum(and(~truth_set, model_set));
false_neg = sum(and(truth_set, ~model_set));

mcc_num = true_pos * true_neg - false_pos * false_neg;
mcc_den = sqrt((true_pos + false_pos)*(true_pos + false_neg)*(true_neg + false_pos)*(true_neg + false_neg));
mcc = mcc_num / mcc_den;


