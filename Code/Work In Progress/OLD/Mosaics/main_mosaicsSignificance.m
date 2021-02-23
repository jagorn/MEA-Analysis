load(getDatasetMat, 'classesTableNotPruned', 'experiments');
classes = [classesTableNotPruned.name];
exps = [experiments{:}];

mosaicSignificances = boolean(zeros(length(classes), length(exps)));
mosaicPValues = ones(length(classes), length(exps));

for i_exp = 1:length(exps)
    exp_id = exps(i_exp);

    parfor i_class = 1:length(classes)    
        class_id = classes(i_class);
        
        [nnnds, null_nnnds] = getClassNNNDs(class_id, exp_id);
        assert(size(nnnds, 2) == size(null_nnnds, 2));
        if isempty(nnnds)
                    mosaicSignificances(i_class, i_exp) = false;
                    mosaicPValues(i_class, i_exp) = NaN;
        else
            [h, p] = kstest2(nnnds(:),  null_nnnds(:), 'Tail', 'smaller');
            mosaicSignificances(i_class, i_exp) = h;
            mosaicPValues(i_class, i_exp) = p;
        end
    end
end

save(getDatasetMat, 'mosaicSignificances', 'mosaicPValues', '-append');