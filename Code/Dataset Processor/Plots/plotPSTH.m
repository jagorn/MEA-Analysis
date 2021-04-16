function plotPSTH(indices, pattern, label, varargin)
% Plots the psths for a given set of cells to a given repeated stimulus.

% Parameters;
% indices:                  the id numbers of the cells
% pattern:                  the name of the repeated stimulus.
% label:                    the label of the psth
% show_stimulus (optional): if = 'trace', the stimulus profile is shown in the background as a trace.
%                           if = 'blocks', the stimulus is shown in the backroung as blocks.



% Parse Input
p = inputParser;
addRequired(p, 'indices');
addRequired(p, 'pattern');
addRequired(p, 'label');
addParameter(p, 'Show_Stimulus', 'trace');

parse(p, indices, pattern, label, varargin{:});
show_stimulus = p.Results.Show_Stimulus;

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

% Plot Stimulus
if strcmp(show_stimulus, 'trace')
    try
        stim_pattern = getPatternProfile(pattern);
        stim_rate =  psths.(pattern).(label).stim_rate;
        plotStimProfile(stim_pattern.profile, stim_rate)
    end
elseif strcmp(show_stimulus, 'blocks')
    try
        stim_pattern = getPatternProfile(pattern);
        stim_rate =  psths.(pattern).(label).stim_rate;
        plotStimStates(stim_pattern.profile, stim_rate)
    end
end

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

if numel(indices) == 1
    title(strcat("Cell #", num2str(indices), ": ", pattern, " PSTH"))
    
else
    snr = doSNR(traces);
    title(strcat("Average ", pattern, " PSTH (SNR = ", num2str(snr), ")"))
end

