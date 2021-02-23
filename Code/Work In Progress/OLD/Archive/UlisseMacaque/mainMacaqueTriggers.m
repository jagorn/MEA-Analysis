FileBaseMU = 'checker_sppa0001';
EvtChannel = 127;
SamplingRate = 20000;
exp_path = '/home/fran_tr/hodgkin/Public/Francesco/MEA_Experiments/20140611_monkey/processed';
EvtFile = [FileBaseMU '_' int2str(EvtChannel) '.dat'];
t = importdata(EvtFile);
if isfield(t,'data')
    peak_times = round(t.data*SamplingRate);
end
 
figure;
plot(diff(peak_times(36:end)))
peak_times = peak_times(37:end);
peak_times = peak_times-3*666;

 
evtTimes{2}.evtTimes_begin = peak_times;
Frames = peak_times;

save('EvtTimes.mat', 'evtTimes')
movefile('EvtTimes.mat', exp_path)