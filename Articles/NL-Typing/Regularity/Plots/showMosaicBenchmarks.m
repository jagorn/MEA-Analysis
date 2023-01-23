function showMosaicBenchmarks(rfs, mosaics, regularities, roi)
for i_r = 1:numel(regularities)
    
    r = regularities(i_r);
    m = mosaics(i_r);
    m_rfs = rfs(m.idx);
    [somas_x, somas_y] = centroid(m_rfs);
    m_somas =  [somas_x; somas_y]';
    
    mat_name = strcat('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Regularity/_benchmarks/', m.id, '.mat');
    load(mat_name, 'benchmark_regularity');
    
    showBenchmarkedMosaic(m_somas, roi, r, benchmark_regularity);
    if m.ks_validated
        title_color = [0.1 0.6 0.1];
        sub_folder = 'good/';
    else
        title_color = [0.6 0.1 0.1];
        sub_folder = 'bad/';
    end
    try
        sgtitle(strcat(num2str(i_r), ": ", m.Label, "-", m.id), "Interpreter", "none", "Color", title_color);
    catch
        sgtitle(strcat(num2str(i_r), ": ", m.id), "Interpreter", "none", "Color", title_color);
    end
    fullScreen();
    fig_name = strcat("/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Regularity/_plots/", sub_folder, m.id, '.png');
    %     saveas(gcf, fig_name);
    waitforbuttonpress();
    close all;
end