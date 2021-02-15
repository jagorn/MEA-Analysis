function tSta = extractTemporalSta(sta, xEll, yEll)

% Extract tempor
[dim_x, dim_y, ~] = size(sta);

tSta_polygon = [];
for xi = 1:dim_x
    for yi = 1:dim_y
        if inpolygon(xi, yi, yEll, xEll)
            tSta_polygon = [tSta_polygon, squeeze(sta(xi, yi, :))];
        end
    end
end
tSta = mean(tSta_polygon, 2);
