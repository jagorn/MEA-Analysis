clear
close all

for cell_id = [1 2 3 5]
    
    open(strcat('Inhibition_black#', num2str(cell_id), '.fig'));
    
    subplot(3, 3, [1 2 4 5]);
    
    % Load STAs
    load('/home/fran_tr/Projects/MEA_Analysis/Scripts/20201117_gtacrMatrix.mat', 'stas', 'spatialSTAs')
    t_sta = squeeze(std(stas{cell_id}, [], 3));
    t_sta = t_sta -min(t_sta(:));
    t_sta = t_sta / max(t_sta(:));
    
    rf = spatialSTAs(cell_id);
    
    % Load Points
    load('/home/fran_tr/Projects/MEA_Analysis/Scripts/20201117_gtacrMatrix.mat', 'black_inhibition', 'white_inhibition', 'dh_effect', 'classesTable');
    dh_mat = fullfile('/home/fran_tr/Data/20201117_gtacr/processed', 'DH', 'DHCoords_only.mat');
    load(dh_mat, 'PatternCoords_Img');
    
    % Load Disc
    bin_file = fullfile("/home/fran_tr/Projects/MEA_Analysis/Stimuli/discdelay", 'bin_files', 'SpotsNewDiscDelay.bin');
    disc_image = extractFrameBin(bin_file, 2, true);
    disc_image = disc_image - min(disc_image(:));
    disc_image = disc_image/max(disc_image(:));
    
    % Load Images
    img_path_10x = fullfile("/home/fran_tr/Projects/MEA_Analysis/Code/Homographies/Images", 'camera_center_x10.jpg');
    camera_img_10x = double(imread(img_path_10x));
    camera_img_10x = camera_img_10x / max(camera_img_10x(:));
    
    % Load Homographies
    HDMD_2_Camera = getHomography('DMD', 'CAMERA');
    Hx10_2_MEA = getHomography('CAMERA_X10', 'MEA');
    Hx40_surround_2_MEA = getHomography('CAMERA_surround', 'MEA', '20201117_gtacr');
    HChecker_2_DMD = getHomography('CHECKER20', 'DMD');
    
    % Compose Homographies
    HDMD_2_MEA_Surround = Hx40_surround_2_MEA * HDMD_2_Camera;
    HChecker_2_MEA = Hx10_2_MEA * HDMD_2_Camera * HChecker_2_DMD;
    
    % Transform Points
    mea_dh_spots = transformPointsV(Hx40_surround_2_MEA, PatternCoords_Img);
    
    % Transform Images
    [mea_img_x10, ref_mea_x10] = transformImage(Hx10_2_MEA, camera_img_10x);
    
    % Transform Disc
    [mea_disc, ref_mea_disc] = transformImage(HDMD_2_MEA_Surround, disc_image);
    
    % Transform Checkerboard
    [mea_checker, ref_mea_checker] = transformImage(HChecker_2_MEA, t_sta);
    rf.Vertices = transformPointsV(HChecker_2_MEA, rf.Vertices);
    
    % Add colors and opacity
    mea_img_x40_color = cat(3, mea_img_x10*0.8, mea_img_x10*0.8, mea_img_x10);
    mea_checker_color = cat(3, mea_checker, mea_checker, ones(size(mea_checker))*0.4);
    mea_disc_color = cat(3, mea_disc, mea_disc, mea_disc);
    
    % Plot
    imshow(mea_img_x40_color, ref_mea_x10)
    
    hold on
    plotElectrodesMEA();
    
    m = imshow(mea_disc_color, ref_mea_disc);
    set(m, 'AlphaData', 0.3);
    hold on
    
    t = imshow(mea_checker_color, ref_mea_checker);
    set(t, 'AlphaData', 0.5);
    hold on
    
    m = imshow(mea_disc_color, ref_mea_disc);
    set(m, 'AlphaData', 0.3);
    
    hold on
    scatter(mea_dh_spots(:, 1), mea_dh_spots(:, 2), 60, black_inhibition(cell_id, :), "Filled")
    colormap([[linspace(0,1,128)'; ones(128,1)], ...
        [linspace(0,1,128)'; linspace(1,0,128)'] , ...
        [ones(128,1); linspace(1,0,128)']]);
    
    colorbar;
    caxis([-10, 10])
    
    hold on
    [x, y] = boundary(rf);
    plot(x, y, 'r', 'LineWidth', 1.5)
    title('inhibition heat map (disc responses - disc&dh responses)')
    pause(0.5);
    xlim([-500, 600])
    ylim([-100, 600])
    ylabel('microns')
    
    suptitle(strcat('cell #', num2str(cell_id)  )   );
    
    saveas(gcf, ['Inhibition_black#' num2str(cell_id)], 'jpg');
    close
    
end

