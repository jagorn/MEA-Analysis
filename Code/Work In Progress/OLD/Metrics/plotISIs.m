function snr = plotISIs(indices)

load(getDatasetMat(), 'isi', 'isi_bins')

traces = isi(indices, :);
avgTrace = mean(traces, 1);
stdTrace = std(traces, [], 1);
upSTD = stdTrace / 2;
downSTD = stdTrace / 2;
snr = doSNR(traces);

% Plot Standard Deviation
bar(isi_bins(1:end-1), avgTrace, 'FaceColor', 'r');
hold on
er = errorbar(isi_bins(1:end-1), avgTrace, downSTD, upSTD);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 

title(strcat("Average Normalized ISI (SNR = ", num2str(snr), ")"))
xlim([0 0.2])
xlabel('Inter Spike Intervals (s)')
ylabel('Probability Distribution')