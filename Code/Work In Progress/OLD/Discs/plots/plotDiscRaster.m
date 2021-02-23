function plotDiscRaster(i_cell, session_label)

load(getDatasetMat, 'spikes', 'params', 'discs_params')
s = load(getDatasetMat, session_label);
discs = s.(session_label);
colors = getColors(numel(discs));

reps = {discs.rep_begin};
dt = median([discs.dt]);
onset =  discs_params.onset;
offset = discs_params.offset;
labels = [discs.id];

hold off
plotStimRaster(spikes{i_cell},  reps, dt * params.meaRate, params.meaRate, ...
                'Raster_Colors', colors, ...
                'Labels', labels, ...
                'Response_Onset_Seconds', onset, ...
                'Response_Offset_Seconds', offset)
            
end

