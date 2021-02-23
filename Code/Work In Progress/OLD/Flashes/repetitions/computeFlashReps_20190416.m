clear

% Params
exp_id = '20190416_gtacr';
flash_types = ["FLASHES", "FLASHES_40nd100p", "FLASHES_30nd100p", "FLASHES_20nd30p", "FLASHES_20nd100p0002"];

repetitions.FlashWin = [1 2];
repetitions.PauseWin = [2 3];

repetitions.ONCtrlWin = [0.5 0.95];
repetitions.ONRespWin = [1 2];
repetitions.OFFCtrlWin = [1.5 1.95];
repetitions.OFFRespWin = [2 3];

repetitions.dt = 5; % seconds
repetitions.mea_rate = 20000;

% Paths and files
vars_path = [dataPath(), '/' exp_id '/processed'];
flashes_path = [vars_path '/Flashes'];

stims_order_file = [vars_path '/stims_order.txt'];
stims_order = importdata(stims_order_file);

triggers_file = [vars_path '/trigT_stim_short.mat'];
load(triggers_file, 'trigT_stim');

% Repetitions
for flash_type = flash_types
    trigs_idx = find(strcmp(stims_order, flash_type));
    triggers = trigT_stim{trigs_idx};
    
    repetitions.begin = triggers(1:2:end)*repetitions.mea_rate;  % Go from seconds to time_steps 
    repetitions.n_steps = repetitions.dt*repetitions.mea_rate;   % Go from seconds to time_steps 
    
    repetitions_file = [flashes_path '/' char(flash_type) '.mat'];
    save(repetitions_file, 'repetitions');
end
