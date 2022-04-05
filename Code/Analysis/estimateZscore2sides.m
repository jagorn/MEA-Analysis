function [score, threshold_up, threshold_down] = estimateZscore2sides(psth, xpsth, dt_psth, ctrl_win, resp_win, k, min_fr)

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
    m = mean(psth_dt_by_cell(find(xpsth>= ctrl_win(1)& xpsth< ctrl_win(2)),icell));
    s = std(psth_dt_by_cell(find(xpsth>= ctrl_win(1)& xpsth< ctrl_win(2)),icell));
    
    u_plus = max(psth_dt_by_cell(find(xpsth>= resp_win(1)& xpsth< resp_win(2)),icell));
    u_minus = min(psth_dt_by_cell(find(xpsth>= resp_win(1)& xpsth< resp_win(2)),icell));
    
    delta_threshold = max(k*s, min_fr);
    threshold_plus =  m + delta_threshold;
    threshold_minus = m - delta_threshold;
    
    if any(psth_dt_by_cell(find(xpsth>= resp_win(1)& xpsth< resp_win(2)),icell) > threshold_plus)
        score(icell) = (u_plus - m);
    
    elseif any(psth_dt_by_cell(find(xpsth>= resp_win(1)& xpsth< resp_win(2)),icell) < threshold_minus)
        score(icell) = (u_minus - m);
    else
        score(icell) = 0;
    end
    
    threshold_up(icell) = threshold_plus;
    threshold_down(icell) = threshold_minus;
end
