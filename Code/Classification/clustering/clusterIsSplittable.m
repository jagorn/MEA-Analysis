function isSplittable = clusterIsSplittable(indexesClass)

global cluster_split_size;
global cluster_split_psthSNR;
global cluster_split_staSNR;

global cluster_stas;
global cluster_psths;

sizeClass = length(indexesClass);

norm_psths = cluster_psths(indexesClass, :) ./ max(cluster_psths(indexesClass, :), [], 2);

snr_psth = doSNR(norm_psths);
snr_sta = doSNR(cluster_stas(indexesClass, :));

isSplittable = (sizeClass >= cluster_split_size) && ...
               ((snr_psth <= cluster_split_psthSNR) || ...
               (snr_sta <= cluster_split_staSNR));
