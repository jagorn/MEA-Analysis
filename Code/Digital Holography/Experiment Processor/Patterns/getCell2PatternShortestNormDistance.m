function [norm_distance_matrix, valid] = getCell2PatternShortestNormDistance(exp_id, section_id)

[distance_matrix, valid_distances] = getCell2PatternShortestDistances(exp_id, section_id);
[center, radius, vertices, surface, valid_stas] = getMEASTAs(exp_id);
norm_distance_matrix = distance_matrix ./ radius;
valid = intersect(valid_distances, valid_stas);


