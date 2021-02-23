function ids_mosaic = generateRandomMosaic(n_rfs, ids_exp_uniques)

elems_exp_uniques = find(ids_exp_uniques);
n_cells_exp = length(elems_exp_uniques);
n_cells_dataset = length(ids_exp_uniques);

elems_mosaic = elems_exp_uniques(randperm(n_cells_exp, n_rfs));
ids_mosaic = boolean(zeros(1, n_cells_dataset));
ids_mosaic(elems_mosaic) = true;
