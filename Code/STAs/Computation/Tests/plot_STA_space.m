function f = plot_STA_space( STA )
%PLOT_STA_SPACE


        [~,max_ind] = max(STA(:));
        
        [~,~,t] = ind2sub(size(STA), max_ind);
        
        f = figure;
        f.Position(1) = 100;
        
        imagesc(STA(:,:,t));
        
        colorbar;
        title(['STA maximum reached for bin ' int2str(t)]);

end

