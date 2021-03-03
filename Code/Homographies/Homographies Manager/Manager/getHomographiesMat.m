function HMat = getHomographiesMat()

HMat = fullfile(homographiesPath(), 'Homographies.mat');
if ~isfile(HMat)
    initializeHomographiesMat();
end
