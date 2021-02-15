function compute_waiting_spk(treated,stim,waiting_spk,nlevel,IS,checkerboard)
%RESEARCH_STIM_TIME Summary of this function goes here
%   Detailed explanation goes here

% nlevel must be smaller than waiting_spk.Nlevels

if nlevel < waiting_spk.Nlevels 
   treat_time_array(treated,stim,waiting_spk.times{nlevel}.table(1:waiting_spk.times{nlevel}.index),waiting_spk.cells{nlevel}.table(1:waiting_spk.cells{nlevel}.index),waiting_spk,nlevel+1,IS,checkerboard);
   waiting_spk.times{nlevel}.index=0;
   waiting_spk.cells{nlevel}.index=0; 
   
   %////delete elments that have been treated     
else  %/////Test this part
    times = waiting_spk.times{nlevel}.table(1:waiting_spk.times{nlevel}.index);
    cells = waiting_spk.cells{nlevel}.table(1:waiting_spk.cells{nlevel}.index);
    waiting_spk.times{nlevel}.index=0;   %/////Test this part
    waiting_spk.cells{nlevel}.index=0; 
    treat_time_array(treated,stim,times,cells,waiting_spk,nlevel,IS,checkerboard);
end

end

