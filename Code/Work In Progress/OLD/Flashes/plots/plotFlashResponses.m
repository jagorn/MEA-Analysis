function plotFlashResponses(cell_idx, plot_second_flash)

load(getDatasetMat(), 'cellsTable', 'flash', 'flash_Z')
n_cells = numel(cell_idx);
n_flashes = numel(flash.types);

% find the upper bound of the firing rates
max_fr = 0;
for i_cell = cell_idx 
    for i_flash = 1:n_flashes
        if max(flash.psth{i_flash}(i_cell, :)) > max_fr
            max_fr = max(flash.psth{i_flash}(i_cell, :));
        end
    end
end
    
% initialize the figure
figure;
fullScreen();
i_plot = 1;
for i_cell = cell_idx
    
    % plot the STA
    subplot(n_cells, n_flashes + 1, i_plot);
    plotTSTAs(i_cell)
    xticks([]); 
    yticks([]); 
    ylabel(['Cell #' num2str(i_cell)]);
    xlabel(cellsTable(i_cell).POLARITY);

    i_plot = i_plot + 1;
    
    if i_plot <= n_flashes + 1
        title('temporal STA');
    end

    % plot the PSTHs
    for i_flash = 1:n_flashes  
        
        subplot(n_cells, n_flashes + 1, i_plot);
            
        if i_plot <= n_flashes + 1
            title(flash.types(i_flash), 'Interpreter', 'None');
        end
        
        if i_flash == 1 && i_cell == cell_idx(end)
            ylabel('Firing Rate (Hz)');
            xlabel('Time (s)');
        end
        
        hold on
        
        % plot the flash intervals
        onset = flash.FlashWin(1, i_flash);
        size_flash = flash.FlashWin(2, i_flash) - flash.FlashWin(1, i_flash);
        rect = [onset, 0, size_flash, max_fr+1];
        rectangle('Position', rect, 'FaceColor', [.95, .85, .5], 'EdgeColor', 'none')
        
        if plot_second_flash
            size_pause = flash.PauseWin(2, i_flash) - flash.PauseWin(1, i_flash);
            rect_2 = [onset + size_flash + size_pause, 0, size_flash, max_fr+1];
            rectangle('Position', rect_2, 'FaceColor', [.95, .85, .5], 'EdgeColor', 'none')
        end

        % plot the cell responses
        if flash_Z.zON(i_cell, i_flash)>0 && flash_Z.zOFF(i_cell, i_flash)>0
            color = 'm';
        elseif flash_Z.zON(i_cell, i_flash)>0
            color = 'r';
        elseif flash_Z.zOFF(i_cell, i_flash)>0
            color = 'g';
        else
            color = 'k';
        end
        plot(flash.xpsth{i_flash}, flash.psth{i_flash}(i_cell, :), color ,'LineWidth', 2)
        
        % plot the z-score thresholds
%         plot(flash.ONRespWin(:, i_flash),[flash_Z.ThresON(i_cell,i_flash) flash_Z.ThresON(i_cell,i_flash)] ,'m-.' ,'LineWidth', 2)
%         plot(flash.OFFRespWin(:, i_flash),[flash_Z.ThresOFF(i_cell,i_flash) flash_Z.ThresOFF(i_cell,i_flash)] ,'c-.' ,'LineWidth', 2)
%     
        ylim([0 max_fr + 2])
        xlim([0 max(flash.xpsth{i_flash})])
        i_plot = i_plot + 1;
    end
end