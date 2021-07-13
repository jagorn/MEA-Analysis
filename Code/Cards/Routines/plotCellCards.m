function plotCellCards(varargin)
% Plots a panel with all information  for each cell


% INPUTS:
% One_By_One (optional):	if true, panels are shown one by one.
%                           user has to click on a panel to close it,
%                           then the following panel will show up.
% Save (optional):          if true, each panel is saved in the PLOTS folder.

% Parse Input
p = inputParser;
addParameter(p, 'One_By_One', false);
addParameter(p, 'Save', true);

parse(p, varargin{:});
one_by_one = p.Results.One_By_One;
do_save = p.Results.Save;

load(getDatasetMat(), 'cellsTable');
n_cells = numel(cellsTable);

    for i_cell = 1:n_cells
        plotCellCard(i_cell);
        fullScreen();
        
        if do_save
            file_name = strcat('Cell#', num2str(i_cell));
            file_folder = fullfile(plotsPath(getDatasetId), 'Cells');
            
            if ~exist(file_folder, 'dir')
                mkdir(file_folder);
            end

            file_path = fullfile(file_folder, file_name);
            saveas(gcf, file_path,'jpg')
        end
        
        if one_by_one
            waitforbuttonpress()
        end
        close;
    end


