function smoothSTA = smoothSpatialSta(sta)

kernelWeight = 0.3;
kernelCore = 1;
kernel = ones(3,3) * kernelWeight;
kernel(2,2) = kernelCore;
kernel = kernel / sum(kernel(:)); 

[dim_x, dim_y] = size(sta);
smoothSTA = convn(sta, kernel, 'same');

% compensate for padding
meanValue = mean(sta(:));
smoothSTA(1, :) = meanValue;
smoothSTA(:, 1) = meanValue;
smoothSTA(dim_x, :) = meanValue;
smoothSTA(:, dim_y) = meanValue;

