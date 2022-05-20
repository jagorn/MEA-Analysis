
% addpath(genpath(pwd));

% EXPLANATIONS about the program (stimulus file known in advance)

% * Set the default parameters in default_parameters

% * Set the parameters in set_parameters

% * add Offline STA directory to MATLAB path

% * run main_Offline_STA


%% add: something to keep all the spk times ? Something to plot during the experiment? tools to follow the results? what do we want to keep in the end?
%%
% clc   %Clear Command Window
% clear
% close all

%%%%%%%%%%% Parameters %%%%%%%%%%%%%

set_parameters

%%%%%%%%% Variables %%%%%%%%%%

set_variables

if ~is_one_file_per_cell
    R = load(spikes_file,'-mat','SpikeTimes');
end

fprintf('Beginning computation \n');

for ii = Channels(:)'
    
    tic
    
    if is_one_file_per_cell
        spikes_file_path = [spikes_file int2str(ii) '.mat'];
    end
    
    if is_one_file_per_cell
        if exist(spikes_file_path,'file')
            R = load(spikes_file_path,'SpikeTime');
            SpikeTime = R.SpikeTime;
            
            compute_channel = 1;
            
        else
            fprintf(['Could not find file ' spikes_file_path((end-70):end) '\n']);
            compute_channel = 0;
        end
    elseif ~is_one_file_per_cell
        if ii<=length(R.SpikeTimes)
            if ~isempty(R.SpikeTimes{ii})
                SpikeTime = R.SpikeTimes{ii};
                
                compute_channel = 1;
            else
                fprintf(['No spikes for channel ' int2str(ii) '\n']);
                compute_channel = 0;
            end
        else
            fprintf(['No SpikeTimes data for channel ' int2str(ii) '\n']);
        end
    end
    
    
    if compute_channel
        treat_time_array_offline(treated,Frames,SpikeTime, ii,IS,checkerboard, wrong_trig_ind);
        
        t_ii = toc;
        
        if 0<treated.Nspk(ii)
            treated.STA{ii} = treated.STA{ii}/treated.Nspk(ii);
        end
        
        STA = treated.STA{ii};
        Nspk = treated.Nspk(ii);
        
        if is_one_file_per_cell % Save result for 1 channel
%             results_save_path = [spikes_file int2str(ii) '_STA_' int2str(IS.Nlatency) 'TimeBins.mat'];
%             save(results_save_path,'STA','Nspk');
        end
        
        fprintf( 'Cell %d has been processed in %d min %d s: %d spikes \n',ii, floor(t_ii/60), t_ii - 60*floor(t_ii/60),Nspk);
        
    end
    
end
%%
if ~is_one_file_per_cell % Save result for ALL channels computed
    STAs = treated.STA;
    Nspks = treated.Nspk;
%     [sta_folder, ~, ~] = fileparts(spikes_file);
%     save([sta_folder '/' 'Sta.mat'], 'STAs', 'Nspks');
end

fprintf('Computation is finished \n')





