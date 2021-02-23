clear
load(getDatasetMat(), 'stas')

nCells = numel(stas);

kernelWeight = 0.3;
kernelCore = 1;
kernel = ones(3,3,3) * kernelWeight;
kernel(2,2,2) = kernelCore;
kernel = kernel / sum(kernel(:)); 

for i = 1:nCells
    
    % filter the sta to remove some noise
    [dim_x, dim_y, dim_t] = size(stas{i});
    smoothSTA = convn(stas{i}, kernel, 'same');

        % compensate for padding
    meanValue = mean(stas{i}(:));
    smoothSTA(1, :, :) = meanValue;
    smoothSTA(:, 1, :) = meanValue;
    smoothSTA(:, :, 1) = meanValue;
    smoothSTA(dim_x, :, :) = meanValue;
    smoothSTA(:, dim_y, :) = meanValue;
    smoothSTA(:, :, dim_t) = meanValue;
    
    varSta = std(stas{i}, [], 3);
    meanSta = mean(stas{i}, 3);
    peakSta = max(abs(stas{i}), [], 3);
    
    varSmoothSta = std(smoothSTA, [], 3);
    meanSmoothSta = mean(smoothSTA, 3);
    peakSmoothSta = max(abs(smoothSTA), [], 3);
    
    maxFrame = max(varSta(:));
    minFrame = min(varSta(:));
    avgFrame = mean(varSta(:));
    stdSTDFrame = std(varSta(:)); 
        
    figure()
    
    subplot(2, 7, 1)
    box off
    axis off
    infos1 = {"t-STD", "Max - Avg", string(maxFrame - avgFrame)};
    txt1 = text(0, 0, infos1);
    txt1.FontSize = 15;
   
    subplot(2, 7, [2, 3])
    imagesc(meanSta);
    hold on 
    [Xell,Yell] = fitEllipse(meanSta);
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title("t-Mean STA")
    pbaspect([1,1,1])
    axis off
    
    subplot(2, 7, [4, 5])
    imagesc(varSta);
    hold on 
    [Xell,Yell] = fitEllipse(varSta);
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title("t-STD STA")
    pbaspect([1,1,1])
    axis off
        
    subplot(2, 7, [6, 7])
    imagesc(peakSta);
    hold on 
    [Xell,Yell] = fitEllipse(peakSta);
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title("t-Peaks STA")
    pbaspect([1,1,1])
    axis off

    subplot(2, 7, [9, 10])
    imagesc(meanSmoothSta);
    hold on 
    [Xell,Yell] = fitEllipse(meanSmoothSta);
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title("t-Mean Smooth STA")
    pbaspect([1,1,1])
    axis off
    
    subplot(2, 7, [11, 12])
    imagesc(varSmoothSta);
    hold on 
    [Xell,Yell] = fitEllipse(varSmoothSta);
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title("t-STD Smooth STA")
    pbaspect([1,1,1])
    axis off
        
    subplot(2, 7, [13, 14])
    imagesc(peakSmoothSta);
    hold on 
    [Xell,Yell] = fitEllipse(peakSmoothSta);
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title("t-Peaks Smooth STA")
    pbaspect([1,1,1])
    axis off

          
    % set figure position and scaling
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1600;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    
    waitforbuttonpress;
%     fileName = strcat('ELLIPSE_FIT_CMP_Exp', cellsTable(i).experiment, '_Cell#', int2str(cellsTable(i).N));
%     saveas(gcf, fileName,'png')
    close()
    
end
    