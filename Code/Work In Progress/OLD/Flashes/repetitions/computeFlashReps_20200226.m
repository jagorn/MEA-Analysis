clear

% Params
exp_id = '20200226_jaws';
flash_types = ["FLASH_500ms", "FLASH_1s", "FLASH_2s", "FLASH_5s"];

ctrl_dt = 1;  % seconds, time interval before the stimulus starts in the repetitions
resp_dt = 0.5; % seconds, time interval after the onset to evaluate the response
pause_dt = 1;

repetitions.mea_rate = 20000;

% Paths and files
vars_path = [dataPath(), '/' exp_id '/processed'];
flashes_path = [vars_path '/Flashes'];

% Repetitions
for flash_type = flash_types
    
    load([flashes_path '/' char(flash_type ) '_reps.mat'], 'rep_begin', 'rep_end');
    
    ctrl_n_steps = ctrl_dt*repetitions.mea_rate;
    stim_n_steps = median(rep_end-rep_begin);   
    stim_dt = stim_n_steps/repetitions.mea_rate;
    stim_end = ctrl_dt + stim_dt;

    repetitions.stim_dt = stim_dt;
    repetitions.begin = rep_begin - ctrl_n_steps;
    
    repetitions.FlashWin = [ctrl_dt, ctrl_dt + stim_dt];
    repetitions.PauseWin = [ctrl_dt + stim_dt, pause_dt];
    
    repetitions.dt = ctrl_dt + stim_dt + pause_dt; % seconds
    repetitions.n_steps = repetitions.dt * repetitions.mea_rate;

    repetitions.ONCtrlWin = [ctrl_dt - 0.5, ctrl_dt - 0.05];
    repetitions.ONRespWin = [stim_end, stim_end + resp_dt];
    
    repetitions.OFFCtrlWin = [ctrl_dt - 0.5, ctrl_dt - 0.05];
    repetitions.OFFRespWin = [stim_end, stim_end + resp_dt];

    repetitions_file = [flashes_path '/' char(flash_type) '.mat'];
    save(repetitions_file, 'repetitions');
end
