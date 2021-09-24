clear
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat', 'mosaicsTable', 'cellsTable')

for i = 1:numel(mosaicsTable)
    idx1 = mosaicsTable(i).indices;
    idx2 = mosaicsTable(i).controlIndices;
    idx3 = mosaicsTable(i).modelIndices;

    [unique([cellsTable(idx1).experiment]) unique([cellsTable(idx2).experiment]) unique([cellsTable(idx3).experiment])]
end
