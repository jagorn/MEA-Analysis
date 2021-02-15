function features = generateStandardFeatureVec(psths, tstas, rf_areas)

norm_psth = psths ./ max(psths, [], 2);
norm_tsta = normalizeTemporalSTA(tstas);
norm_areas = rf_areas / max(rf_areas);
features = [norm_psth, norm_tsta, norm_areas];
