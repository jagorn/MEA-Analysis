function plotDHAccuracyCorr(i_cell, session, model)


s = load(getDatasetMat(), session);
prediction = s.(session).(model).predictions(i_cell, :)';
firingRates = s.(session).(model).firingRates(i_cell, :)';

figure()
fullScreen()

scatter(firingRates, prediction, 100, 'Filled', 'o')
ylabel("Predicted Firing-Rates (Hz)");
xlabel("True Firing-Rates (Hz)");

hold on
plot_edge = max([firingRates; prediction]);
plot([0,plot_edge], [0,plot_edge], "LineWidth", 3, "Color", [.2, .2, .2])
xlim([0, plot_edge]);
ylim([0, plot_edge]);
pbaspect([1 1 1])

title1 = "Predicted Mean Firing-Rate Across DH Patterns";
title2 = strcat("Cell #", string(i_cell), ": accuracy = ", string(s.(session).(model).accuracies(i_cell)));
title({title1; title2});
