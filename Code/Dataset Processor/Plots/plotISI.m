function plotISI(cell_id)
% Plots the Inter-spike interval for a given cell.

% Parameters;
% cell_id:      the id number of the cell

load(getDatasetMat(), 'spikes', 'mea_rate');
ISI = diff(spikes{cell_id} / mea_rate) * 1000;  % Convert to ms
ISI = ISI(ISI<=25);
histogram(ISI, 100);


