function [Xell, Yell, centreX, centreY] = fitEllipse(frame)

% As center of the ellipse, choose the pixel with highest value
[maxRows, imy] = max(abs(frame), [], 2);
[maxPixel, imx] = max(maxRows, [], 1);
centreY = imx(1);
centreX = imy(imx);

% Normalize the STA frame
frame =  frame - mean(frame(:));
frame = frame / max(abs(frame(:)));
frame(abs(frame(:)) < 0.1) = 0;

% Fit the ellipses
options = optimset('TolFun', 1e-10,'TolX', 1e-10, 'Display', 'off');

p0 = [0.5 0.5 0 1];
gaussData = [size(frame,1) size(frame,2) centreX centreY];
lowerBound = [0  0 -5 -5];
upperBound = [20 20 5 5];

[p1, ~] = lsqcurvefit(@funcGauss, p0, gaussData, frame, lowerBound, upperBound, options);  

p0 = [p1 centreX centreY];
gaussData = size(frame);
lowerBound = [0  0 -5 -5 0 0];
upperBound = [20 20 5 5 40 40];

[p2, ~] = lsqcurvefit(@funcGauss, p0, gaussData, frame, lowerBound, upperBound, options);  

ellipsesParams(1) = p2(5);
ellipsesParams(2) = p2(6);
ellipsesParams(3:4) = p2(1:2);
ellipsesParams(5) = p2(3);
[Xell,Yell] =  funcEllipse(ellipsesParams, 1, 360);