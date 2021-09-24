
addAllDatasetPSTHs('Time_Spacing', 0.5)

try
    computeAllActivations('flicker', {}, 'on', [-0.3, 0], [0 0.5], 5, 5)
    computeAllActivations('flicker', {}, 'off', [0.7, 1], [1 1.5], 5, 5)
catch
    fprintf('no flicker available\n')
end

try
    computeAllActivations('flash1On4Off', {}, 'off', [0.7, 1], [1 1.5], 5, 5)
    computeAllActivations('flash1On4Off', {}, 'on', [-0.3, 0], [0 0.5], 5, 5)
catch
    fprintf('no flashes available\n')
end

try
    computeAllActivations('euler', {}, 'on', [0.7, 1], [1 1.5], 5, 5)
    computeAllActivations('euler', {}, 'off', [1.7, 2], [2 2.5], 5, 5)
catch
    fprintf('no euler available\n')
end