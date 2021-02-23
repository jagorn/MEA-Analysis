clear
close all

figure()

i_cell = 9;
exp_id = '20180705_discs';
meaRate = 20000;

Checkerboard_PxlsPerSquare = 20;
DMD_PxlSize = 2.5;

loadDataset();
load([stimPath '/Discs/' 'Frames_180704_PairedPulseBg_230.mat']);

n_discs = numel(discs_reps);
labels = [discs_reps.id];
colors = getColors(n_discs);

% get STA and transform it
sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

img_rgb = ind2rgb(sta, colormap('summer'));


for  i_disc = 1:29

    subplot(1, 2, 1)
    imshow(img_rgb);
    hold on

    labels = strings(1, numel(discs_reps));
    x = discs_reps(i_disc).center_x_dmd;
    y = discs_reps(i_disc).center_y_dmd;
    d_microns = discs_reps(i_disc).diameter;    
    d = d_microns / DMD_PxlSize / Checkerboard_PxlsPerSquare;
    
    id = discs_reps(i_disc).id;
    viscircles([x, y], d/2, 'Color', colors(i_disc, :));
    text(x, y, id, 'HorizontalAlignment', 'center', 'Color', colors(i_disc, :))
    labels(i_disc) = id;
    axis on

    %  labels and colorbars
    xlabel('checkerboard squares');
    ylabel('checkerboard squares');
    title('sta with disc coords drawn')


    subplot(1, 2, 2)
    
    imshow(frames(:, :, frame_ids == ['1' id]))
    axis on

    xlabel('dmd pixels');
    ylabel('dmd pixels');
    title('frame as it is in the bin file')

    hold off
    waitforbuttonpress;
end
