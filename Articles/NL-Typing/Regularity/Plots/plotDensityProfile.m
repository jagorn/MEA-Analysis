function plotDensityProfile(er, benchmark)

if exist('benchmark', 'var')
    bi_bins = benchmark(1).er.density_profile_radii;
    bi_histo = zeros(size(benchmark(1).er.density_profile));
    for i_b = 1:numel(benchmark)
        b_plus = benchmark(i_b).er.density_profile;
        b_plus(isnan(b_plus)) = 0;
        bi_histo = bi_histo + b_plus;
    end
    bi_histo = bi_histo / numel(benchmark);
    
    y_stair = [0; bi_histo; 0];
    x_stair = [0, 0, bi_bins];
    defined_values = ~isnan(y_stair);

    [x, y] = stairs(x_stair(defined_values), y_stair(defined_values));
    fill(x, y, [0.7, 0.7, 0.7], 'FaceAlpha', 0.6, 'EdgeColor', 'None');
end


hold on
[x, y] = stairs([0, 0, er.density_profile_radii], [0; er.density_profile; 0]);
fill(x, y, [0.1, 0.1, 0.6], 'FaceAlpha', 0.6, 'EdgeColor', 'None');

yline(er.expected_density, 'k--')
xline(er.maximum_radius, 'b:' , 'M.R.', 'LabelVerticalAlignment', 'top')
try
    xline(er.dip_radius, 'g:' , 'D.R.', 'LabelVerticalAlignment', 'middle')
    xline(er.effective_radius, 'r:' , 'E.R.', 'LabelVerticalAlignment', 'bottom')
end
xlabel('Radius [\mum]');
ylabel('Density Profile  [\mum^{-2}]');