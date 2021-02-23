load(getDatasetMat, 'cellsTable');

reference_frame = 1;
exp_id = getExpId();
path = [dataPath '/' exp_id '/processed/Discs/Plots'];


for i_cell = 1:numel(cellsTable)
    for diameter_disc = [100 300 600]
        plotDiscsResponses(i_cell, reference_frame, diameter_disc)
        export_fig([path '/discs_psth_cell#' num2str(i_cell) '_discs' num2str(diameter_disc)]);
        close
    end
end