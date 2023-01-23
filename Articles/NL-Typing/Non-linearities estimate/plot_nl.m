clear;
close all;

% load
models_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Non-linearities estimate/ln_models.mat";
load(models_file, 'models_chirp', 'models_checks');

table_file = "/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/Classification/typing_results.mat";
load(table_file, 'mosaicsTable', 'cellsTable');

% initialize figure
figure;
fullScreen();

n_cells = numel(models_chirp);

% Find cells from experiment belonging to valid mosaics
cells_idx_logical = false;
for i_m = 1:numel(mosaicsTable)
    cells_idx_logical = mosaicsTable(i_m).indices | cells_idx_logical;
end
cell_idx = find(cells_idx_logical);

for i_cell = cell_idx
    
    models = [models_chirp(i_cell) models_checks(i_cell)];
    for m = models
        
        if isempty(m.s_filter)
            error("invalid model");
        end
        
        exp_id = m.experiment;
        cell_id = m.n;
        
        x = m.x;
        s = (m.s - min(m.s)) / (max(m.s)- min(m.s));
        g = (m.g - min(m.g)) / (max(m.g)- min(m.g));
        r = (m.r - min(m.r)) / (max(m.r)- min(m.r));
        p = (m.psth - min(m.psth)) / (max(m.psth)- min(m.psth));
        
        subplot(2, 3, 1);
        imagesc(m.s_filter);
        daspect([1 1 1]);
        axis off
        title("Spatial Filter");
        
        subplot(2, 3, 4);
        plot(m.t_filter, 'LineWidth', 1.5);
        axis off
        xlabel("time [s]");
        ylabel("g signal [a.u.]");
        title("Temporal Filter");
        
        
        subplot(2, 3, 2);
        hold off;
        stairs(m.p_edges, [0 m.p_g], 'b', 'LineWidth', 1, 'Color', [1, 0, 0, 0.5]);
        hold on;
        stairs(m.p_edges, [0 m.p_g_given_spike], 'r', 'LineWidth', 1, 'Color', [0, 0, 1, 0.5]);
        title("Prior and Likelihood");
        xlabel('g signal [a.u.]');
        ylabel('probability');
        legend({'p(g)', 'p(g|spike)'}, 'location', 'northwest');
        
        subplot(2, 3, 3);
        hold off;
        plot(m.nl_x_extended, m.nl_y_extended, 'k', 'LineWidth', 1);
        hold on;
        scatter(m.nl_x, m.nl_y, 15, 'r',  'Filled')
        xlim([-1.1, 2.1]);
        title(" Non-Linearity");
        xlabel('g signal [a.u.]');
        ylabel('p(spike|g)');
        
        subplot(2, 3, [5 6]);
        hold off;
        plot(x, r, 'Color', 'r', 'LineWidth', 1)
        hold on;
        plot(x, p, 'Color', 'b', 'LineWidth', 1)
        title('psth');
        xlabel('Time [s]');
        legend({'r signal', 'psth'});
        
        suptitle(strcat("Experiment ", exp_id, " Cell #", num2str(cell_id)));
        
        waitforbuttonpress();
    end
end


