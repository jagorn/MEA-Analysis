%% Variables computed from the parameters

if IS.SkipRep && (IS.MaxLat<IS.Nlatency)
    error('IS.MaxLat must be set superior or equal to IS.Nlatency');
end

IS.Latencies = (-IS.Nlatency+1):0;

%stim_times_lengths = 5; %in minutes  : Duration of stim_times arrays
stim_normal_delay = ceil(MEA_recording_freq/stim_freq); % 667; %
%stim = expendable_array(stim_freq*stim_times_lengths*60,IS,stim_normal_delay,stim_max_difference);  %////Must be of lenghts at least superior to Nlatency (21)

% Class containing the results ( not a struct, but a handle : the properties modified in functions will also be modified outside)
treated = AnalysisResults(max(Channels),IS,1,'Offline');  % 1 has no influence here

if strcmp(StimFileFormat,'.mat')
    if isempty(strfind(IS.StimFilePath,'.mat'))
        error('Stimulus file was specified as .mat but it is not. Use convert_stim_from_binary_file for conversion, or specify binary format instead');
    end
    
    if isempty(strfind(IS.StimFilePath,['_nsq' int2str(IS.NCheckerboard1) '_'])) && isempty(strfind(IS.StimFilePath,['_Nsq' int2str(IS.NCheckerboard1) '_']))
        error(['Stimulus file name (IS.StimFilePath) must contain the number of squarres per side written in the form _Nsq' int2str(IS.NCheckerboard1) ...
            ' _ with ' int2str(IS.NCheckerboard1) ' the number you specified. Use convert_stim_from_binary_file for conversion ']);
    end
end

if IS.NCheckerboard1 ~= IS.NCheckerboard2
    fprintf('BEWARE: NCheckerboard1 and NCheckerboard2 are different, but in the program used in our team, it is always the same. Please be sure the the checkerboard file is correct, than remove this error by hand');
end



%Load stimulus triggers
vars_triggers_file = whos('-file',triggers_file);
if ismember('Frames', {vars_triggers_file.name})
    load(triggers_file,'Frames');
elseif  ismember('peak_times', {vars_triggers_file.name})
    R_Frames = load(triggers_file,'-mat','peak_times');
    Frames = R_Frames.peak_times;
    clear R_Frames;
else
    error('Could not find variable Frames or peak_times (array of the trigger times) in triggers_file');
end

Frames = Frames(:); % make it a column matrix


% get index i of triggers that are ill received and that should not be used
% i.e. t_i - t_(i-1)  not in  [stim_normal_delay-stim_max_difference, stim_normal_delay+stim_max_difference]
wrong_trig_ind = get_wrong_trig_ind(Frames, stim_normal_delay, stim_max_difference, IS.Latencies);

if length(wrong_trig_ind) > 10*length(IS.Latencies)
    fprintf(' \n\n *** *** *** *** *** \n\n');
    fprintf('BEWARE : many inter trigger intervals have inappropriate lengths : check stimulus frequency !');
    fprintf(' \n\n *** *** *** *** *** \n\n');
end

if ~isempty(strfind(spikes_file,'.data'))
    vars_spikes_file = whos('-file',spikes_file);
    if ismember('SpikeTimes',{vars_spikes_file.name})
        is_one_file_per_cell = 0; % all the results are stored in the same cell SpikeTimes
    else
        is_one_file_per_cell = 1; % there is one file containing SpikeTime for EACH cell
    end
else
    is_one_file_per_cell = 1; % there is one file containing SpikeTime for EACH cell
end


%% Stimulus file

% Load stimulus
if strcmp(StimFileFormat,'.mat')
    load(IS.StimFilePath,'checkerboard');
    if size(checkerboard,3)<get_min_Nframes_from_Ntrig( IS, length(Frames))
        error(['The checkerboard in the stimulus file is too short. Make it longer in convert_stim_from_binary_file by choosing Nframe_max >= ' int2str(get_min_Nframes_from_Ntrig( IS, length(Frames))) ]);
    end
else
    fprintf(' Preparing stimulus from binary file. This can take some moment. \n\n Consider specifying a .mat if different experiments share the same number of squarres per screen side \n\n');
    checkerboard =  stim_from_binary_file(IS.StimFilePath,IS.NCheckerboard1, IS.NCheckerboard2, get_min_Nframes_from_Ntrig( IS, length(Frames)));
end

fprintf('Stimulus is ready');


