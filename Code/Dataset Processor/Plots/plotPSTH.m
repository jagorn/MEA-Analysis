function plotPSTH(indices, pattern, label)
% Plots the psths for a given set of cells to a given repeated stimulus.

% Parameters;
% indices:              the id numbers of the cells
% pattern:              the name of the repeated stimulus.
% label:                the label of the psth
%                       if not specified, the default psth is plotted.

load(getDatasetMat(), 'psths')
if ~exist('psths', 'var') || ~isfield(psths, pattern) || ~isfield(psths.(pattern), label)
    error_struct.message = strcat("The PSTH ", label, " for pattern ", pattern, " does not exist.");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


traces = psths.(pattern).(label).psths(indices, :);
traces = traces ./ max(traces, [], 2);
xs = psths.(pattern).(label).time_sequences;

avgTrace = mean(traces, 1);
stdTrace = std(traces, [], 1);
upSTD = avgTrace + stdTrace / 2;
downSTD = avgTrace - stdTrace / 2;

hold on

% Plot Standard Deviation
x2 = [xs, fliplr(xs)];
inBetween = [upSTD, fliplr(downSTD)];
fill(x2, inBetween, [0.75, 0.75, 0.75]);

% Plot Mean
plot(xs, avgTrace, 'r', 'LineWidth', 3)

xlim([0, xs(end)]);
ylim([-0.1, +1.1]);
xlabel('Time (s)')
ylabel('Normalized Firing-Rate')

snr = doSNR(traces);
if isnan(snr)
    title(strcat("Average ", pattern, " PSTH"))
    
else
    title(strcat("Average ", pattern, " PSTH (SNR = ", num2str(snr), ")"))
end

