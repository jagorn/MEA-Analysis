function plotDHPredictionHistos(i_cell, session, model)

s = load(getDatasetMat(), session);

prediction = s.(session).(model).predictions(i_cell, :)';
firingRates = s.(session).(model).firingRates(i_cell, :)';
barh([firingRates, prediction], 'FaceColor','flat', 'EdgeColor', 'none')
xlabel("Mean Spiking Rate (Hz)");

yticks(1:size(s.(session).stimuli.test, 1));
yticklabels(yPatternLabels(s.(session).stimuli.test));

title(strcat("Cell #", string(i_cell), ": multi spot mean activation"));
legend("cell recordings", "model prediction");

accuracy = s.(session).(model).accuracies(i_cell);
rmse = s.(session).(model).rmses(i_cell);
title([char(session) ', Model #' num2str(i_cell) ': pears_coeff = ' num2str(accuracy) ', rmse = ' num2str(rmse)], 'Interpreter', 'None')