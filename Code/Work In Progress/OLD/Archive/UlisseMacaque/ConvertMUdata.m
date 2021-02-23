function ConvertMUdata(FileBaseMU,EvtChannel,fileOut,SamplingRate)


% FileBaseMU = '/Users/olivier/Documents/Data/2017-06-14/Multiunit/DH_stim_250_z64/DH_stim_250_z64_sppa0001';

EvtFile = [FileBaseMU '_' int2str(EvtChannel) '.dat'];


%% load the text files and create a raster file unless the raster file exists. 

for iel=1:254
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


save(fileOut,'SpikeTimes','peak_times','-mat')
