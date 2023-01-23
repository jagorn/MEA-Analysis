function plotRI(ri, benchmark)

if isfield(ri, 'distances')
    mean_v = mean(ri.distances);
    color = [0.6, 0.1, 0.1];
    y_label = "NN Counts";
    x_label = 'Distance [\mum]';
else
    color = [0.1, 0.6, 0.1];
    mean_v = mean(ri.areas);
    y_label = "Voronoi Cell Counts";
    x_label = 'Area [\mum^{-2}]';
end
if isnan(mean_v)
    return
end

hold on

if exist('benchmark', 'var')
    
    bi_nnri = [benchmark.nnri];
    bi_bins = bi_nnri(1).bins;
    
    bi_histo = zeros(size(bi_nnri(1).histo));
    for i = 1:numel(bi_nnri)
        bi_histo = bi_histo + bi_nnri(i).histo;
    end
    bi_histo = bi_histo / numel(bi_nnri);
    
    [x, y] = stairs([0 bi_bins], [0 bi_histo 0]);
    fill(x, y, [0.7, 0.7, 0.7], 'FaceAlpha', 0.6, 'EdgeColor', 'None');
end


[x, y] = stairs([0 ri.bins], [0 ri.histo 0]);
fill(x, y, color, 'FaceAlpha', 0.6, 'EdgeColor', 'None');

xline(mean_v, 'k:' , 'Mean')
xlabel(x_label);
ylabel(y_label);
text(0.5, 0.5, strcat("RI = ", num2str(ri.ri)));