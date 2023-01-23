function [euler, rep_start, rep_end] = getChirpStim(exp_file, mea_rate, effective_rate)

% Load Variables
load(exp_file, 'euler', 'euler_freq', 'euler_sampler_rate', 'euler_polarity_inverse');
load(exp_file, 'rep_begin', 'euler_onset_idx', 'euler_offset_idx');

if ~exist('euler_freq', 'var')
    euler_freq = euler_sampler_rate;
end

% Normalize
if euler_polarity_inverse
    euler = 256 - euler;
end
euler = euler(euler_onset_idx:euler_offset_idx);
euler = euler / max(euler);
euler = euler - 0.5;

% Repetitions
rep_start = rep_begin + euler_onset_idx / euler_freq * mea_rate;
rep_end = rep_begin + euler_offset_idx / euler_freq * mea_rate;

% Time series and resampling
if euler_freq ~= effective_rate
    euler_x = 1/euler_freq: 1/euler_freq : numel(euler)/euler_freq;
    euler_ts = timeseries(euler, euler_x, 'Name', 'chirp');
    
    effective_x = 1/effective_rate : 1/effective_rate : numel(euler)/euler_freq;
    euler_ts = resample(euler_ts, effective_x);
    euler = euler_ts.Data;
end
