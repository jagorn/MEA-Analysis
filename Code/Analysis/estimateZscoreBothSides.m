function [zs, thresholds, scores, spontaneous_fr, latencies] = estimateZscoreBothSides(psth, xpsth, dt_psth, ctrl_win, resp_win, k, min_fr)

% make sure the control and response window are inside the xpsth boundaries

if ctrl_win(1) < min(xpsth) || ctrl_win(2) >  max(xpsth) + dt_psth
    error_struct.message = "the control window chosen to estimate cell activation lies outside the response time interval";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


if resp_win(1) < min(xpsth) || resp_win(2) >  max(xpsth) + dt_psth
    error_struct.message = "the response window chosen to estimate cell activation lies outside the response time interval";
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end


psth_dt_by_cell = psth';

for icell=1:size(psth_dt_by_cell,2)
    
    ctrl_idx = find(xpsth>= ctrl_win(1)& xpsth< ctrl_win(2));
    resp_idx = find(xpsth>= resp_win(1)& xpsth< resp_win(2));
    
    m = mean(psth_dt_by_cell(ctrl_idx, icell));
    s = std(psth_dt_by_cell(ctrl_idx, icell));
    [a, latency_idx_a] = max(psth_dt_by_cell(resp_idx, icell));
    [i, latencey_idx_i] = min(psth_dt_by_cell(resp_idx,icell));
    
    threshold_up =  max(m+k*s ,m+min_fr);
    threshold_down =  min(m-k*s ,m-min_fr);
    
    if any(psth_dt_by_cell(resp_idx,icell) > threshold_up)
        zs(icell) = 1;
        thresholds(icell) = threshold_up;
        scores(icell) = (a - m);
        latencies(icell) = xpsth(resp_idx(latency_idx_a));

    elseif any(psth_dt_by_cell(resp_idx,icell) < threshold_down)
        zs(icell) = -1;
        thresholds(icell) = threshold_down;
        scores(icell) = (i - m);
        latencies(icell) = xpsth(resp_idx(latencey_idx_i));
        
    else
        zs(icell) = 0;
        thresholds(icell) = threshold_up;
        scores(icell) = 0;
        latencies (icell) = 0;
    end
    
    spontaneous_fr(icell) = m;
end
