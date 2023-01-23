function [checks, rep_begin, rep_end] = getCheckerboardStim(exp_file, mea_rate, effective_rate)

% Load Variables
load(exp_file, 'rep_begin', 'rep_end');
n_checkerboard_blocks = 1;  % this returns only the returned part of the checkerboard
[checks, frame_rate] = getCheckerboardMat(n_checkerboard_blocks);
[n_rows, n_cols, n_steps] = size(checks);

% Time series and resampling
if frame_rate ~= effective_rate
    checks_x = 1/frame_rate: 1/frame_rate : numel(n_steps)/frame_rate;
    checks_ts = timeseries(checks, checks_x, 'Name', 'checkerboard');

    effective_x = 1/effective_rate : 1/effective_rate : n_steps/frame_rate;
    checks_ts = resample(checks_ts, effective_x);
    checks = checks_ts.Data;
end