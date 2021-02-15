function snr = doSNR(traces, r_dim, t_dim)
% A function to compute the signal-to-noise ratio of a set of traces.
% traces: 2d [n_repetitions x n_time_steps] matrix

if ~exist('r_dim', 'var')
    r_dim = 1;
end
if ~exist('t_dim', 'var')
    t_dim = 2;
end

num_ =  std(mean(traces, r_dim), 0, t_dim);
den_ =  mean(std(traces, 0, t_dim), r_dim);
snr = num_ ./ den_;
