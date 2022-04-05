clear
close all
clc

experiments = ["20210326", "20211007", "20211109"];

psth_euler_control = [];
psth_euler_strychnine = [];

psth_surround_control = [];
psth_surround_strychnine = [];

isi = [];
t_isi = 0.001:0.002:0.2;

cellsTable.N = [];
cellsTable.experiment = [];
cellsTable.grade = [];

sta_spatial = [];
sta_temporal = [];

i_cell = 1;

for exp = experiments   
    
    euler_file = strcat('Strychnine/Data/', exp, '_euler_grade_isi.mat');
    surround_file = strcat('Strychnine/Data/', exp, '_surround_psths.mat');
    sta_file = strcat('Strychnine/Data/', exp, '_sta_data.mat');
    
    load(euler_file, 'euler_bin_edges');
    load(surround_file, 't_psth');
    load(sta_file, 'spatial', 'temporal');
    
    if exist('t_surround_psth', 'var')
        assert(isequal(t_surround_psth, t_psth));
    else
        t_surround_psth = t_psth;
    end
        
    if exist('t_euler_psth', 'var')
        assert(isequal(t_euler_psth, euler_bin_edges));
    else
        t_euler_psth = euler_bin_edges;
    end
    
    trace_exists = true;
    i_trace = 0;
    
    while trace_exists
        datafield = strcat('temp_', num2str(i_trace));
        load(euler_file, datafield);
        
        if exist(datafield, 'var')
            
            d = eval(datafield);
            
            % cell grade
            grade = d.grade;
            if ~ischar(grade)
                grade = char('F' - grade);
            end
            
            if ~(grade == 'A' || grade == 'B')
                i_trace = i_trace + 1;
                continue;
            end
            
            % cellsTable
            cellsTable(i_cell).N = i_trace;
            cellsTable(i_cell).experiment = exp;
            cellsTable(i_cell).grade = grade;
            
            % isi
            isi(i_cell, :) = histc(d.isi, t_isi);
            
            % psths
            psth_euler_control(i_cell, :) = d.control.euler_count_smoothed;
            psth_euler_strychnine(i_cell, :) = d.strychnine.euler_count_smoothed;
            
            % clear
            clear(datafield)
            
            % surround
            load(surround_file, 'psths');
                        
            psth_surround_control(i_cell, :) = psths.surround_flash_control(i_trace + 1, :);
            psth_surround_strychnine(i_cell, :) = psths.surround_flash_strychnine(i_trace + 1, :);
            
            
            % sta
            sta_spatial(i_cell, :, :) = spatial(i_trace + 1, :, :);
            sta_temporal(i_cell, :) = temporal(i_trace + 1, :);
    
            % clear
            clear(datafield);
            i_trace = i_trace + 1;
            i_cell = i_cell + 1;
            
        else
            trace_exists = false;
        end  
    end
end

save('strychnine.mat', 'cellsTable', 'isi', 't_isi', 'psth_euler_control', 'psth_euler_strychnine', 't_euler_psth');
save('strychnine.mat', 'psth_surround_control', 'psth_surround_strychnine', 't_surround_psth', '-append');
save('strychnine.mat', 'sta_spatial', 'sta_temporal', '-append');