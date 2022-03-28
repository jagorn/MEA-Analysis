function calcium_trace = toCalciumNL(time_sequence, spike_train)

load('calcium_conversion.mat', 'calcium_nl_polynome');

calcium_trace_linear = toCalciumLinear(time_sequence, spike_train);
calcium_trace = polyval(calcium_nl_polynome, calcium_trace_linear);