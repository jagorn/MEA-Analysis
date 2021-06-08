function setHolographyPSTHs(exp_id, holographyPSTHs)
holo_psth_file = fullfile(holoPath(exp_id), 'holographyPSTHs.mat');
save(holo_psth_file, 'holographyPSTHs');
