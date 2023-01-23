function er = computeDensityProfile(somas, roi_max_coords, d_bin, d_max, debug)

if ~exist('debug', 'var')
    debug = false;
end

offset = 0;
roi_rectange = [-offset,                    -offset; ...
                -offset,                    offset + roi_max_coords(2); ...
                offset + roi_max_coords(1), offset + roi_max_coords(2); ...
                offset + roi_max_coords(1), -offset];

roi = polyshape(roi_rectange);
radii = d_bin:d_bin:d_max;
n_circles = numel(radii);
n_cells = size(somas, 1);

expected_density = n_cells / area(roi);

% Create all the concentric regions to compute the density profile
circles = repmat(polyshape, [n_circles, 1]);

for i_circle = 1:n_circles
    r = radii(i_circle);
    t=linspace(0, 360, 1000).';
    t(end)=[];
    circles(i_circle) = polyshape([cosd(t), sind(t)]*r);
end

all_points = [];
sections_area = zeros(n_circles, 1);
sections_points = zeros(n_circles, 1);

if debug
    f = figure;
end

for i_cell = 1:n_cells
    
    
    soma_center =  somas(i_cell, :);
    
    other_cells = somas([1:(i_cell-1), (i_cell+1):end], :);
    other_cells_relative = other_cells - soma_center;
    
    % Register all relative positions (just for plotting)
    all_points = [all_points; other_cells_relative];
    
    if debug
        figure(f)
        hold off;
        plot(roi, 'FaceColor', 'None');
        hold on;
        scatter(soma_center(1), soma_center(2), 25, 'red', 'Filled');
        scatter(other_cells(:, 1), other_cells(:, 2), 25, 'blue', 'Filled');
        daspect([1 1 1]);
        x_offset = (roi_rectange(3) - roi_rectange(1)) / 20;
        y_offset = (roi_rectange(4) - roi_rectange(2)) / 20;
        xlim([roi_rectange(1) - x_offset, roi_rectange(3) + x_offset])
        ylim([roi_rectange(2) - y_offset, roi_rectange(4) + y_offset])
        fprintf("\n New Point.\n");
        
    end
    
    % Compute the concentric sections
    for i_circle = 1:n_circles
        soma_circle = circles(i_circle);
        soma_circle.Vertices = soma_circle.Vertices + soma_center;
        
        if i_circle > 1
            section = subtract(soma_circle, inner_section);
        else
            section = soma_circle;
        end
        section = intersect(section,roi);
        section_area = area(section);
        try
            section_points = inpolygon(other_cells(:, 1), other_cells(:, 2), section.Vertices(:, 1), section.Vertices(:, 2));
            sections_area(i_circle) = sections_area(i_circle) + section_area;
            sections_points(i_circle) = sections_points(i_circle) + sum(section_points);
        end
        inner_section = soma_circle;
        
        if debug
            plot(section);
            fprintf("points: %i, surface: %f\n", sum(section_points), section_area);
            waitforbuttonpress();
        end
    end
end

er.expected_density = expected_density;
er.sections = circles;
er.points = all_points;
er.sections_points = sections_points;
er.sections_area = sections_area;
er.density_profile = sections_points ./ sections_area;
er.density_profile_radii = radii;

% Compute the radius of the dip.
dip_bins = er.density_profile < expected_density;

% Initialize the radius of the dip to the max possible value.
dip_i_radius = n_circles;

% If there is no dip at all, then the radius is equal to 0;
if dip_bins(1) == false
    dip_i_radius = 0;
    er.maximum_radius = 0;
else
    % Otherwise, look for the dip edge and assign the corresponding bin.
    for i_bin = 1:n_circles
        if dip_bins(i_bin) == false
            dip_i_radius = i_bin -1;
            break;
        end
    end
    er.dip_radius = radii(dip_i_radius);
end

% Now compute the volume of the dip
volume_dip = 0;
for i_dip = 1:dip_i_radius
    if i_dip == 1
        area_section = area(circles(i_dip));
    else
        area_section = area(circles(i_dip)) - area(circles(i_dip - 1));
    end
    volume_dip = volume_dip + area_section * (expected_density - er.density_profile(i_dip));
end

% Now compute the effective radius
er.effective_radius = sqrt(volume_dip / (pi * expected_density));

% And the packing factor
er.maximum_radius = sqrt( sqrt(4/3) / expected_density );
er.packing_factor =  (er.effective_radius / er.maximum_radius)^2;
