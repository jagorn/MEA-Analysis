function plotMosaics(rfs, mosaics, roi)

roi_polygon = polyshape([0, 0; 0, roi(2); roi(1), roi(2); roi(1), 0]);
figure();
for i_m = 1:numel(mosaics)
    
    
    mosaic = mosaics(i_m);
    plot(roi_polygon, 'FaceColor', 'None');
    hold on;
    plot(rfs(mosaic.idx), 'FaceColor', 'None', 'FaceAlpha', 0.7);
    title(strcat(num2str(i_m), ": ", mosaic.type, ", ", mosaic.experiment), 'Interpreter', 'None');
    daspect([1 1 1]);
    xlabel('distance [\mum]');
    ylabel('distance [\mum]');
    waitforbuttonpress();
    hold off;
end