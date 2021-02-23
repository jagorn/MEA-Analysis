function [z, threshold] = estimateZscore(PSTH, XPSTH, CtrlWin, RespWin, k, MinFiringRate)

PSTH_dt_by_cell = PSTH';

for icell=1:size(PSTH_dt_by_cell,2)
    m = mean(PSTH_dt_by_cell(find(XPSTH>= CtrlWin(1)& XPSTH<= CtrlWin(2)),icell));
    s = std(PSTH_dt_by_cell(find(XPSTH>= CtrlWin(1)& XPSTH<= CtrlWin(2)),icell));
    
    if any(PSTH_dt_by_cell(find(XPSTH>= RespWin(1)& XPSTH<= RespWin(2)),icell) > max(m+k*s ,MinFiringRate))
        z(icell) = 1;
    else
        z(icell) = 0;
    end
    threshold(icell) = max(m+k*s ,MinFiringRate);
end
