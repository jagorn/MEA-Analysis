clear
close all
clc

experiments = ["20210326", "20211007", "xyz"];

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
    
    euler_file = strcat('/home/fran_tr/Desktop/Simone/Data/', exp, '_euler_grade_isi.mat');
    surround_file = strcat('/home/fran_tr/Desktop/Simone/Data/', exp, '_surround_data.mat');
    sta_file = strcat('/home/fran_tr/Desktop/Simone/Data/', exp, '_sta_data.mat');
    
    load(euler_file, 'euler_bin_edges');
    load(surround_file, 'surround_flash_bin_edges');
    load(sta_file, 'spatial', 'temporal');
    
    sta_spatial = [sta_spatial; spatial];
    sta_temporal = [sta_temporal; temporal];
    
    if exist('t_surround_psth', 'var')
        assert(isequal(t_surround_psth, surround_flash_bin_edges));
    else
        t_surround_psth = surround_flash_bin_edges;
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
            
            % cellsTable
            cellsTable(i_cell).N = i_trace;
            cellsTable(i_cell).experiment = exp;
            cellsTable(i_cell).grade = d.grade;
            
            % isi
            isi(i_cell, :) = histc(d.isi, t_isi);
            
            % psths
            psth_euler_control(i_cell, :) = d.control.euler_count_smoothed;
            psth_euler_strychnine(i_cell, :) = d.strychnine.euler_count_smoothed;
            
            % clear
            clear(datafield)
            
            % surround
            load(surround_file, datafield);
            
            s = eval(datafield);
            
            psth_surround_control(i_cell, :) = s.control.surround_flash_count_smoothed;
            psth_surround_strychnine(i_cell, :) = s.strychnine.surround_flash_count_smoothed;
            
            % clear
            clear(datafield);
            i_trace = i_trace + 1;
            i_cell = i_cell + 1;
            
        else
            trace_exists = false;
        end  
    end
end

save('/home/fran_tr/Desktop/Simone/strychnine.mat', 'cellsTable', 'isi', 't_isi', 'psth_euler_control', 'psth_euler_strychnine', 't_euler_psth');
save('/home/fran_tr/Desktop/Simone/strychnine.mat', 'psth_surround_control', 'psth_surround_strychnine', 't_surround_psth', '-append');
save('/home/fran_tr/Desktop/Simone/strychnine.mat', 'sta_spatial', 'sta_temporal', '-append');