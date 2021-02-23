function plotDHRaster_by_pattern(i_pattern, session_label, pattern_type, varargin)

onset = -0.5;
offset = 0.5;

% Get all Stim Repetitions
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');
s = load(getDatasetMat(), session_label);
pattern_reps = s.(session_label).repetitions.(pattern_type);

n_steps_stim = s.(session_label).params.stim_dt * params.meaRate;

% Default Parameters
dead_times_default = false;
cells_by_column_default = 50;
cells_indices_default = 1:numel(spikes);
is_subfigure_default = false;

% Parse Input
p = inputParser;
addRequired(p, 'i_pattern');
addRequired(p, 'session_label');
addRequired(p, 'pattern_type');

addParameter(p, 'Cells_Idx', cells_indices_default);
addParameter(p, 'Dead_Times', dead_times_default);

addParameter(p, 'Column_Size', cells_by_column_default);

addParameter(p, 'Is_Subfigure', is_subfigure_default);
addParameter(p, 'Columns_Indices', []);
addParameter(p, 'N_Columns', []);

parse(p, i_pattern, session_label, pattern_type, varargin{:});
cells_idx = p.Results.Cells_Idx; 
n_cells_by_column = p.Results.Column_Size; 
do_dead_times = p.Results.Dead_Times;

is_sub_figure = p.Results.Is_Subfigure;
columns_idx = p.Results.Columns_Indices;
n_columns = p.Results.N_Columns;


% Unroll all the options about plot structure
if islogical(cells_idx)
    cells_idx = find(cells_idx);
end
n_cells = length(cells_idx);

if isempty(n_columns) && isempty(columns_idx)
    n_columns = ceil(n_cells/n_cells_by_column);
    columns_idx = 1:n_columns;
    
    if n_columns == 1
        n_cells_by_column = n_cells;
    end
    
elseif  ~isempty(n_columns) && isempty(columns_idx)
    columns_idx = 1:n_columns;
    n_cells_by_column = ceil(n_cells/length(columns_idx));
    
elseif  isempty(n_columns) && ~isempty(columns_idx)
    n_columns = max(columns_idx);
    n_cells_by_column = ceil(n_cells/length(columns_idx));
    
else
    n_cells_by_column = ceil(n_cells/length(columns_idx));
end

% If this is an independent figure, initialize the windonw
if ~is_sub_figure
    figure()
    fullScreen()
end

pattern_label = yPatternLabels(s.(session_label).stimuli.(pattern_type)(i_pattern, :));
suptitle([session_label ', Pattern #' num2str(i_pattern) ': ' char(pattern_type ) ' set. DH-spots: ' char(pattern_label)])
for i_plot = 1:numel(columns_idx)
    
    subplot(1, n_columns, columns_idx(i_plot));
    
    c1 = (i_plot - 1)*n_cells_by_column + 1;
    c2 = min(n_cells, i_plot*n_cells_by_column);
    idx = cells_idx(c1:c2);

    title_txt = ['cells ' num2str(c1) ':' num2str(c2)];
    
    if do_dead_times
        dt_session = s.(session_label).params.reps_label;
        dead_times = getPatternDeadTimes(getExpId(), dt_session, pattern_type, i_pattern);
    else
        dead_times = [];
    end
    
    
    plotCellsRaster(spikes, pattern_reps{i_pattern}, n_steps_stim, params.meaRate, ...
        'N_Steps', n_steps_stim, ...
        'Response_Onset_Seconds', onset, ...
        'Response_Offset_Seconds', offset, ...
        'Cells_Indices', idx, ...
        'Dead_Times', dead_times, ...
        'Title', title_txt, ...
        'Column_Size', n_cells_by_column);
end
