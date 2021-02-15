function plotExpLeafCards(exp_id, varargin)
% Plots a panel for each cell type in a given experiment:
% Each Panel includes:
% - Average Temporal Spike Triggered Average
% - Average PSTH for a choosen stimulus.
% - Mosaic of Receptive Fields
% - All the ids of the cells belonging to the cluster.

% INPUTS:
% exp_id:                   the id of the experiment.
% Class (Optional):         if provided, only sub-classes of the given
%                           class are shown.
% One_By_One (optional):	if true, panels are shown one by one.
%                           user has to click on a panel to close it,
%                           then the following panel will show up.
% Save (optional):          if true, each panel is saved in the PLOTS folder.

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Class', "");
addParameter(p, 'One_By_One', false);
addParameter(p, 'Save', false);

parse(p, exp_id, varargin{:});
class = p.Results.Class;
one_by_one = p.Results.One_By_One;
do_save = p.Results.Save;


subclasses = getLeafClasses(class);
for subclass = subclasses
    classNotEmpty = plotExpClassCard(subclass, exp_id);
    
    if classNotEmpty && do_save
        file_name = regexprep(subclass, '\.', '-');
        file_folder = fullfile(plotsPath(getDatasetId), 'Clustering', exp_id);
        
        if ~exist(file_folder, 'dir')
            mkdir(file_folder);
        end
        
        file_path = fullfile(file_folder, file_name);
        saveas(gcf, file_path,'jpg')
        close;
    end
    
    if one_by_one
        waitforbuttonpress()
        close;
    end
end


