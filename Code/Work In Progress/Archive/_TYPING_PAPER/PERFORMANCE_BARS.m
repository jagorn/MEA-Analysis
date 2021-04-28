load(getDatasetMat, 'mosaicsTable')

final_i = numel(mosaicsTable) -1;

cnn_avg_score = mosaicsTable(final_i).bestModelScore;
sta_avg_score = mosaicsTable(final_i).bestControlScore;

final_i = numel(mosaicsTable) ;

cnn_std_score = mosaicsTable(final_i).bestModelScore;
sta_std_score = mosaicsTable(final_i).bestControlScore;



bar([1,2], [sta_avg_score, cnn_avg_score])                

hold on

er = errorbar([1,2], [sta_avg_score, cnn_avg_score], [sta_std_score/2, cnn_std_score/2],  [sta_std_score/2, cnn_std_score/2]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

hold off

ylim([0, 1])
xticklabels(["STA", "CNN"])
ylabel("method performance")