load(getDatasetMat, 'classesTableNotPruned', 'experiments');
load(getDatasetMat, 'spatialSTAs', 'stas');
[h, w, ~] = size(stas{1});
n_cells = numel(stas);

n_surrogates = 1000;
classes = [classesTableNotPruned.name];
exps = [experiments{:}];

mosaicNNNDs = cell(length(classes), length(exps));
moisaicMap = cell(length(classes), length(exps));
nullNNNDs = cell(1, length(exps));
nullCoverage = cell(1, length(exps));
nullMosaic = cell(1, length(exps));

for i_exp = 1:length(exps)
    exp_id = exps(i_exp);
    exp_idx = expIndices(exp_id);    
    exp_idx_uniques = filterDuplicates(exp_idx);
    exp_rfs_uniques = spatialSTAs(exp_idx_uniques);
    exp_mask = computeMosaicMask(exp_rfs_uniques, w, h);

    parfor i_class = 1:length(classes)    
        class_id = classes(i_class);
        idx = classExpIndices(class_id, exp_id);
        [idx_uniques, ~] = filterDuplicates(idx);
        rfs = spatialSTAs(idx_uniques);

        mosaicNNNDs{i_class, i_exp} = computeNNNDs(rfs);
        moisaicMap{i_class, i_exp} = computeMosaicCoverage(exp_mask, rfs);
    end
    
    % for each class, there must be a null distribution NNNDs of same size
    for i_class = 1:length(classes)    
                
        % evaluate the size of the class
        class_id = classes(i_class);        
        idx = classExpIndices(class_id, exp_id);
        [idx_uniques, ~] = filterDuplicates(idx);
        
        % add the surrogate NNNDs only if it does not exist yet.
        n_rfs = sum(idx_uniques);
        if n_rfs > 1 && ...
                (size(nullNNNDs, 1) < n_rfs || ...
                isempty(nullNNNDs{n_rfs, i_exp}))
            
            nullNNNDs{n_rfs, i_exp} = zeros(n_surrogates, n_rfs);
            nullCoverage{n_rfs, i_exp} = zeros(n_surrogates, h, w);
            nullMosaic{n_rfs, i_exp} = boolean(zeros(n_surrogates, n_cells));
                
            for i_surrogate = 1:n_surrogates
                idx_mosaic = generateRandomMosaic(n_rfs, exp_idx_uniques);
                rfs = spatialSTAs(idx_mosaic);

                nullNNNDs{n_rfs, i_exp}(i_surrogate, :) = computeNNNDs(rfs);
                nullCoverage{n_rfs, i_exp}(i_surrogate, :, :) = computeMosaicCoverage(exp_mask, rfs);
                nullMosaic{n_rfs, i_exp}(i_surrogate, :) = idx_mosaic;
            end
        end
    end
end
save(getDatasetMat, 'mosaicNNNDs', 'moisaicMap', '-append');
save(getDatasetMat, 'nullNNNDs', 'nullCoverage', 'nullMosaic', '-append');
