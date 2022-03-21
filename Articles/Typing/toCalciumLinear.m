function calcium_trace = toCalciumLinear(time_sequence, spike_train)

% load('calcium_conversion.mat', 'calcium_tau');
% calcium_filter = exp(-time_sequence / calcium_tau);


load('calcium_conversion.mat', 'calcium_exp');
calcium_filter = calcium_exp(time_sequence);


calcium_trace = conv(spike_train, calcium_filter, 'full');




