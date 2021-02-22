% function ConvertMUdata(FileBaseMU,EvtChannel,fileOut,SamplingRate)

FileBaseMU = '/home/fran_tr/Data/dhgui_test/raws/checker_sppa0001';
EvtChannel = 127;
SamplingRate = 20000;

EvtFile = [FileBaseMU '_' int2str(EvtChannel) '.dat'];


%% load the text files and create a raster file unless the raster file exists. 

for iel=1:30
    if iel<10
        filename = [FileBaseMU '_0' int2str(iel) '.dat'];
    else
        filename = [FileBaseMU '_' int2str(iel) '.dat'];
    end
    t = importdata(filename);
    if isfield(t,'data')
        SpikeTimes{iel} = round(t.data*SamplingRate);
    end
end


%% Get start times for a given spot

t = importdata(EvtFile);
if isfield(t,'data')
    peak_times = round(t.data*SamplingRate);
end


% save(fileOut,'SpikeTimes','peak_times','-mat')
