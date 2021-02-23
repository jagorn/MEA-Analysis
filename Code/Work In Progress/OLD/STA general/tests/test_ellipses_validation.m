clear
load(getDatasetMat(), 'stas')
nCells = numel(stas); 

for i = 1:nCells
    plotSTAFit(i)
    waitforbuttonpress;
    close()
    
end
    