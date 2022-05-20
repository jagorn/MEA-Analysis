
addAllDatasetPSTHs('Time_Spacing', 0.50)

try
    computeAllActivations('flicker', {}, 'on', [-0.3, 0], [0 0.5], 5, 10)
    computeAllActivations('flicker', {}, 'off', [0.7, 1], [1 1.5], 5, 10)
catch
    fprintf('no flicker available\n')
end

try
    computeAllActivations('flash1On4Off', {}, 'off', [0.7, 1], [1 1.5], 5, 10)
    computeAllActivations('flash1On4Off', {}, 'on', [-0.3, 0], [0 0.5], 5, 10)
catch
    fprintf('no flashes available\n')
end

try
    computeAllActivations('euler', {}, 'on', [0.7, 1], [1 1.5], 5, 10)
    computeAllActivations('euler', {}, 'off', [1.7, 2], [2 2.5], 5, 10)
catch
    fprintf('no euler available\n')
end

try
    computeAllActivations('white_disc_long', {}, 'on', [-0.475, -0.175], [0 0.325], 5, 10)
    computeAllActivations('white_disc_long', {}, 'off', [0.175 0.325], [0.325 0.625], 5, 10)
catch
    fprintf('no discs available\n')
end

try
    computeAllActivations('white_pulse', {}, 'on', [-0.5, -0.2], [0.0, .175], 5, 10)
catch
    fprintf('no pulses available\n')
end