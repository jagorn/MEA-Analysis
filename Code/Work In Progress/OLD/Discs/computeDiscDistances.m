img_id = 1;
exp_id = getExpId();

loadDataset();

H1 = getHomography('dmd', 'img');
H2 = getHomography(['img' num2str(img_id)], 'mea', exp_id);

discs.overlaps = zeros(numel(spatialSTAs), numel(discs_reps));
discs.distances = zeros(numel(spatialSTAs), numel(discs_reps));


% figure();

    
for i_cell = 1:numel(spatialSTAs)
    rf = spatialSTAs(i_cell);
    rf.Vertices = transformPointsV(H2*H1, rf.Vertices);    
    [x, y] = boundary(rf);
    [cx, cy] = centroid(rf);
    
    for i_disc = 1:numel(discs_reps)
        x_disc = discs_reps(i_disc).center_x_mea;
        y_disc = discs_reps(i_disc).center_y_mea;
        r_disc = discs_reps(i_disc).diameter/2;
        id_disc = discs_reps(i_disc).id;

        th = 0:pi/50:2*pi;
        xunit = r_disc * cos(th) + x_disc;
        yunit = r_disc * sin(th) + y_disc;
        disc = polyshape(xunit(1:end-1),yunit(1:end-1));
        
        distance = [cx, cy; x_disc, y_disc];
        intersection = intersect(disc, rf);
        overlap = area(intersection) / area(rf);
        
%         plot([x_disc, cx], [y_disc, cy])
%         hold on
%         plot(rf)
%         plot(disc)
%         plot(intersection)
        
        if overlap > 0
            overlap_segment = intersect(intersection, distance);
%             plot(overlap_segment(:, 1), overlap_segment(:, 2), 'r');
            if isempty(overlap_segment)
                distance = 0;
            else
                distance = -norm(overlap_segment(1, :) - overlap_segment(2, :));
            end
        else
            [~, out_from_disc] = intersect(disc, distance);
            [~, outer_segment] = intersect(rf, out_from_disc);
%             plot(outer_segment(:, 1), outer_segment(:, 2), 'g');
            distance = norm(outer_segment(1, :) - outer_segment(2, :));
        end
        
        discs.overlaps(i_cell, i_disc) = overlap;
        discs.distances(i_cell, i_disc) = distance;
        
%         title(['cell#' num2str(i_cell) ' disc#' id_disc ' dist = ' num2str(distance) 'um, overlap = ' num2str(overlap) ])
        
%         waitforbuttonpress
%         hold off;

        
    end
end

save(getDatasetMat, 'discs', '-append');