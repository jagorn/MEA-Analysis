function plotRasterEulerClass(classId)

load(getDatasetMat(), 'cellsTable');
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');
indices = find(classIndices(classId));

rowCount = 1;
for i = indices
    
    expId = cellsTable(i).experiment; 
    repetitionsMat = strcat(dataPath, "/", expId, "/processed/Euler/Euler_RepetitionTimes.mat");
    load(repetitionsMat, "rep_begin", "rep_end")

    spike_train = spikes{i};
    spikes_tot = [];
    y_spikes_tot = [];
    
    for r = 1:length(rep_begin_time_20khz)
        spikes_segment = and(spike_train > rep_begin_time_20khz(r), spike_train < rep_end_time_20khz(r));
        spikes_rep = spike_train(spikes_segment) - rep_begin_time_20khz(r);
        
        if size(spikes_rep, 1) > 1
            spikes_rep = spikes_rep.';
        end
        
        spikes_tot = [spikes_tot, squeeze(spikes_rep)];
        y_spikes_tot = [y_spikes_tot, ones(1, length(spikes_rep)) * rowCount];
        rowCount = rowCount + 1;
    end
    scatter(spikes_tot / params.meaRate, y_spikes_tot, '.')
    hold on
end  

xlabel("time (s)")
    