function isAdmissible = clusterIsAdmissible(indexesClass)

global cluster_min_size;
global cluster_min_psthSNR;
global cluster_min_staSNR;

global cluster_stas;
global cluster_psths;

sizeClass = length(indexesClass);
norm_psths = cluster_psths(indexesClass, :) ./ max(cluster_psths(indexesClass, :), [], 2);
snr_psth = doSNR(norm_psths);
snr_sta = doSNR(cluster_stas(indexesClass, :));

isAdmissible = (sizeClass >= cluster_min_size) && ...
               (snr_psth >= cluster_min_psthSNR) && ...
               (snr_sta >= cluster_min_staSNR);