function plotSTAFit(cellIndex, kernelCore, kernelWeight)

    load(getDatasetMat, "stas", "cellsTable")

    if ~exist("kernelCore", "var")
            kernelCore = 1;
    end
    if ~exist("kernelWeight", "var")
        kernelWeight = 0.3;
    end   
    
    kernel = ones(3,3,3) * kernelWeight;
    kernel(2,2,2) = kernelCore;
    kernel = kernel / sum(kernel(:));

    % filter the sta to remove some noise
    [dim_x, dim_y, dim_t] = size(stas{cellIndex});
    smoothSTA = convn(stas{cellIndex}, kernel, 'same');

    % compensate for padding
    meanValue = mean(stas{cellIndex}(:));
    smoothSTA(1, :, :) = meanValue;
    smoothSTA(:, 1, :) = meanValue;
    smoothSTA(:, :, 1) = meanValue;
    smoothSTA(dim_x, :, :) = meanValue;
    smoothSTA(:, dim_y, :) = meanValue;
    smoothSTA(:, :, dim_t) = meanValue;
        
    % fit ellipse
    varSmoothSta = std(smoothSTA, [], 3);
    [Xell,Yell] = fitEllipse(varSmoothSta);
    [isValid, meanRatio] = validateEllipse(Xell, Yell, varSmoothSta);

    % project temporal sta
    figure()
    subplot(1,2,1)
    imagesc(varSmoothSta);
    hold on 
    plot(Xell, Yell, 'r', 'LineWidth', 2)
    title(strcat("Smoothed Spatial STA (meanRatio = ", string(meanRatio), ")"))
    pbaspect([1,1,1])
    axis off
    
    subplot(1,2,2)
    hold on
    title(strcat("Smoothed Temporal STAs"))
    for xi = 1:dim_x
        for yi = 1:dim_y
            if ~inpolygon(xi, yi, Yell, Xell)
                tSta = squeeze(smoothSTA(xi, yi, :));
                plot(tSta, 'b')
            end
        end
    end
    for xi = 1:dim_x
        for yi = 1:dim_y
            if inpolygon(xi, yi, Yell, Xell)
                tSta = squeeze(smoothSTA(xi, yi, :));
                plot(tSta, 'r')
            end
        end
    end
    pbaspect([1,1,1])

    
    suptitle(strcat("Cell #", string(cellsTable(cellIndex).N), " from Experiment ", cellsTable(cellIndex).experiment))
    
    % set figure position and scaling
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1600;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
