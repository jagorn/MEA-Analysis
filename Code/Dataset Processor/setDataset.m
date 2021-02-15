function setDataset(dataset_name, experiments, varargin)
% Generates a dataset by pooling several experiments.

% DATASETNAME = "170614_ABC_25jan";
% it is the identifier for the given dataset.

% EXPERIMENTS = {"name_file_exp1", "name_file_exp2", etc...};
% files must be inside the dataPath() folder.
% dataset is created with the data from selected experiments

% ACCEPTED GRADES (optional) = 3;
% cells are accepted only with sorting score >= to [acceptedlabels]
% 5=A, 4=AB, 3=ABC

% STAs = true;
% if false, the STAs are not included in the dataset.

% Parse Input
p = inputParser;
addRequired(p, 'dataset_name');
addRequired(p, 'experiments');
addParameter(p, 'Accepted_Grades', 3);
addParameter(p, 'STAs', true);

parse(p, dataset_name, experiments, varargin{:});
accepted_labels = p.Results.Accepted_Grades;
include_stas = p.Results.STAs;


% Initialization
indices_list = {};
spikes = {};
grades = [];

if include_stas
    temporalSTAs = [];
    spatialSTAs = [];
    STAs = [];
    RFs = [];
end


%----- check mea rate ----------------%

mea_rate = getMeaRate(experiments{1});
for i_exp = 2:numel(experiments)
    exp_id = experiments{i_exp};
    
    % check mea rate
    exp_mea_rate = getMeaRate(exp_id);
    if mea_rate ~= exp_mea_rate
        error_struct.message = strcat("Your experiments cannot be pulled: different MEA rates");
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
end

    
for i_exp = 1:numel(experiments)
    exp_id = char(experiments{i_exp});
    disp(['Experiment ' exp_id])
    
    
    %----- load -------------------------------%
    
    SpikeTimes = getSpikeTimes(exp_id);
    Tags = getTags(exp_id);
    
    if include_stas
        stas = getSTAs(exp_id);
        [temporal_stas, spatial_stas, rfs, valid_stas] = getSTAsComponents(exp_id);
    end

    
    %----- validate ---------------------------%
    
    valid_tags = find(Tags >= accepted_labels).';
    bad_tags = numel(SpikeTimes) - numel(valid_tags);    
    fprintf('\t%i/%i cells excluded according to TAGS\n', bad_tags, numel(SpikeTimes))
    
    if include_stas
        bad_stas = numel(SpikeTimes) - numel(valid_stas);
        good_cells = intersect(valid_tags, valid_stas);
        if bad_stas > 0
            fprintf('\t%i/%i cells excluded for bad STA\n', bad_stas, numel(SpikeTimes))
        end
    else
        good_cells = valid_tags;
    end
    fprintf('\n')
    
    
    %----- pooling ---------------------------%
    
    indices_list{i_exp} = good_cells;
    spikes = [spikes, SpikeTimes(good_cells)];
    grades = [grades, Tags(good_cells)];
    
    if include_stas
        temporalSTAs = [temporalSTAs; normalizeTemporalSTA(temporal_stas(good_cells, :))];
        spatialSTAs = [spatialSTAs; spatial_stas(good_cells, :, :)];
        STAs = [STAs, stas(good_cells)];
        RFs = [RFs, rfs(good_cells)];
    end
    
    disp('')
end

% ----- create cells table --------------------%
cellsTable = buildDatasetTable(experiments, indices_list, grades);
if include_stas
    polarities = getPolarity(temporalSTAs);
    for i = 1:numel(cellsTable)
        cellsTable(i).Polarity = polarities(i);
    end
end

% ------ save ---------------------------------%
createDataset(dataset_name, experiments, cellsTable, spikes, mea_rate)
if include_stas
    save(getDatasetMat(), 'temporalSTAs', 'spatialSTAs', 'STAs', 'RFs', '-append')
end