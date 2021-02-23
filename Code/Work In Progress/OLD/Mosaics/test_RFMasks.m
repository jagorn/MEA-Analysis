load(getDatasetMat, 'experiments')
load(getDatasetMat, 'spatialSTAs', 'stas');

figure()
[h, w, ~] = size(stas{1});
exps = [experiments{:}];

for i_exp = 1:length(exps)
    exp_id = exps(i_exp);
    exp_idx = expIndices(exp_id);    
    exp_idx_uniques = filterDuplicates(exp_idx);
    exp_rfs_uniques = spatialSTAs(exp_idx_uniques);
    exp_mask = computeMosaicMask(exp_rfs_uniques, w, h);
    
    subplot(2, 3, i_exp);
    imagesc(exp_mask);
    title(experiments{i_exp}, 'interpreter', 'none');
    axis off
end