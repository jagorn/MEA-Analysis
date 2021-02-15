function saveSTAs(exp_id, STAs, temporal, spatial, rfs, valid)
stas_file = getSTAsFile(exp_id);
save(stas_file, 'STAs', 'temporal', 'spatial', 'rfs', 'valid');