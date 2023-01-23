function [temporal, spatial, rfs, indices] = decomposeSTA(stas, varargin)

do_smoothing_def = false;
do_plots_def = false;
remove_surround_def = false;

% Parse Input
p = inputParser;
addRequired(p, 'stas');
addParameter(p, 'Do_Smoothing', do_smoothing_def);
addParameter(p, 'Remove_Surround', remove_surround_def);
addParameter(p, 'Do_Plots', do_plots_def);
parse(p, stas, varargin{:});
do_smoothing = p.Results.Do_Smoothing;
do_plots = p.Results.Do_Plots;
remove_surround = p.Results.Remove_Surround;

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
            cell_sta = smoothSta(sta);
        else
            cell_sta = sta;
        end
        
        if remove_surround
            median_sta = median(cell_sta(:));
            max_sta = max(cell_sta(:)) - median_sta;
            min_sta = min(cell_sta(:)) - median_sta;
            
            if abs(max_sta) > abs(min_sta)
                frame_for_fitting = max(cell_sta, [], 3);
            else
                frame_for_fitting = min(cell_sta, [], 3);
            end
        else
            frame_for_fitting = std(cell_sta, [], 3);
        end
        spatial(i, :, :) = frame_for_fitting;
        
        % plot
        if do_plots
            imagesc(frame_for_fitting);
            waitforbuttonpress();
        end
        
        % Fit The ellipses
        try
            [xEll, yEll, ~, ~] =  fitEllipse(frame_for_fitting);
            [is_valid, ~] = validateEllipse(xEll, yEll, frame_for_fitting);
        catch
            continue;
        end
        
%         if is_valid
        try
            temporal(i, :) = extractTemporalSta(sta, xEll, yEll);
            rfs(i) = polyshape(xEll, yEll);
            is_good_sta(i) = true;
        end
    end
end
indices = find(is_good_sta);







