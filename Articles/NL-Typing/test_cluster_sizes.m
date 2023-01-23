clear;
close all;
clc;

load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/Data/mosaics_comparison.mat', 'mosaicsTable');
load('/home/fran_tr/Projects/MEA-Analysis/Thesis/Typing/typing_colors.mat', 'symbols', 'names');
load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/typing_data.mat', 'duplicate_cells', 'classesTableNotPrunedRF', 'classesTableNotPruned');

for i_symbol = 1:numel(symbols)
    name = names(i_symbol);
    symbol = symbols(i_symbol);
    mosaic_names = [mosaicsTable.class];
    mosaic_idx = strcmp(name, mosaic_names);
    mosaicsTable(mosaic_idx).symbol = symbol;
end

mosaic_symbols = [mosaicsTable.symbol];
[~, mosaic_sorted_idx] = sort(mosaic_symbols);

mosaicsTable_sorted = mosaicsTable(mosaic_sorted_idx);

my_table = {};
for i_t = 1:numel(mosaicsTable_sorted)
    
    class_CHIRP = mosaicsTable_sorted(i_t).class;
    class_RF = mosaicsTable_sorted(i_t).bestControl;
    
    classes_CHIRP = [classesTableNotPruned.name];
    classes_RF = [classesTableNotPrunedRF.name];
    
    i_class_CHIRP = strcmp(class_CHIRP, classes_CHIRP);
    i_class_RF = strcmp(class_RF, classes_RF);
    
    my_table(i_t).id = mosaicsTable_sorted(i_t).symbol;
    my_table(i_t).class_CHIRP = class_CHIRP;
    my_table(i_t).size_cluster_CHIRP = sum(classesTableNotPruned(i_class_CHIRP).indices);
    my_table(i_t).size_mosaic_CHIRP = sum(mosaicsTable_sorted(i_t).indices & ~duplicate_cells);
    my_table(i_t).class_RF = class_RF;
    my_table(i_t).size_cluster_RF = sum(classesTableNotPrunedRF(i_class_RF).indices);
    my_table(i_t).size_mosaic_RF = sum(mosaicsTable_sorted(i_t).controlIndices & ~duplicate_cells);
    my_table(i_t).mosaic_exp = mosaicsTable_sorted(i_t).experiment;
end