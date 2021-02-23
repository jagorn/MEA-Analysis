function plotDHSpikesStats(i_cell, session)
s = load(getDatasetMat, session);

mean_ps = [];
var_ps = [];
for i_pattern = 1:size(s.(session).responses.all.spikeCounts, 2)
    responses_repeated = s.(session).responses.all.spikeCounts{i_cell,i_pattern};
    mean_p = mean(responses_repeated);
    var_p = var(responses_repeated);
    
    mean_ps = [mean_ps mean_p];
    var_ps = [var_ps var_p];
end

scatter(mean_ps, var_ps, 30, "Filled")
hold on

edge = max([mean_ps, var_ps]);
plot([0,edge], [0,edge])
xlim([0, edge]);
ylim([0, edge]);
title(strcat("Cell#", string(i_cell), ": Spikes Statistics"));
xlabel("Spiking Rate (Hz)")
ylabel("Variance")
