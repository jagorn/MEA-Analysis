function smoothSTA = smoothSta(sta)

kernelWeight = 0.3;
kernelCore = 1;
kernel = zeros(3,3,3);
kernel(2, 2, [1 3]) = kernelWeight;
kernel(2, 2, 2) = kernelCore;
kernel = kernel / sum(kernel(:)); 

[dim_x, dim_y, dim_t] = size(sta);
smoothSTA = convn(sta, kernel, 'same');

% compensate for padding
meanValue = mean(sta(:));
smoothSTA(:, :, 1) = meanValue;
smoothSTA(:, :, dim_t) = meanValue;

