load('/home/fran_tr/Projects/MEA_CLUSTERING/Analysis_MEA/Degus/Degu N1 269.spiketimes3.mat')

n_cells = numel(SpikeTimes);
rpvs = zeros(1, n_cells);
for i = 1:n_cells
    spikes = SpikeTimes{i};
    isi = diff(spikes)/20000;
    histogram(isi, 1000);
    waitforbuttonpress();
    rpv_logical = isi < 0.002;
    rpvs(i) = sum(rpv_logical) / numel(isi);
end