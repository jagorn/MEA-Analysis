function [isValid, meanRatio] = validateEllipse(xEll,yEll, staProjectionFrame)

meanRatioThreshold = 2;

[dim_x, dim_y] = size(staProjectionFrame);
ellipseMask = poly2mask(xEll, yEll, dim_x, dim_y);    

insideMean = abs(mean(staProjectionFrame(ellipseMask)));
outsideMean = abs(mean(staProjectionFrame(~ellipseMask)));

meanRatio = insideMean / outsideMean;
isValid = meanRatio >= meanRatioThreshold;


