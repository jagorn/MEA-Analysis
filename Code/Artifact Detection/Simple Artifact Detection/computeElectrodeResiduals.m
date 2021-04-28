function residuals = computeElectrodeResiduals(raw_file, triggers, stim_duration, padding, mea_map, encoding)

mea_size = size(mea_map, 1);
residuals = zeros(mea_size, stim_duration + padding*2);

fprintf('computing residual artifact...\n')

for i_t = 1:numel(triggers)
    t = triggers(i_t);
    waves = extractDataMEA(raw_file, t - padding, stim_duration + padding*2, mea_size, encoding);
    waves = reshape(waves, mea_size, stim_duration + padding*2);
    residuals = max(abs(waves), residuals);
    
    if mod(i_t, 25) == 0
        fprintf('\t%i/%i completed...\n', i_t, numel(triggers))
    end
end
