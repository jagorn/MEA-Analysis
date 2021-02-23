function [rep_begin_time_20khz, rep_end_time_20khz] = getCheckerboardRepetitions(stimTimes, checkerboard_mat)
load(checkerboard_mat, 'block_size')

% this works for 20khz sampling 
rep_begin_time_20khz = stimTimes(block_size+1 : block_size*2 : end);
rep_end_time_20khz = stimTimes(block_size*2 : block_size*2 : end);
rep_begin_time_20khz = rep_begin_time_20khz(1 : length(rep_end_time_20khz));
