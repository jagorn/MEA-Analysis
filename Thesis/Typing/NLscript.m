
%Compute NL from Euler data
clear
close all

% Parameters
exp_id = "20170614";
euler_onset = 3000;
euler_offset = 5950;
mea_rate = 20000;

%Load data
exp_file = fullfile("Data", strcat(exp_id, "_data", ".mat"));
load(exp_file);

% Normalization of Chirp Stimulus
euler = euler / max(euler);
euler = euler - 0.5;


% Pick one cell - you can have easily a for loop here
for cell_id = Valid_STAs_idx'
    spikes = SpikeTimes{cell_id};
    t_sta = temporal(cell_id,:);
    
    % Compute temporal filters based on temporal components of the STAs
    t_filter = t_sta - 0.5;
    t_filter = t_filter / max(abs(t_filter));
    
    % Convolution
    generator = zeros(1, length(euler));
    for i = 1:length(euler)
        generator(i) = 0;
        for j = 1:min(length(t_filter), i)
            generator(i) = generator(i) + euler(i-j+1) * t_filter(end-j+1);
        end
    end
        
    figure;
    plot(t_sta);
    title(strcat("Cell #", num2str(cell_id), " STA (temporal component)"));
      
    FullDistrVal = generator(euler_onset:euler_offset); % Values taken by g, used to have the distribution.
    CondVal = [];
    
    %Extract over trials the values forming the p(g | spike) conditional distribution.
    for i = 1:length(rep_begin)
        StartTime = rep_begin(i) + euler_onset / euler_freq * mea_rate;
        EndTime  = rep_begin(i) + euler_offset / euler_freq * mea_rate;
        
        spikes_repetition = spikes(spikes >= StartTime & spikes <= EndTime) - rep_begin(i);
        spikes_indices = floor(spikes_repetition / (mea_rate/euler_freq) );
        
        CondVal = [CondVal  generator(spikes_indices)];
    end
    
    %Build the distributions
    x = linspace(min(FullDistrVal), max(FullDistrVal),25);
    
    p_spike = length(CondVal) / length(FullDistrVal);
    p_g = hist(FullDistrVal,x) / length(FullDistrVal);
    p_g_given_spike = hist(CondVal, x) / length(CondVal);
    
    %Estimate the non-linearity from bias rule as p(spike | g) = p(g | spike) * p(spike)  / p(g)
    non_linearity = p_spike * p_g_given_spike ./ p_g;
        
    
    %Fit only using values of the conditional distribution above 0. Also
    %excludes the nan values.
    noz = find(non_linearity>0);
    xdata = x(noz);
    ydata = non_linearity(noz);
    
    % p contains the three parameters of the exponential function.
    x0 = [0,0,0];
    funExp = @(x,xdata)(x(1)*exp(x(2)*xdata)+x(3));
    p = lsqcurvefit(funExp,x0,xdata,ydata);
    
    figure;
    plot(x, p_g_given_spike, 'r');
    hold on;
    plot(x, p_g, 'b');
    title(strcat("Cell #", num2str(cell_id), " Prior and Likelihood"));

    figure;
    plot(x, non_linearity, 'g')
    hold on;
    plot(xdata, funExp(p, xdata), 'k')
    waitforbuttonpress();
    title(strcat("Cell #", num2str(cell_id), " Non-Linearity"));
    legend({'empirical', 'fitted exp'})
end
