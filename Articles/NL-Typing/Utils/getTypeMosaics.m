 function mosaics = getTypeMosaics(cellsTable, types, size_min_mosaic, duplicate_cells)

experiments = unique([cellsTable.experiment]);

mosaics_count = 0;
for i_type = 1:numel(types)
    type = types(i_type);
    type.indices;
    
    for i_experiment = 1:numel(experiments)
        experiment = experiments(i_experiment);        
        mosaic_idx = type.indices & ([cellsTable.experiment] == experiment) & ~duplicate_cells;
        if sum(mosaic_idx) >= size_min_mosaic 
            mosaics_count = mosaics_count + 1;
            mosaics(mosaics_count).id = strcat(type.name, " ", experiment);
            mosaics(mosaics_count).type = type.name;
            mosaics(mosaics_count).polarity = type.POLARITY;
            mosaics(mosaics_count).experiment = experiment;
            mosaics(mosaics_count).size = sum(mosaic_idx);
            mosaics(mosaics_count).idx = mosaic_idx;
        end
    end
end

