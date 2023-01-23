function roi = inferROI(rfs, debug)

if ~exist('debug', 'var')
    debug = true;
end

roi = [-250, +250; -250, +250];

if debug
    x_lim = [-525, 525];
    y_lim = [-525, 525];
    histo_bin = 25;
    
    
    [xs, ys] = centroid(rfs);
    
    figure();
    subplot(1, 2, 1);
    
    p_roi = polyshape([ roi(1), roi(2); ...
        roi(1), roi(4); ...
        roi(3), roi(4); ...
        roi(3), roi(2);]);
    plot(p_roi, 'FaceColor', 'None');
    hold on
    scatter(xs, ys, 10, 'Filled');
    xlim(x_lim);
    ylim(y_lim);
    daspect([1, 1, 1]);
    
    subplot(2, 2, 2);
    histogram(xs, x_lim(1):histo_bin:x_lim(2));
    hold on
    xline(roi(1));
    xline(roi(3));
    
    subplot(2, 2, 4);
    histogram(ys, y_lim(1):histo_bin:y_lim(2));
    hold on
    xline(roi(2));
    xline(roi(4));
    waitforbuttonpress();
end