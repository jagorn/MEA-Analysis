function cell_N = findOldCell(exp_id, cell_id)

load(strcat('/home/fran_tr/Projects/MEA_CLUSTERING/Datasets/', exp_id, 'Matrix.mat'))
cell_N = cellsTable(cell_id).N;