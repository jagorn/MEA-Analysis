f = figure;
set(f, 'Position', [10,50,1500,770]);

for ii = 1:16
    for jj = 1:16
        if sum(ismember([ii,jj],[1,16]))~=2
            subplot_tight(16,16,jj+(ii-1)*16,[0,0]);
            %subplot_tight(2,3,1,[0,0]);
            
            plot(0:20,plotdata.STAtime{Index_names(ii,jj)});
            set(gca, 'XTick', []);
            set(gca, 'YTick', []);
            L=get(gca,'YLim');
            L=L(1)*0.25+L(2)*0.75;
            text(15,L,int2str(Index_names(ii,jj)))
            
        end
    end
end


