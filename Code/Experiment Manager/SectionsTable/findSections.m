function chosen_tables = findSections(exp_id, stim_id, varargin)
% Finds all the sections of an experiment corresponding to a given stimulus.
%
% PARAMETERS:
% EXP_ID:                               the identifier of the experiment.
% STIM_ID:                              the identifier of the stimulus.
% RATES (OPTIONAL):                     only the sections with the frame rate specified are returned.
% CONDITIONS (OPTIONAL):                only the sections with the conditions listed are returned.
% ALLOW_OTHER_CONDITIONS (OPTIONAL):    if true, the sections returned must have all the conditions listed or more.
%                                       if false, the sections returned must have al the conditions listed and only those.

% OUTPUT:
% A struct with an element for each section returned, specifying stim_id,
% conditions, triggers, repetitions, frame rate, etc...

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addRequired(p, 'stim_id');
addParameter(p, 'Rate', []);
addParameter(p, 'Conditions', []);
addParameter(p, 'Allow_Other_Conditions', true);

parse(p, exp_id, stim_id, varargin{:});

rate = p.Results.Rate;
conditions = p.Results.Conditions;
other_conditions_allowed = p.Results.Allow_Other_Conditions;

sectionsTable = getSectionsTable(exp_id);

% Find the Sections with the stim 'stim_id'
stim_tables = sectionsTable([sectionsTable.stimulus] == stim_id);

% Find the Sections with the frame rate = 'Rate'
if ~isempty(rate)
    if ~isfield(sectionsTable, 'rate')
        error_struct.message = strcat("frame rates were not computed yet for ", exp_id);
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
    stim_tables = stim_tables([stim_tables.rate] == rate);
end

% If the conditions are specified, find the sections that also match the conditions:
if isempty(conditions) && other_conditions_allowed
    chosen_tables = stim_tables;
    return

elseif isempty(conditions) && ~other_conditions_allowed
    
    chosen_idx = [];
    for i_table = 1:numel(stim_tables)
        table = stim_tables(i_table);
        table_conditions = table.conditions;
        
        if isempty(table_conditions)
            chosen_idx = [chosen_idx i_table];
        end
    end
    chosen_tables = stim_tables(chosen_idx);
    return
    
    
elseif ~isempty(conditions) && other_conditions_allowed
    
    chosen_idx = [];
    for i_table = 1:numel(stim_tables)
        table = stim_tables(i_table);
        table_conditions = table.conditions;
        
        if all(contains(lower(conditions), lower(table_conditions)))
            chosen_idx = [chosen_idx i_table];
        end
    end
    chosen_tables = stim_tables(chosen_idx);
    
    
elseif ~isempty(conditions) && ~other_conditions_allowed
    
    chosen_idx = [];
    for i_table = 1:numel(stim_tables)
        table = stim_tables(i_table);
        table_conditions = table.conditions;
        
        if (numel(conditions) == numel(table_conditions)) && (all(sort(lower(conditions)) == sort(lower(table_conditions))))
            chosen_idx = [chosen_idx i_table];
        end
    end
    chosen_tables = stim_tables(chosen_idx);
end
