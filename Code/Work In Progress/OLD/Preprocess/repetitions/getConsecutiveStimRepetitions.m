function [rep_begin, rep_end, rep_dt] = getConsecutiveStimRepetitions(evtTimes, stim_n_steps)

rep_begin = evtTimes(1 : stim_n_steps : end);
rep_end = evtTimes(stim_n_steps : stim_n_steps : end);
rep_begin = rep_begin(1 : length(rep_end));
rep_dt = median(rep_end - rep_begin);