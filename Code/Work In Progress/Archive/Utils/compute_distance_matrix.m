clear
close all

load(getDatasetMat(), "PCAs");
n_cells = numel(PCAs);
n_features = numel(PCAs(1).lvl1);

% Build the distance matrix as euclidean distances in the PCA space
features = reshape([PCAs.lvl1], [n_features, n_cells]).';
distances = zeros(n_cells, n_cells);
for i_cell = 1:n_cells
    for j_cell = 1:n_cells
        distances(i_cell, j_cell)  = sqrt(sum((features(i_cell, :) - features(j_cell, :)).^ 2));
    end
end

load(getDatasetMat(), "classesTable");
n_classes = numel(classesTable);

classes = [classesTable.name];
classes_starting_indices = [];

all_indices = [];
count_indices = 0;
for i_class = 1:n_classes
    indices = find(classesTable(i_class).indices);
    all_indices = [all_indices, indices];
    classes_starting_indices = [classes_starting_indices, count_indices];
    count_indices = count_indices + length(indices);
end

distances_by_classes = distances(all_indices, all_indices);
imagesc(distances_by_classes);
yticks(classes_starting_indices);
yticklabels(classes);
xticks([]);