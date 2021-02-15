function polarities = getPolarity(temporalSTAs)

n_cells = size(temporalSTAs, 1);
for i_cell = 1:n_cells
    if   abs(max(temporalSTAs(i_cell, :))) > abs(min(temporalSTAs(i_cell, :)))
        polarities(i_cell) = "ON";
    else
        polarities(i_cell) = "OFF";
    end
end

