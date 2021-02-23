function [PSTH,XPSTH,MeanPSTH] = DoPSTH_Olivier(SpikeTimes,EventTime,BinSize,NbBins,SamplingRate,CellNbs)
%SpikeTimes: the raster
%EventTime: the beginning of each repeat
%BinSize: in the same units than SpikeTimes and EventTime
%NbBins: number of bins
%SamplingRate: acquisition rate - 1/timestep of spike times
%CellNbs: which cells to pick in SpikeTimes for the psth estimation

%PSTH: the psth
%XPSTH: for a proper display, use plot(XPSTH,PSTH...
%MeanPSTH: average firing rate over the defined window

XPSTH = (0:BinSize:(NbBins - 1)*BinSize )/SamplingRate;

PSTH = zeros(NbBins,length(CellNbs));

for icell=1:length(CellNbs)
    r = double(SpikeTimes{CellNbs(icell)});
    r = r(:);

    for id=1:length(EventTime)
        try
            h = histc(r(:), EventTime(id) + (0:BinSize:(NbBins - 1)*BinSize ) );
            PSTH(:,icell) = PSTH(:,icell) + h(:);
        catch
            size(r(:))
            size(PSTH(:,icell))
            size(h(:))
            error('dim problem')
        end
    end
    PSTH(:,icell) = PSTH(:,icell) / length(EventTime);
    PSTH(:,icell) = PSTH(:,icell)/(BinSize/SamplingRate);
    MeanPSTH(icell) = mean(PSTH(:,icell));
end


