close all
clear

loadDataset;
classes = [classesTableNotPruned.name];
exps = [experiments{:}];

my_exp = "20180209";
my_class = "RGC.2.5.";
my_exp_idx = exps == my_exp;
my_class_idx = classes == my_class;

nnnds = mosaicNNNDs{my_class_idx, my_exp_idx};

plotClassMosaicStats(my_class, my_exp)

hnnnds = nullNNNDs{length(nnnds), my_exp_idx};
hcoverage = nullCoverage{length(nnnds), my_exp_idx};
hMosaic = nullMosaic{length(nnnds), my_exp_idx};

figure()
plotKSTest(nnnds, hnnnds);
title(strcat("KS Test ", my_class, " in ", my_exp), 'interpreter','none');


% HACK
idx = classExpIndices(my_class, my_exp);
[idx_uniques, idx_duplicates] = filterDuplicates(idx);

rfs_uniques = spatialSTAs(idx_uniques);
rfs_duplicates = spatialSTAs(idx_duplicates);
coverage = getClassCoverage(my_class, my_exp);

exp_idx = expIndices(my_exp);    
exp_idx_uniques = filterDuplicates(exp_idx);

% add the surrogate NNNDs only if it does not exist yet.
n_rfs = sum(idx_uniques);

n_surrogates = 1000;
hack_null_NNNDS = zeros(n_surrogates, n_rfs);
for i_surrogate = 1:n_surrogates
    i_surrogate
    idx_mosaic = generateRandomMosaic(n_rfs, exp_idx_uniques);
    rfs = spatialSTAs(idx_mosaic);
    hack_null_NNNDS(i_surrogate, :) = computeNNNDs(rfs);
end
                      
[~, p2] = kstest2(nnnds(:),  hack_null_NNNDS(:));
plotMosaicStats("hack test UNEQUAL", my_exp, coverage, rfs_uniques, rfs_duplicates, nnnds, hack_null_NNNDS, p2)

[~, p2] = kstest2(nnnds(:),  hack_null_NNNDS(:), 'Tail', 'larger');
plotMosaicStats("hack test LARGER", my_exp, coverage, rfs_uniques, rfs_duplicates, nnnds, hack_null_NNNDS, p2)

[~, p2] = kstest2(nnnds(:),  hack_null_NNNDS(:), 'Tail', 'smaller');
plotMosaicStats("hack test SMALLER", my_exp, coverage, rfs_uniques, rfs_duplicates, nnnds, hack_null_NNNDS, p2)



% 
% for i = 1:4
%     [hh, hp, hk] = kstest2(hnnnds(i, :), hnnnds(:));
%     label_set = strcat("random mosaic #", string(i));
%     hcov = squeeze(hcoverage(i,:,:));
%     hn = squeeze(hnnnds(i, :));
%     hm = spatialSTAs(squeeze(hMosaic(i, :)));
%     plotMosaicStats(label_set, my_exp, hcov, hm, [], hn, hnnnds, hp)
% end


% std_nh = std(hnnnds, 0, 2);
% mean_nh = mean(hnnnds, 2); 
% 
% std_nnnds = std(nnnds); 
% mean_nnnds = mean(nnnds); 
% 
% figure()
% hold on
% scatter(mean_nh, std_nh, 10, 'k')
% scatter(mean_nnnds, std_nnnds, 25, 'r', 'filled')
% xlabel('Mean')
% ylabel('STD')