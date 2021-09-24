function stim_chunked = cropEuler(stim, stim_sampling)

cliffs = find(diff(stim));
stepOn_sec = cliffs(1) / stim_sampling;
stepOff_sec = cliffs(2) / stim_sampling;
stepMid_sec = cliffs(3) / stim_sampling;

onStart = stepOn_sec - 0.5;
onEnd = stepOn_sec + 1;
offStart = stepOff_sec;
offEnd = stepOff_sec + 1;
midStart = stepMid_sec;
midEnd = stepMid_sec + 22.5;

stimWithTail = [stim; stim];
stim_chunked = [stim(round(onStart*stim_sampling) : round(onEnd*stim_sampling)); stim(round(offStart*stim_sampling) : round(offEnd*stim_sampling)); stimWithTail(round(midStart*stim_sampling) : round(midEnd*stim_sampling))];

