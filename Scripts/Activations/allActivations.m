
addAllDatasetPSTHs('Time_Spacing', 0.5)

computeAllActivations('flicker', {}, 'on', [-0.3, 0], [0 0.5], 5, 10)
computeAllActivations('flicker', {}, 'off', [0.7, 1], [1 1.5], 5, 10)
computeAllActivations('flash1On4Off', {}, 'off', [0.7, 1], [1 1.5], 5, 10)
computeAllActivations('flash1On4Off', {}, 'on', [-0.3, 0], [0 0.5], 5, 10)
computeAllActivations('euler', {}, 'on', [0.7, 1], [1 1.5], 5, 10)
computeAllActivations('euler', {}, 'off', [1.7, 2], [2 2.5], 5, 10)