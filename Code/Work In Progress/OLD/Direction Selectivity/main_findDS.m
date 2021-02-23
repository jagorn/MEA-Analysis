clear
expId = "180705";


%----- PATHS ---------------------------%

repetitionsMat = strcat("Experiments/", expId, "/Bars/RepetitionTimes.mat");
spikesMat = strcat("Experiments/", expId, "/SpikeTimes.mat");


%----- LOADs -------------------------------%

load(repetitionsMat, "rep_begin_time_20khz", "rep_end_time_20khz")
load(repetitionsMat, "rep_begin_time_20khz_left", "rep_begin_time_20khz_right")
load(spikesMat, "SpikeTimes")


%----- PARAMETERS ----------------------------%

% experimental parameters
meaRate = 20000; %Hz
nSteps = rep_end_time_20khz(1) - rep_begin_time_20khz(1);

% modeling parameters
tBin = 0.1; % s
binSize = tBin * meaRate;
nTBins = round(nSteps / binSize);


%----- NORMALIZED PSTH ------------------------%
nCells = numel(SpikeTimes);


% center
barsPSTHs = zeros(nCells, nTBins, 8);
for d = 1:8
    begin_time = rep_begin_time_20khz(:, d);
    [PSTH, X, ~] = doPSTH(SpikeTimes, begin_time, binSize, nTBins, meaRate, 1:numel(SpikeTimes)); 
    barsPSTHs(:, :, d) = PSTH;
end

% left
barsPSTHs_left = zeros(nCells, nTBins, 8);
for d = 1:8
    begin_time = rep_begin_time_20khz_left(:, d);
    [PSTH, X, ~] = doPSTH(SpikeTimes, begin_time, binSize, nTBins, meaRate, 1:numel(SpikeTimes)); 
    barsPSTHs_left(:, :, d) = PSTH;
end

% right
barsPSTHs_right = zeros(nCells, nTBins, 8);
for d = 1:8
    begin_time = rep_begin_time_20khz_right(:, d);
    [PSTH, X, ~] = doPSTH(SpikeTimes, begin_time, binSize, nTBins, meaRate, 1:numel(SpikeTimes)); 
    barsPSTHs_right(:, :, d) = PSTH;
end

for c = 1:nCells
    
    scalePSTH = max(barsPSTHs(c, :));
    if scalePSTH > 0
        barsPSTHs(c, :) = barsPSTHs(c, :) / max(barsPSTHs(c, :));
    end
    
    scalePSTH = max(barsPSTHs_left(c, :));
    if scalePSTH > 0
        barsPSTHs_left(c, :) = barsPSTHs_left(c, :) / max(barsPSTHs_left(c, :));
    end
    
    scalePSTH = max(barsPSTHs_right(c, :));
    if scalePSTH > 0
        barsPSTHs_right(c, :) = barsPSTHs_right(c, :) / max(barsPSTHs_right(c, :));
    end
end


[dsK, dsAngle, osK, osAngle, dirModules] = isDirectionSelective(barsPSTHs);

for c = 1:nCells
%     figure();
%     subplot(1, 2,1);
%     plotDirectionSelectivity(dsK(c), dsAngle(c), osK(c), osAngle(c), dirModules(c, :));
%     subplot(1, 2, 2);
%     plotBarsPSTH(squeeze(barsPSTHs(c, :, :)), tBin);
%     waitforbuttonpress();
%     close();

    plotSelectivityExt(dsK(c), dsAngle(c), osK(c), osAngle(c), dirModules(c, :), squeeze(barsPSTHs(c, :, :)), squeeze(barsPSTHs_left(c, :, :)), squeeze(barsPSTHs_right(c, :, :)), tBin)
    suptitle(strcat("cell #", string(c)));
    waitforbuttonpress();
    close()
end