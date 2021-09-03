clear
close all


mea_rate = 20000;
accepted_tag = 3;
evt_sessions = 1:5;
bin_dt = 0.05;
spacing_dt = 1;
labels = ["2f20p", "2f60p", "5f30p", "5f100p", "15f100p"];

ctrl_win_off = [0.5, 1];
resp_win_off = [1, 1.5];

ctrl_win_on = [-0.5, 0];
resp_win_on = [0, 0.5];

k = 5;
min_fr = 5;


load('SpikeTimes.mat');
load('EvtTimes.mat');
load('Tags.mat');

good_tags = find(tags >= accepted_tag);
good_spikes = spikes(good_tags);
n_cells = numel(good_spikes);

z_bars = zeros(numel(evt_sessions), 3);

for i_session = 1:numel(evt_sessions)
    session_id = evt_sessions(i_session);
    repetitions = evtTimes{session_id}.evtTimes_begins - (spacing_dt * mea_rate);
    repetitions_ends = evtTimes{session_id}.evtTimes_ends + (spacing_dt * mea_rate);
    n_steps_stim = median(repetitions_ends - repetitions);
    
    bin_size = round(bin_dt*mea_rate);
    n_bins = round(n_steps_stim / bin_size);
    
    [psth, xpsth, mean_psth, firing_rates] = doPSTH(good_spikes, repetitions, bin_size, n_bins,  mea_rate, 1:numel(good_spikes));
    xpsth = xpsth - spacing_dt;
    
    [z_on, threshold_on, score_on] = estimateZscore(psth, xpsth, bin_dt, ctrl_win_on, resp_win_on, k, min_fr);
    [z_off, threshold_off, score_off] = estimateZscore(psth, xpsth, bin_dt, ctrl_win_off, resp_win_off, k, min_fr);
    
    
    psths{i_session}.psth = psth;
    psths{i_session}.xpsth = xpsth;
    
    psths{i_session}.z_on = z_on;
    psths{i_session}.threshold_on = threshold_on;
    psths{i_session}.score_on = score_on;
    
    psths{i_session}.z_off = z_off;
    psths{i_session}.threshold_off = threshold_off;
    psths{i_session}.score_off = score_off;
    
    z_bars(i_session, 1) = sum(z_on) / n_cells * 100;
    z_bars(i_session, 2) = sum(z_off) / n_cells * 100;
    z_bars(i_session, 3) = sum(~z_off & ~z_on) / n_cells * 100;
end
save('psths.mat', 'psths');

figure();
b = bar(z_bars);
xticklabels(labels);
ylabel('percentage of cells activated (%)');
b(1).FaceColor = [.9, .3, .1];
b(2).FaceColor = [.3, .3, .9];
b(3).FaceColor = [.3, .3, .3];
legend('On Responses', 'Off Responses', 'No Responses');
title_txt = strcat('RD1 activations through Reachr2 (population size  = ', num2str(n_cells), ')');
title(title_txt);
