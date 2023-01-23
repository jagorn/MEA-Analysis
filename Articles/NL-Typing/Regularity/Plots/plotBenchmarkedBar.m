function plotBenchmarkedBar(v, bs, color)

b = bar([1, 2], [v; mean(bs)],'FaceColor','flat', 'EdgeColor', 'none')  ;
b.CData(1, :) = color;
b.CData(2, :) = [0.7 0.7 0.7];
hold on


errorbar(2, mean(bs), std(bs)/sqrt(length(bs)), "Color", 'k', "LineStyle","none");
p_val = sum(bs>v) / numel(bs);
text(1, v, num2str(p_val));

ylim([0, max(v,  mean(bs))] * 2);
xticks([]);
