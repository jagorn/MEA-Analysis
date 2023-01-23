function plotRFCoverage(ci)

    figure();
    subplot(1, 2, 1);
    imagesc(ci.mask + (ci.simple_cov == 1))
    hold on;
    
    for rf = ci.rfs
        plot(rf, 'FaceColor', 'None', 'EdgeColor', 'r');
    end
    
    title(strcat("Coverage Index: ", num2str(ci.simple_ci), ", Scaling = ", num2str(1)));
    daspect([1 1 1]);
    xlabel('Distance [\mum]');
    ylabel('Distance [\mum]');
    
    subplot(1, 2, 2);
    imagesc(ci.mask + (ci.coverage == 1))
    hold on;
    
    for rf = ci.rfs_opt
        plot(rf, 'FaceColor', 'None', 'EdgeColor', 'r');
    end

    title(strcat("Coverage Index: ", num2str(ci.cov_index), ", Scaling = ", num2str(ci.scaling)));
    daspect([1 1 1]);
    xlabel('Distance [\mum]');
    ylabel('Distance [\mum]');