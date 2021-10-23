function computeHolographyPSTHs(exp_id, varargin)

% Parameters Sorting Files
time_spacing_def = 0.5;
sections_def = [];
compute_activations = true;
control_win_def = [-0.3, 0];
response_win_def = [0.1, .4];
sigma_def = 5;
min_fr_def = 25;

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Time_Spacing', time_spacing_def);
addParameter(p, 'Sections', sections_def);
addParameter(p, 'Activations', compute_activations);
addParameter(p, 'Control_Window', control_win_def);
addParameter(p, 'Response_Window', response_win_def);
addParameter(p, 'Sigma', sigma_def);
addParameter(p, 'Min_Firing_Rate', min_fr_def);

parse(p, exp_id, varargin{:});

time_spacing = p.Results.Time_Spacing;
sections = p.Results.Sections;
do_activations = p.Results.Activations;
ctrl_win = p.Results.Control_Window;
resp_win = p.Results.Response_Window;
sigma = p.Results.Sigma;
min_fr = p.Results.Min_Firing_Rate;

spikes = getSpikeTimes(exp_id);
mea_rate = getMeaRate(exp_id);
holoTable = getHolographyTable(exp_id);

try
    holo_psths = getHolographyPSTHs(exp_id);
catch error
    disp(error.message);
end

if isempty(sections)
    sections = 1:numel(holoTable);
end

for i_section = sections(:)'
    
    if isempty(holoTable(i_section).repetitions)
        continue;
    end
    
    label = holoTable(i_section).id;
    holo_psth = sectionMultiPSTH(label, spikes, holoTable(i_section).repetitions, mea_rate, 'Time_Spacing', time_spacing);
    holo_psths(i_section).psth = holo_psth;
    
    if do_activations
        [zs, thresholds, scores] = estimateMultiActivation(holo_psth, ctrl_win, resp_win, sigma, min_fr);
        holo_psths(i_section).activations.zs = zs;
        holo_psths(i_section).activations.thresholds = thresholds;
        holo_psths(i_section).activations.scores = scores;
        holo_psths(i_section).ctrl_win = ctrl_win;
        holo_psths(i_section).resp_win = resp_win;
        holo_psths(i_section).psth.pattern_positions = holoTable(i_section).positions;
    end
end
setHolographyPSTHs(exp_id, holo_psths)