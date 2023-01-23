 function mosaics = convertStaTable(controlTable, size_min_mosaic, duplicate_cells, temporalSTAs)

mosaics_count = 0;

for i_control = 1:numel(controlTable)
    c = controlTable(i_control);        
    idx = c.indices & ~duplicate_cells;
    
    if sum(idx) >= size_min_mosaic
        
        tsta = mean(temporalSTAs(idx, :));
        mosaics_count = mosaics_count + 1;
        mosaics(mosaics_count).id = strcat(c.class, " ", c.experiment);
        mosaics(mosaics_count).type = c.class;
        mosaics(mosaics_count).polarity = getPolarity(tsta);
        mosaics(mosaics_count).experiment = c.experiment;
        mosaics(mosaics_count).size = sum(idx);
        mosaics(mosaics_count).idx = idx;
    end
end

