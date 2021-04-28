loadDataset
params.psth.tBin = params.tBin
params.psth.nSteps = params.nSteps
params.psth.binSize = params.binSize
params.psth.nTBins = params.nTBins
save(getDatasetMat(), "params", "-append")