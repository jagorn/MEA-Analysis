function [rep_begin_time_20khz,rep_end_time_20khz, euler] = getEulerRepetitions(expId)

expId = char(expId);
varsPath = [dataPath() '/' expId '/processed/'];
load([varsPath 'Euler/Euler_RepetitionTimes.mat'], 'rep_begin_time_20khz', 'rep_end_time_20khz')
load(strcat(varsPath,'Euler/Euler_Stim.mat'), 'euler')