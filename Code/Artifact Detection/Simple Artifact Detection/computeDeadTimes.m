function dead_times = computeDeadTimes(triggers, dead_init, dead_end)

dead_times = zeros(numel(triggers)*numel(dead_init), 2);
i_d = 0;
for t = triggers
    for i = 1:length(dead_init)
        i_d = i_d + 1;
        dead_times(i_d, :) = [dead_init(i), dead_end(i)] + t;
    end
end
