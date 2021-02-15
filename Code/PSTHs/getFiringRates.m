function rs = getFiringRates(spikes, time_window, rep_begins, time_resolution, kernel_type)
% Implentation of smooth causal firing rates with Half Wave Rectification 
% (see Theoretical Neuroscience - Dayan & Abbott, chapter 1, page 15)
% rs: firing rates as a 2D [n_repetitions x time_steps] matrix

    if ~exist('kernel_type', 'var')
        kernel = @half_exponential;

    elseif kernel_type == "alfa"
        kernel = @half_wave_rectified;

    elseif kernel_type == "exp"
        kernel = @half_exponential;

    else
        error("getFiringRates ERROR: INVALID KERNEL_TYPE");
    end
    
    % inputs must be row vectors
    assert(size(spikes, 1) == 1);
    assert(size(rep_begins, 1) == 1);
    assert(size(time_window, 1) == 1);
    
    % group spikes belonging to each repetition    
    times_init = rep_begins + time_window(1) - time_resolution * 10;
    times_end = rep_begins + time_window(end);
    spike_trains = extractSpikeTrains(spikes, times_init, times_end, rep_begins);
       
    n_repetitions = size(rep_begins, 2);
    n_tsteps = size(time_window, 2);
    rs = zeros(n_repetitions, n_tsteps);
    
    for i = 1:n_repetitions
        spikes = spike_trains{i};
        spikes2time = time_window - spikes(:);
        % firing rates are computed by convolving the kernel in time
        rs(i, :) = squeeze(sum(kernel(spikes2time, time_resolution), 1) );   
    end
end

% Half Wave Rectified Kernel
function f = half_wave_rectified(t, t_res)
    alfa = 1/t_res;
    f = alfa^2 * t .* exp(-alfa * t);
    f(f < 0) = 0;
end

% Half Exponential Kernel
function f = half_exponential(t, t_res)
    f = exp(-t / t_res) / t_res;
    f(t < 0) = 0;
end