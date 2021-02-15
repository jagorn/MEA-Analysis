function [temporal, spatial, rfs, indices] = decomposeSTA(stas, varargin)

do_smoothing_def = false;
do_plots_def = false;

% Parse Input
p = inputParser;
addRequired(p, 'stas');
addParameter(p, 'Do_Smoothing', do_smoothing_def);
addParameter(p, 'Do_Plots', do_plots_def);
parse(p, stas, varargin{:});
do_smoothing = p.Results.Do_Smoothing;
do_plots = p.Results.Do_Plots;

[n_rows, n_cols, n_steps] = size(stas{1});
n_cells = numel(stas);

temporal = zeros(n_cells, n_steps);
spatial = zeros(n_cells, n_rows, n_cols);
rfs(n_cells) = polyshape();
is_good_sta = false(n_cells, 1);


for i=1:length(stas)
    sta = stas{i};
    
    if sum(sta(:)) ~= 0
        
        % filter the sta to remove some noise
        if do_smoothing
            spatial_sta = std(smoothSta(sta), [], 3);
        else
            spatial_sta = std(sta, [], 3);
        end
        spatial(i, :, :) = spatial_sta;
        
        % plot
        if do_plots
            imagesc(spatial_sta);
            waitforbuttonpress();
        end

        % Fit The ellipses
        [xEll, yEll, ~, ~] =  fitEllipse(spatial_sta);
        [is_valid, ~] = validateEllipse(xEll, yEll, spatial_sta);
        
        
        if is_valid
            is_good_sta(i) = true;
            temporal(i, :) = extractTemporalSta(sta, xEll, yEll);
            rfs(i) = polyshape(xEll, yEll);
        end
    end
end
indices = find(is_good_sta);







