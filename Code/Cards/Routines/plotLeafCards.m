function plotLeafCards(varargin)
% Plots a panel with all information  for each cell type:
% Each Panel includes:
% - Average Temporal Spike Triggered Average
% - Average PSTH for a choosen stimulus.
% - Mosaics of Receptive Fields


% INPUTS:
% Class (Optional):         if provided, only sub-classes of the given
%                           class are shown.
% Experiments (Optional):   if provided, mosaics are shown only for the
%                           experiments listed here.
% One_By_One (optional):	if true, panels are shown one by one.
%                           user has to click on a panel to close it,
%                           then the following panel will show up.
% Save (optional):          if true, each panel is saved in the PLOTS folder.

% Parse Input
p = inputParser;
addParameter(p, 'Class', "");
addParameter(p, 'Experiments', []);
addParameter(p, 'One_By_One', false);
addParameter(p, 'Save', false);

parse(p, varargin{:});
class = p.Results.Class;
experiments = p.Results.Experiments;
one_by_one = p.Results.One_By_One;
do_save = p.Results.Save;

if isempty(experiments)
    load(getDatasetMat(), 'experiments');
end
subclasses = getLeafClasses(class);


if numel(subclasses) > 0
    for class = subclasses
        plotClassCard(class, experiments);
           
        if do_save
            file_name = regexprep(class, '\.', '-');
            file_folder = fullfile(plotsPath(getDatasetId), 'Clustering');
            
            if ~exist(file_folder, 'dir')
                mkdir(file_folder);
            end

            file_path = fullfile(file_folder, file_name);
            saveas(gcf, file_path,'jpg')
        end
        
        if one_by_one
            waitforbuttonpress()
            close;
        end
    end
end


