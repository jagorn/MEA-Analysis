function Raster = DoRaster(SpikeTimes,StartTimes,StimDuration,CellNbs)


for icell=1:length(CellNbs)
    r = double(SpikeTimes{CellNbs(icell)});
    r = r(:);
    
    totr = [];
    totid = [];

    for id=1:length(StartTimes)
        subr = r( find(r>=StartTimes(id) & r<= (StartTimes(id)+StimDuration)) ) - StartTimes(id);%h = histc(r(:), EventTime(id) + (0:BinSize:(NbBins - 1)*BinSize ) );
        totr = [totr ; subr];
        totid = [totid ; ones(size(subr))*id];
    end
    if length(totr)>0
        Raster{icell}(:,1) = totr;
        Raster{icell}(:,2) = totid;
    else
        Raster{icell} = [];
    end
end


