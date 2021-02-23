function [accuracy, rmses, prediction, firingRates] = getDHLNPAccuracies(dh_session, model, i_cell)

accuracy = dh_session.(model).accuracies;
rmses = dh_session.(model).rmses;
prediction = dh_session.(model).predictions;
firingRates = dh_session.(model).firingRates;

if exist('i_cell', 'var')
    accuracy = accuracy(i_cell);
    rmses = rmses(i_cell);
    prediction = prediction(i_cell, :);
    firingRates = firingRates(i_cell, :);
end