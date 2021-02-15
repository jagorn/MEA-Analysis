%%%%%%%%  Parameters to load at the begining %%%%%%%
LastTime = zeros(1,6);
experiment_folder='/media/chris/Packard Bell/Users/Chris/Desktop/Sauvegarde/cours/LPS - IV/code/Offline STA - 2014 02 18 - Christophe Gardella/Data Folder/'; %'D:\Users\serge\Desktop\Chris\Online STA - 2014 02 13 - Christophe Gardella\Data Folder\';

load([experiment_folder 'current_parameters_file.mat']);  %load SAVENAME, IS and and STIM
load('Index_buttons.mat');  % contains the names of the buttons for GUI_electrodes
load('Index_names.mat');  % contains the electrode number associated to each location

channels_list = [];

Nchan = 252;

treated = AnalysisResults(Nchan,IS,1);

choice = 1;

while choice>0
    
    if choice == 1   %%%%%%%%% Update data %%%%%%%%%
        
        [channels_list,isChanges] = find_most_recent_data_Offline_analysis(channels_list,experiment_folder,savename);    
        if isChanges
            for ii = 1:Nchan
                if (treated.Nspk(ii) == 0 && ismember(ii,channels_list))
                    load([savename '_ch_' int2str(ii) '.mat']);
                    treated.STA{ii} = STA;
                    treated.Nspk(ii) = Nspk;
                    clear STA
                    clear Nspk
                end
            end
                    
            fprintf('New channel(s) found and loaded : now %d channels \n',length(channels_list));
            
        else
            fprintf('No new channel found : now %d channels \n',length(channels_list));
        end
        
        plotdata = data_for_plot (treated,IS);
        
        
    elseif choice == 2 %%%%% Space STA for all electrodes, in an array %%%%%%%
        
        plot_space_electrode_array;
        
    elseif choice == 3 %%%%%%%% Time evolution for all electrodes, in an array %%%%%%%%
        
        plot_time_electrode_array;
        
    elseif choice == 4  %%%%%%%% Time evolution for selected electrodes %%%%%
        
        GUI_selected_time_STA(plotdata);
        
    elseif choice == 5  %%%%%%% Space STA for selected electrodes %%%%%%
        GUI_selected_space_STA(plotdata);
    end
    
    choice = input('Press : \n 0 to quit \n 1  to update data if possible \n 2 to plot spatial STA with electrodes positions  \n 3  to plot temporal STA with electrodes positions \n 4  to plot temporal STA of selected electrodes \n 5  to plot spatial STA of selected electrodes \n   ');
    
end