load(getDatasetMat, "mosaicsTable", "modelsTable", "controlTable");

for i_m1 = 1:numel(mosaicsTable)
    for i_m2 = 1:numel(modelsTable)
        idx_m1 = mosaicsTable(i_m1).indices;
        idx_m2 = modelsTable(i_m2).indices;
        model_scores(i_m1, i_m2) = mcc_score(idx_m1, idx_m2);
    end
    
    for i_m2 = 1:numel(controlTable)
        idx_m1 = mosaicsTable(i_m1).indices;
        idx_m2 = controlTable(i_m2).indices;
        control_scores(i_m1, i_m2) = mcc_score(idx_m1, idx_m2);
    end
end


[best_models_scores, best_models_idx] = max(model_scores,[],2);
best_models = [modelsTable(best_models_idx).class];

[best_control_scores, best_controls_idx] = max(control_scores,[],2);
best_controls = [controlTable(best_controls_idx).class];

for i_m1 = 1:numel(mosaicsTable)
    mosaicsTable(i_m1).bestModel = best_models(i_m1);
    mosaicsTable(i_m1).bestModelScore = best_models_scores(i_m1);
    mosaicsTable(i_m1).bestControl = best_controls(i_m1);
    mosaicsTable(i_m1).bestControlScore = best_control_scores(i_m1);
end 

final_i = numel(mosaicsTable) + 1;
mosaicsTable(final_i).bestModel = "MEAN_SCORE";
mosaicsTable(final_i).bestModelScore = mean([mosaicsTable.bestModelScore]);
mosaicsTable(final_i).bestControl =  "MEAN_SCORE";
mosaicsTable(final_i).bestControlScore = mean([mosaicsTable.bestControlScore]);

final_i = final_i + 1;
mosaicsTable(final_i).bestModel = "STD_SCORE";
mosaicsTable(final_i).bestModelScore = std([mosaicsTable.bestModelScore]);
mosaicsTable(final_i).bestControl =  "STD_SCORE";
mosaicsTable(final_i).bestControlScore = std([mosaicsTable.bestControlScore]);
save(getDatasetMat, "mosaicsTable", "-append");

