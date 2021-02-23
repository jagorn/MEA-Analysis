% Which Cells should we show here?


expId = '20181018a';
exp_indices = 1:9;

cell_Ns = expNs(expId, exp_indices);

point_size = 10;
interspace = 10;

sampling_rate = 20000;
varsPath = [dataPath(), '/', expId, '/processed/'];
load(strcat(varsPath, 'SpikeTimes.mat'), 'SpikeTimes')
load(strcat(varsPath,'Euler/Euler_RepetitionTimes.mat'), 'rep_begin_time_20khz', 'rep_end_time_20khz')
load(strcat(varsPath,'Euler/Euler_Stim.mat'), 'euler_sampler_rate', 'euler')
dt_euler = 1/euler_sampler_rate;
x_euler = 0:dt_euler:dt_euler*(length(euler)-1);


figure()
subplot(5, 1, 1)
plot(x_euler, euler, 'k')
axis off
ylabel("Chirp Luminance")


subplot(5, 1, 2:5)
% colors = getColors(numel(cell_indices));
rowCount = 0;
ticks = zeros(numel(cell_Ns), 1);
for i = 1:numel(cell_Ns)
    
    cell_id = cell_Ns(i)
%     color = colors(i, :);
    spikes = SpikeTimes{cell_id};
    
    ticks(i) = rowCount;
    for r = 1:length(rep_begin_time_20khz)
        rowCount = rowCount - 1;

        spikes_segment = and(spikes > rep_begin_time_20khz(r), spikes < rep_end_time_20khz(r));
        spikes_rep = (spikes(spikes_segment) - rep_begin_time_20khz(r));
        spikes_rep = spikes_rep(:).';
        
        y_spikes_rep = ones(1, length(spikes_rep)) * rowCount;
        
        scatter(spikes_rep / sampling_rate, y_spikes_rep, point_size, 'k', '.')
        hold on
    end
        
    rowCount = rowCount - interspace;
end

ylim([rowCount, 0])
xlabel("Time (s)")

% yticks(flip(ticks))
% yticklabels(flip(cell_indices))
yticks([])
ylabel("Cells Responses")

saveas(gcf, '/home/fran_tr/Desktop/Typing_Paper/eulerRaster','pdf')
