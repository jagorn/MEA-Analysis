function computeSTAs(exp_id, varargin)
% Computes the STAs for the experiment exp_id.
% The STAs are computed on the responses to the checkerboard stimulus.
% THE STAs are also defactorized in temporal and spatial component.
% The STAs are saved as a .mat file in the experiment folder.
%
% Parameters:
% EXP_ID:                   the identifier of the experiment
% DO_SMOOTHING (OPTIONAL):  if true, it smooths the stas before defactorization.
% LABEL (OPTIONAL):         the name of the STAs (in case you want compute different versions of them).

do_smoothing_def = true;
label_def = "";

% Parse Input
p = inputParser;
addRequired(p, 'exp_id');
addParameter(p, 'Do_Smoothing', do_smoothing_def);
addParameter(p, 'Label', label_def);

parse(p, exp_id, varargin{:});
do_smoothing = p.Results.Do_Smoothing;
label = p.Results.Label;

checker_id = 'checkerboard';
checker_table = findSections(exp_id, checker_id);

if numel(checker_table) == 0
    fprintf("\n checkerboard not found for experiment %s\n\n", exp_id);
    return
end

if numel(checker_table) > 1
    fprintf("\nThere is more than one checkerboard session.\n" + ...
                "Which one do you want to use to compute the STA?\n\n");
    disp(struct2table(checker_table));
    fprintf("\n type a number between 1 and %i\n",  numel(checker_table));
    
    i_checker = input('');
    checker_table = checker_table(i_checker);
end

fprintf('\nloading parameters...\n');
checkerboard_configs_file = configFile(exp_id, checker_table.id);
sta_params = parseConfigurationFile(checkerboard_configs_file);

fprintf('\ngenerate all files...\n');
Frames = checker_table.triggers;
frames_file = fullfile(sectionPath(exp_id, checker_table.id), 'Frames.mat');
save(frames_file, 'Frames');

SpikeTimes = getSpikeTimes(exp_id);
spikes_file = fullfile(sectionPath(exp_id, checker_table.id), 'SpikeTimes.data');
save(spikes_file, 'SpikeTimes');

binary_file = fullfile(stimPath('checkerboard'), 'binary', 'binarysource1000Mbits');

fprintf('\nsaving parameters...\n');
section = getSection(exp_id, checker_table.id);
sta_params('frame_rate') = round(section.rate);
sta_params('triggers_file') = num2str(frames_file);
sta_params('binary_file') = binary_file;
sta_params('spikes_file') = spikes_file;
sta_params('channels') = 1:numel(SpikeTimes);
params_file = fullfile(sectionPath(exp_id, checker_table.id), 'StaParameters.mat');
save(params_file, 'sta_params');

fprintf('\nstas will be computed with the following parameters:\n');
sta_params_keys = keys(sta_params);
for i_params = 1:numel(sta_params_keys)
    key = sta_params_keys{i_params};
    val = sta_params(key);
    if isnumeric(val)
        val = num2str(val);
    end
    fprintf('\t %s: %s\n', key, val)
end

fprintf('\ncomputing stas...\n');
main_Offline_STA
[temporal, spatial, rfs, valid] = decomposeSTA(STAs, 'Do_Smoothing', do_smoothing);
saveSTAs(exp_id, STAs, temporal, spatial, rfs, valid, 'Label', label)
